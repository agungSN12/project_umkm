import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'package:project_umkm/model/users.model.dart';
import 'package:project_umkm/services/firestore.service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService with ChangeNotifier {
  static final COLLECTION_REF = 'users';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  late final CollectionReference usersRef;
  final FirestoreService firestoreService = FirestoreService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  User? _user;
  User? get user => _user;

  Users? _currentUser;
  Users? get currentUser => _currentUser;

  AuthService() {
    _auth.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
    usersRef = firestore.collection(COLLECTION_REF);
  }

  Future<bool> registerUser(Users user) async {
    try {
      _isLoading = true;
      notifyListeners();

      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: user.email,
            password: user.password,
          );

      final firebaseUser = userCredential.user;
      if (firebaseUser == null) throw Exception("Gagal membuat akun");

      final newUser = Users(
        uid: firebaseUser.uid,
        name: user.name,
        email: user.email,
        nohp: user.nohp,
        password: user.password,
        alamat: user.alamat,
        photoURL: user.photoURL,
        role: user.role,
      );

      await firestoreService.addData(
        collectionName: "users",
        data: newUser.toMap(),
      );

      debugPrint(" User berhasil dibuat: ${firebaseUser.email}");

      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint("Firebase Auth Error: ${e.message}");
      return false;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint("Error umum saat register: $e");
      return false;
    }
  }

  Future<void> signInWithGoogle({String role = 'user'}) async {
    try {
      _isLoading = true;
      notifyListeners();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        debugPrint("Login dibatalkan user.");
        _isLoading = false;
        notifyListeners();
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      _user = userCredential.user;

      final doc = await usersRef.doc(_user!.uid).get();

      if (!doc.exists) {
        final usersModel = Users(
          uid: _user!.uid,
          name: _user!.displayName ?? '',
          email: _user!.email ?? '',
          nohp: '',
          password: '',
          alamat: '',
          photoURL: _user!.photoURL ?? '',
          role: role,
        );
        await usersRef.doc(_user!.uid).set(usersModel.toMap());
        _currentUser = usersModel;

        debugPrint("Data user disimpan lokal: ${usersModel.name}");
      } else {
        _currentUser = Users.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }

      debugPrint("Login dengan Google berhasil!");
      notifyListeners();
    } catch (e) {
      debugPrint("Error saat login dengan Google: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signInWithUsernameAndPassword(
    String username,
    String password,
  ) async {
    try {
      _isLoading = true;
      notifyListeners();

      bool isEmail = username.contains('@');

      final querySnapshot = await usersRef
          .where(isEmail ? 'email' : 'name', isEqualTo: username)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        debugPrint("Username atau email tidak ditemukan");
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
      final storedPassword = userData['password'];

      if (storedPassword != password) {
        debugPrint("Password salah");
        _isLoading = false;
        notifyListeners();
        return false;
      }

      debugPrint("Login berhasil: ${userData['name']}");

      final usersModel = Users.fromMap(userData, querySnapshot.docs.first.id);
      _currentUser = usersModel;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('uid', querySnapshot.docs.first.id);
      await prefs.setString('username', usersModel.name);
      await prefs.setString('email', usersModel.email);
      await prefs.setString('role', usersModel.role);
      await prefs.setString('photoURL', usersModel.photoURL);
      await prefs.setString('lastLogin', DateTime.now().toIso8601String());

      debugPrint("📦 Data user disimpan lokal: ${usersModel.name}");

      _isLoading = false;
      return true;
    } catch (e) {
      debugPrint("🔥 Error saat login: $e");
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> loadUserFromLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final email = prefs.getString('email');
    final photoURL = prefs.getString('photoURL');
    final role = prefs.getString('role');

    if (username != null) {
      _currentUser = Users(
        uid: prefs.getString('uid') ?? '',
        name: username,
        email: email ?? '',
        password: '',
        alamat: '',
        nohp: '',
        photoURL: photoURL ?? '',
        role: role ?? 'user',
      );

      debugPrint("🔁 Auto login: $username");
      notifyListeners();
    }
  }

  Future<void> fetchUserData() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final snapshot = await firestore.collection('users').doc(user.uid).get();

    if (snapshot.exists) {
      _currentUser = Users.fromMap(snapshot.data()!, snapshot.id);
      notifyListeners();
    }
  }

  Future<List<Users>> fetchUsersByRole(String role) async {
    try {
      final querySnapshot = await usersRef.where('role', isEqualTo: role).get();

      if (querySnapshot.docs.isEmpty) {
        debugPrint("Tidak ada user dengan role $role");
        return [];
      }

      final usersList = querySnapshot.docs.map((doc) {
        return Users.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();

      debugPrint("Ditemukan ${usersList.length} user dengan role $role");
      return usersList;
    } catch (e) {
      debugPrint("Error fetchUsersByRole: $e");
      return [];
    }
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await _auth.signOut();
    await _googleSignIn.signOut();
    await prefs.clear();
    _user = null;
    _currentUser = null;
    debugPrint("User berhasil logout");
    await Future.delayed(const Duration(milliseconds: 100));

    notifyListeners();
  }

  Future<void> trySilentGoogleLogin() async {
    try {
      final googleUser = await _googleSignIn.signInSilently();
      if (googleUser == null) {
        return;
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      _user = userCredential.user;

      final doc = await usersRef.doc(_user!.uid).get();
      if (doc.exists) {
        _currentUser = Users.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }

      notifyListeners();
    } catch (e) {
      debugPrint("Silent login gagal: $e");
    }
  }
}
