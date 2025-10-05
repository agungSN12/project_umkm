import 'package:flutter/material.dart';
import 'package:project_umkm/pages/ListProduct.dart';
import 'package:project_umkm/pages/homePage.dart';
import 'dart:ui';

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      body: Stack(
        children: [
          // Halaman
          IndexedStack(
            index: currentPageIndex,
            children: [HomePage(), Listproduct(), HomePage()],
          ),
          // NavigationBar blur
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Colors.brown.withAlpha((0.4 * 255).toInt()),
                  child: NavigationBar(
                    selectedIndex: currentPageIndex,
                    onDestinationSelected: (index) {
                      setState(() {
                        currentPageIndex = index;
                      });
                    },
                    indicatorColor: Colors.amber,
                    destinations: const [
                      NavigationDestination(
                        icon: Icon(Icons.home_outlined),
                        selectedIcon: Icon(Icons.home),
                        label: 'Home',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.notifications_sharp),
                        label: 'Notifications',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.messenger_sharp),
                        label: 'Messages',
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
}
