import 'package:flutter/material.dart';
import 'package:project_umkm/services/firestore.service.dart';

class FirestoreHelper {
  final FirestoreService firestoreService = FirestoreService();

  Future<void> submitToFirestore({
    required BuildContext context,
    required String collectionName,
    required Map<String, dynamic> data,
    String successMessage = "Data berhasil disimpan ke Firestore",
  }) async {
    if (data.values.any((value) => value == null || value.toString().isEmpty)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Semua field harus diisi")));
      return;
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
}
