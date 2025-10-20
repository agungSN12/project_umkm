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

  void startListening(String uid, String? seller_uid) {
    _subscription = firestoreService
        .getByUser(collectionName: "orders", uid: uid, sellerUID: seller_uid)
        .listen((snapshot) {
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

          notifyListeners(); // agar UI update
        });
  }

  void stopListening() {
    _subscription?.cancel();
  }
}
