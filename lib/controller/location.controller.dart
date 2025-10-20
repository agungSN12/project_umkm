import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:project_umkm/services/location.service.dart';

class LocationController {
  LatLng? pickedLocation;
  GoogleMapController? mapController;
  final LocationService locationService = LocationService();

  Future<Position?> pickLocation() async {
    Position? position = await locationService.getCurrentLocation();
    if (position != null) {
      pickedLocation = LatLng(position.latitude, position.longitude);
    }
    return position;
  }

  Future<void> saveLocation(String userId) async {
    if (pickedLocation == null) return;
    await locationService.saveLocationToFirestore(
      userId: userId,
      latitude: pickedLocation!.latitude,
      longitude: pickedLocation!.longitude,
    );
  }

  void moveCamera() {
    if (pickedLocation != null && mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(pickedLocation!, 16),
      );
    }
  }

  Future<LatLng?> getLocation(String userId) async {
    final data = await locationService.getLocationByUserId(userId);
    if (data != null && data['latitude'] != null && data['longitude'] != null) {
      return LatLng(data['latitude'], data['longitude']);
    }
    return null;
  }
}
