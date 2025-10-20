import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_umkm/services/firestore.service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartController {
  final FirestoreService firestoreService = FirestoreService();

  Future<void> addCart({
    required BuildContext context,
    required String collectionName,
    required Map<String, dynamic> data,
    required String docId,
    String successMessage = "Data berhasil disimpan ke Firestore",
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

  Future<void> checkout({
    required String uid,
    required String alamat,
    required LatLng lokasi,
    required String sellerUID,
    required String catatan,
    required String opsi_pengiriman,
    required List<Map<String, dynamic>> products,
    required num totalPrice,
    num biayaPengiriman = 11000,
    num biayaLayanan = 4000,
  }) async {
    final checkoutData = {
      "uid": uid,
      "alamat": alamat,
      "koordinat": {"lat": lokasi.latitude, "lng": lokasi.longitude},
      "catatan": catatan,
      "opsiPengiriman": opsi_pengiriman,
      "seller": sellerUID,
      "produk": products,
      "total": totalPrice,
      "biayaPengiriman": biayaPengiriman,
      "biayaLayanan": biayaLayanan,
      "grandTotal": totalPrice + biayaPengiriman + biayaLayanan,
      "status": "pending_payment",
      "createdAt": DateTime.now(),
    };

    await firestoreService.addData(
      collectionName: "orders",
      data: checkoutData,
    );
    print('Pesanan berhasil dibuat!');
  }

  Future<Map<String, dynamic>?> getCartById(String docId) async {
    return await firestoreService.getData(collectionName: "cart", docId: docId);
  }

  Future<List<Map<String, dynamic>>> getAllCart() async {
    return await firestoreService.getAllData(collectionName: "cart");
  }

  Stream<List<Map<String, dynamic>>> streamAllCart() {
    return firestoreService.streamAllData(collectionName: "cart");
  }

  Stream<QuerySnapshot> streamCartByUser(String uid) {
    return firestoreService.getByUser(collectionName: "cart", uid: uid);
  }

  Future<void> updateCart({
    required String docId,
    required Map<String, dynamic> updatedData,
  }) async {
    await firestoreService.setData(
      collectionName: "cart",
      docId: docId,
      data: updatedData,
    );
  }

  Future<void> deleteCart(String docId) async {
    await firestoreService.deleteData(collectionName: "cart", docId: docId);
  }
}
