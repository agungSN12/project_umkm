import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:project_umkm/services/firestore.service.dart';

class LocationService {
  final FirestoreService firestoreService = FirestoreService();

  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }
    if (permission == LocationPermission.deniedForever) return null;

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  // Future<void> saveLocationToFirestore({
  //   required String userId,
  //   required double latitude,
  //   required double longitude,
  // }) async {
  //   await firestoreService.addData(
  //     collectionName: 'locationDetail',
  //     data: {
  //       'userId': userId,
  //       'latitude': latitude,
  //       'longitude': longitude,
  //       // 'timestamp': FieldValue.serverTimestamp(),
  //     },
  //   );
  // }

  Future<void> saveLocationToFirestore({
    required String userId,
    required double latitude,
    required double longitude,
  }) async {
    await firestoreService.setData(
      collectionName: 'locationDetail',
      docId: userId,
      data: {
        'userId': userId,
        'latitude': latitude,
        'longitude': longitude,
        'updatedAt': FieldValue.serverTimestamp(),
      },
    );

    print('Lokasi user $userId disimpan atau diperbarui.');
  }

  Future<Map<String, dynamic>?> getLocationByUserId(String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection("locationDetail")
        .where("userId", isEqualTo: userId)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return snapshot.docs.first.data();
    }

    return null;
  }
}
