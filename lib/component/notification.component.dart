import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'package:project_umkm/services/auth.service.dart';
import 'package:provider/provider.dart';

class NotificationPopup extends StatefulWidget {
  const NotificationPopup({super.key});

  @override
  State<NotificationPopup> createState() => _NotificationPopupState();
}

class _NotificationPopupState extends State<NotificationPopup> {
  @override
  void initState() {
    super.initState();
  }

  void _showNotification({required String title, required String message}) {
    showPopover(
      context: context,
      direction: PopoverDirection.bottom,
      backgroundColor: Colors.white,
      width: 250,
      height: 120,
      arrowHeight: 12,
      arrowWidth: 24,
      transitionDuration: const Duration(milliseconds: 180),
      bodyBuilder: (context) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.info, color: Colors.amber),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(message, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  void _onIconPressed() {
    final auth = Provider.of<AuthService>(context, listen: false);
    final user = auth.currentUser;
    if (user != null) {
      _showNotification(
        title: "Selamat datang, ${user.name}!",
        message: "Semoga harimu menyenangkan 🎉",
      );
    }
  }

  void showCheckoutNotification() {
    _showNotification(
      title: "Pesanan berhasil!",
      message: "Terima kasih, pesananmu sedang diproses.",
    );
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.notifications, color: Colors.white),
      onPressed: _onIconPressed,
    );
  }
}
