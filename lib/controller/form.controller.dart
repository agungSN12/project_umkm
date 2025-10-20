import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_umkm/services/firestore.service.dart';

class FirestoreHelper {
  final FirestoreService firestoreService = FirestoreService();

  Future<void> addData({
    required BuildContext context,
    required String collectionName,
    required Map<String, dynamic> data,
    List<String> requiredFields = const [],
    String successMessage = "Data berhasil disimpan ke Firestore",
  }) async {
    for (final field in requiredFields) {
      final value = data[field];
      if (value == null || value.toString().trim().isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Field '$field' harus diisi")));
        return;
      }
    }

    try {
      await firestoreService.addData(
        collectionName: collectionName,
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

  Future<Map<String, dynamic>?> getDocument({
    required String collectionName,
    required String docId,
  }) async {
    return await firestoreService.getData(
      collectionName: collectionName,
      docId: docId,
    );
  }

  Future<List<Map<String, dynamic>>> getAllDocuments({
    required String collectionName,
  }) async {
    return await firestoreService.getAllData(collectionName: collectionName);
  }

  Future<void> updateData({
    required BuildContext context,
    required String collectionName,
    required String docId,
    required Map<String, dynamic> data,
    String successMessage = "Data berhasil diperbarui",
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
      ).showSnackBar(SnackBar(content: Text("Gagal memperbarui data: $e")));
    }
  }

  Future<void> deleteData({
    required BuildContext context,
    required String collectionName,
    required String docId,
    String successMessage = "Data berhasil dihapus",
  }) async {
    try {
      await firestoreService.deleteData(
        collectionName: collectionName,
        docId: docId,
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(successMessage)));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal menghapus data: $e")));
    }
  }

  Stream<QuerySnapshot> streamDocumentsByUser({
    required String collectionName,
    required String uid,
  }) {
    return firestoreService.getByUser(collectionName: collectionName, uid: uid);
  }
}
