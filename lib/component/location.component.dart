import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:project_umkm/controller/location.controller.dart';

class PickLocationPage extends StatefulWidget {
  final String userId;
  const PickLocationPage({super.key, required this.userId});

  @override
  State<PickLocationPage> createState() => _PickLocationPageState();
}

class _PickLocationPageState extends State<PickLocationPage> {
  final LocationController locationController = LocationController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pilih Lokasi")),
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: const CameraPosition(
              target: LatLng(-6.200000, 106.816666),
              zoom: 14,
            ),
            onMapCreated: (controller) {
              locationController.mapController = controller;
            },

            onTap: (LatLng position) async {
              setState(() {
                locationController.pickedLocation = position;
              });

              locationController.mapController?.animateCamera(
                CameraUpdate.newLatLng(position),
              );

              await locationController.saveLocation(widget.userId);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Lokasi dipilih: ${position.latitude}, ${position.longitude}",
                  ),
                ),
              );
            },

            markers: locationController.pickedLocation != null
                ? {
                    Marker(
                      markerId: const MarkerId("user"),
                      position: locationController.pickedLocation!,
                    ),
                  }
                : {},
          ),

          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.my_location),
              label: const Text("Ambil Lokasi Saya"),
              onPressed: () async {
                final position = await locationController.pickLocation();
                if (position == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Tidak bisa mengambil lokasi"),
                    ),
                  );
                  return;
                }

                final latLng = LatLng(position.latitude, position.longitude);

                setState(() {
                  locationController.pickedLocation = latLng;
                });

                locationController.mapController?.animateCamera(
                  CameraUpdate.newLatLng(latLng),
                );

                await locationController.saveLocation(widget.userId);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Lokasi tersimpan silahkan melanjutkan pesanan anda",
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
