import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_umkm/model/chartModel.dart';

class FirebaseService {
  static final COLLECTION_REF = 'cart';
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late final CollectionReference cartRef;

  FirebaseService() {
    cartRef = firestore.collection(COLLECTION_REF);
  }

  Stream<QuerySnapshot<Object?>> getCart() {
    return cartRef.snapshots();
  }

  void addCart(Cart cart) {
    DocumentReference documentReference = cartRef.doc(cart.name);
    documentReference.set(cart.toMap());
  }

  void deleteCart(String productId) {
    cartRef
        .where('productId', isEqualTo: productId)
        .get()
        .then((snapshot) {
          for (var doc in snapshot.docs) {
            doc.reference.delete();
          }
          print(
            "🗑️ Item dengan productId $productId berhasil dihapus dari Firestore",
          );
        })
        .catchError((e) {
          print("❌ Gagal menghapus item: $e");
        });
  }
}
