import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<DocumentReference> addData({
    required String collectionName,
    required Map<String, dynamic> data,
  }) async {
    DocumentReference docRef = await _firestore
        .collection(collectionName)
        .add(data);
    return docRef;
  }

  Future<DocumentReference> setData({
    required String collectionName,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    DocumentReference docRef = _firestore.collection(collectionName).doc(docId);
    await docRef.set(data, SetOptions(merge: true));
    return docRef;
  }

  Future<Map<String, dynamic>?> getData({
    required String collectionName,
    required String docId,
  }) async {
    final doc = await _firestore.collection(collectionName).doc(docId).get();

    if (doc.exists) {
      return doc.data();
    } else {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getAllData({
    required String collectionName,
  }) async {
    final querySnapshot = await _firestore.collection(collectionName).get();
    return querySnapshot.docs
        .map((doc) => {'id': doc.id, ...doc.data()})
        .toList();
  }

  Future<void> deleteData({
    required String collectionName,
    required String docId,
  }) async {
    await _firestore.collection(collectionName).doc(docId).delete();
  }

  //query all data realtime
  Stream<List<Map<String, dynamic>>> streamAllData({
    required String collectionName,
  }) {
    return _firestore.collection(collectionName).snapshots().map((
      querySnapshot,
    ) {
      return querySnapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();
    });
  }

  //filter query realtime
  Stream<QuerySnapshot> getByUser({
    required String collectionName,
    required String uid,
    String? sellerUID,
  }) {
    final collection = FirebaseFirestore.instance.collection(collectionName);

    if (sellerUID != null && sellerUID.isNotEmpty) {
      print("Ambil data untuk SELLER dengan UID: $sellerUID");
      return collection.where('seller', isEqualTo: sellerUID).snapshots();
    }

    print("Ambil data untuk USER dengan UID: $uid");
    return collection.where('uid', isEqualTo: uid).snapshots();
  }
}
