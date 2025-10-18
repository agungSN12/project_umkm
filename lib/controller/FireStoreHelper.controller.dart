import 'package:flutter/material.dart';
import 'package:project_umkm/services/firestore.service.dart';

class FirestoreHelper {
  final FirestoreService firestoreService = FirestoreService();

  Future<void> submitToFirestore({
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
}
