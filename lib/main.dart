import 'package:flutter/material.dart';
import 'package:project_umkm/component/navbar.component.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project_umkm/controller/orders.controller.dart';
import 'package:project_umkm/services/auth.service.dart';

import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final authService = AuthService();
  await authService.trySilentGoogleLogin();
  await authService.loadUserFromLocal();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => authService),
        ChangeNotifierProvider(create: (_) => OrdersController()),
      ],

      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.brown, fontFamily: 'Sora'),
      home: Navigation(),
    );
  }
}
