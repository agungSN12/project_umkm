import 'package:flutter/material.dart';
import 'package:popover/popover.dart';

class NotificationPopup extends StatelessWidget {
  const NotificationPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (buttonContext) {
        return IconButton(
          icon: const Icon(Icons.notifications, color: Colors.white),
          onPressed: () {
            showPopover(
              context: buttonContext,
              direction: PopoverDirection.bottom,
              backgroundColor: Colors.white,
              width: 250,
              height: 300,
              arrowHeight: 12,
              arrowWidth: 24,
              transitionDuration: const Duration(milliseconds: 180),
              bodyBuilder: (context) => Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Notification"),

                    Column(
                      children: [
                        Container(
                          constraints: const BoxConstraints(
                            minWidth: double.infinity, // lebar penuh
                            minHeight: 10, // tinggi minimal 120
                          ),
                          margin: const EdgeInsets.all(12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.info, color: Colors.amber),
                                  SizedBox(width: 10),
                                  Text(
                                    "pengingat Pesanan",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              const Text(
                                "Pesanan kamu sedang diproses!",
                                style: TextStyle(fontSize: 10),
                              ),
                              SizedBox(height: 2), // jarak antar teks
                              Text(
                                "06 Oktober 2025 • 13:45",
                                style: TextStyle(
                                  fontSize: 8,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
