import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'package:project_umkm/model/users.model.dart';

class AuthService with ChangeNotifier {
  static final COLLECTION_REF = 'users';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  late final CollectionReference usersRef;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  User? _user;
  User? get user => _user;

  AuthService() {
    _auth.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
    usersRef = firestore.collection(COLLECTION_REF);
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

      final usersModel = Users(
        uid: _user!.uid,
        name: _user!.displayName ?? '',
        email: _user!.email ?? '',
        photoURL: _user!.photoURL ?? '',
        role: role,
      );
      DocumentReference documentReference = usersRef.doc(_user!.uid);
      documentReference.set(usersModel.toMap());

      debugPrint("Login dengan Google berhasil!");
    } catch (e) {
      debugPrint("Error saat login dengan Google: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Users?> getCurrentUserData() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        debugPrint("Belum ada user yang login");
        return null;
      }

      final doc = await usersRef.doc(currentUser.uid).get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return Users.fromMap(data, doc.id);
      } else {
        debugPrint("Data user tidak ditemukan di Firestore");
        return null;
      }
    } catch (e) {
      debugPrint("Error mengambil data user: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    _user = null;
    debugPrint("User berhasil logout");
    notifyListeners();
  }
}
