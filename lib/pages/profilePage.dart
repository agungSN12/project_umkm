import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_umkm/component/contact.component.dart';
import 'package:project_umkm/component/notification.component.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF6D4C41),
        centerTitle: true,
        title: const Text("Profil UMKM", style: TextStyle(color: Colors.white)),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: NotificationPopup(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('asset/images/abidin.png'),
            ),
            const SizedBox(height: 16),

            const Text(
              "Kiwari Bakery",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            const Text(
              "UMKM yang bergerak di bidang makanan tradisional seperti kue basah, jajanan pasar, dan aneka cemilan rumahan. Kami berkomitmen untuk menghadirkan cita rasa autentik khas Indonesia dengan bahan-bahan pilihan yang selalu segar dan berkualitas. Setiap produk dibuat dengan penuh perhatian dan kebersihan untuk memastikan kepuasan pelanggan",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, color: Colors.black54),
            ),
            const SizedBox(height: 24),

            // Tombol-tombol sosial media
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Tombol Instagram
                _buildIconButton(
                  icon: Icons.camera_alt,
                  color: Colors.pink,
                  onTap: () {
                    Contact.show(
                      context,
                      title: "Hubungi via Instagram",
                      label: "akun Instagram toko",
                      value: "kiwariBakery25",
                      accentColor: Colors.green,
                    );
                  },
                  text: "Instagram",
                ),
                const SizedBox(height: 20),

                // Tombol WhatsApp
                _buildIconButton(
                  icon: Icons.call,
                  color: Colors.green,
                  onTap: () {
                    Contact.show(
                      context,
                      title: "Hubungi via WhatsApp",
                      label: "Nomor WhatsApp Toko:",
                      value: "628143653225",
                      accentColor: Colors.green,
                    );
                  },
                  text: "Whatsapp",
                ),
                const SizedBox(height: 20),

                // Tombol TikTok
                _buildIconButton(
                  icon: Icons.tiktok,
                  color: Colors.black,
                  onTap: () {
                    Contact.show(
                      context,
                      title: "lihat konten Tiktok Kami",
                      label: "Akun tiktok kami",
                      value: "kiwariBakery25",
                      accentColor: Colors.green,
                    );
                  },
                  text: "Tiktok",
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildIconButton({
  required IconData icon,
  required Color color,
  required VoidCallback onTap,
  required String text,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(50),
    child: Container(
      width: 500,
      height: 60,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1), // background lembut
        borderRadius: BorderRadius.all(Radius.circular(20)),
        border: Border.all(color: color, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // horizontal center
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 30),
          Text(text),
        ],
      ),
    ),
  );
}
