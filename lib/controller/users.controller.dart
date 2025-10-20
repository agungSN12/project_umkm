import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_umkm/controller/location.controller.dart';
import 'package:project_umkm/model/users.model.dart';
import 'package:project_umkm/services/auth.service.dart';
import 'package:provider/provider.dart';

class userController extends ChangeNotifier {
  List<Users> _users = [];
  List<Users> get users => _users;

  Users? _selectedUser;
  Users? get selectedUser => _selectedUser;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchUsersByRole(BuildContext context, String role) async {
    _isLoading = true;
    notifyListeners();

    try {
      final auth = Provider.of<AuthService>(context, listen: false);
      _users = await auth.fetchUsersByRole(role);
    } catch (e) {
      debugPrint("Error fetchUsersByRole: $e");
      _users = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  void selectUser(Users user) {
    _selectedUser = user;
    notifyListeners();
  }

  void clearSelectedUser() {
    _selectedUser = null;
    notifyListeners();
  }

  Future<void> fetchUsersByRoleSortedByDistance(
    BuildContext context,
    LatLng customerLocation,
    String role,
  ) async {
    final auth = Provider.of<AuthService>(context, listen: false);
    _users = await auth.fetchUsersByRole(role);
    List<Map<String, dynamic>> usersWithDistance = [];

    for (var user in users) {
      LatLng? sellerLocation = await LocationController().getLocation(user.uid);
      if (sellerLocation != null) {
        double distance = _calculateDistance(
          customerLocation.latitude,
          customerLocation.longitude,
          sellerLocation.latitude,
          sellerLocation.longitude,
        );
        usersWithDistance.add({'user': user, 'distance': distance});
      }
    }

    usersWithDistance.sort((a, b) => a['distance'].compareTo(b['distance']));

    _users = usersWithDistance.map((e) => e['user'] as Users).toList();
    notifyListeners();
  }

  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const R = 6371;
    final dLat = _deg2rad(lat2 - lat1);
    final dLon = _deg2rad(lon2 - lon1);

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_deg2rad(lat1)) *
            cos(_deg2rad(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  double _deg2rad(double deg) => deg * (pi / 180);
}
