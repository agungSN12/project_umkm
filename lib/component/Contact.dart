import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Contact {
  static void show(
    BuildContext context, {
    required String title, // contoh: "Hubungi via WhatsApp"
    required String label, // contoh: "Nomor WhatsApp Toko:"
    required String value, // contoh: "628143653225"
    Color accentColor = Colors.green, // warna utama opsional
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 8),
              SelectableText(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Clipboard.setData(ClipboardData(text: value));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Data berhasil disalin ✅"),
                    duration: Duration(seconds: 2),
                  ),
                );
                Navigator.pop(context);
              },
              child: const Text("Salin"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Tutup"),
            ),
          ],
        );
      },
    );
  }
}
