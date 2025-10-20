import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_umkm/services/firestore.service.dart';

class OrdersController with ChangeNotifier {
  final FirestoreService firestoreService = FirestoreService();

  int pendingPayments = 0;
  int inProcess = 0;
  int shipped = 0;
  int completed = 0;

  StreamSubscription<QuerySnapshot>? _subscription;

  void startListening(String uid) async {
    final queryType = await _detectUserType(uid);

    if (queryType == "buyer") {
      print("Detected as BUYER");
      _subscription = firestoreService
          .getByUser(collectionName: "orders", uid: uid)
          .listen(_handleSnapshot);
    } else if (queryType == "seller") {
      print("Detected as SELLER");
      _subscription = firestoreService
          .getByField(collectionName: "orders", field: "seller", value: uid)
          .listen(_handleSnapshot);
    } else {
      print("Tidak ditemukan pesanan untuk UID ini");
    }
  }

  void stopListening() {
    _subscription?.cancel();
  }

  void _handleSnapshot(QuerySnapshot snapshot) {
    pendingPayments = 0;
    inProcess = 0;
    shipped = 0;
    completed = 0;

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final status = data['status'];
      switch (status) {
        case 'pending_payment':
          pendingPayments++;
          break;
        case 'in_process':
          inProcess++;
          break;
        case 'shipped':
          shipped++;
          break;
        case 'completed':
          completed++;
          break;
      }
    }

    notifyListeners();
  }

  Future<String?> _detectUserType(String uid) async {
    final buyerSnapshot = await firestoreService.getOnceByField(
      collectionName: "orders",
      field: "uid",
      value: uid,
    );

    if (buyerSnapshot.docs.isNotEmpty) return "buyer";

    final sellerSnapshot = await firestoreService.getOnceByField(
      collectionName: "orders",
      field: "seller",
      value: uid,
    );

    if (sellerSnapshot.docs.isNotEmpty) return "seller";

    return null;
  }

  Stream<QuerySnapshot> getOrdersByStatus({
    required String uid,
    required String status,
  }) async* {
    final collection = FirebaseFirestore.instance.collection("orders");

    final buyerSnapshot = await collection
        .where('uid', isEqualTo: uid)
        .where('status', isEqualTo: status)
        .get();

    if (buyerSnapshot.docs.isNotEmpty) {
      yield* collection
          .where('uid', isEqualTo: uid)
          .where('status', isEqualTo: status)
          .snapshots();
    } else {
      yield* collection
          .where('seller', isEqualTo: uid)
          .where('status', isEqualTo: status)
          .snapshots();
    }
  }

  Stream<QuerySnapshot> getAllOrders({required String uid, String? sellerUID}) {
    return firestoreService.getByUser(
      collectionName: "orders",
      uid: uid,
      sellerUID: sellerUID,
    );
  }

  Future<List<Map<String, dynamic>>> fetchOrdersOnce({
    required String uid,
    String? sellerUID,
    String? status,
  }) async {
    final collection = FirebaseFirestore.instance.collection("orders");
    Query query = collection;

    if (sellerUID != null && sellerUID.isNotEmpty) {
      query = query.where('seller', isEqualTo: sellerUID);
    } else {
      query = query.where('uid', isEqualTo: uid);
    }

    if (status != null && status.isNotEmpty) {
      query = query.where('status', isEqualTo: status);
    }

    final snapshot = await query.get();

    return snapshot.docs.map((doc) {
      return {"id": doc.id, ...doc.data() as Map<String, dynamic>};
    }).toList();
  }

  Future<void> editOrders({
    required BuildContext context,
    required String collectionName,
    required Map<String, dynamic> data,
    required String docId,
    String successMessage = "Data berhasil disimpan",
  }) async {
    try {
      await firestoreService.setData(
        collectionName: collectionName,
        docId: docId,
        data: data,
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(successMessage)));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal menyimpan data: $e")));
    }
  }
}
