import 'package:flutter/material.dart';
import 'package:project_umkm/pages/ListProductPage.dart';
import 'package:project_umkm/pages/chatPage.dart';
import 'package:project_umkm/pages/homePage.dart';
import 'dart:ui';

import 'package:project_umkm/pages/profilePage.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<Navigation> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Halaman
          IndexedStack(
            index: currentPageIndex,
            children: [
              HomePage(),
              ListMenuPage(),
              AssistantPage(),
              ProfilePage(),
            ],
          ),

          // Floating Navbar
          Positioned(
            left: 60,
            right: 60,
            bottom: 60, // jarak dari bawah
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.brown.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavItem(
                        icon: Icons.home_outlined,
                        selectedIcon: Icons.home,
                        label: "Home",
                        index: 0,
                      ),
                      _buildNavItem(
                        icon: Icons.shopping_basket_outlined,
                        selectedIcon: Icons.shopping_basket,
                        label: "List Product",
                        index: 1,
                      ),
                      _buildNavItem(
                        icon: Icons.chat_bubble,
                        selectedIcon: Icons.chat_bubble,
                        label: "Chat",
                        index: 2,
                      ),
                      _buildNavItem(
                        icon: Icons.person,
                        selectedIcon: Icons.person,
                        label: "profile",
                        index: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required int index,
  }) {
    bool isSelected = currentPageIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          currentPageIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? selectedIcon : icon,
            color: isSelected ? Colors.amber : Colors.white,
            size: 22,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.amber : Colors.white70,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
