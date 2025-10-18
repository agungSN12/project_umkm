import 'package:flutter/material.dart';
import 'package:project_umkm/component/navbar.component.dart';
import 'package:project_umkm/model/users.model.dart';
import 'package:project_umkm/services/auth.service.dart';
import 'package:provider/provider.dart';

class AuthController {
  final authService = AuthService();
  Future<void> handleLogin({
    required BuildContext context,
    required String username,
    required String password,
  }) async {
    final authServiceProvider = Provider.of<AuthService>(
      context,
      listen: false,
    );
    bool success = await authServiceProvider.signInWithUsernameAndPassword(
      username,
      password,
    );

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Login berhasil")));
      debugPrint("User setelah login: ${authService.currentUser?.name}");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Navigation()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username atau password salah")),
      );
    }
  }

  Future<void> handleRegister({
    required BuildContext context,
    required Users user,
  }) async {
    bool success = await authService.registerUser(user);

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Registrasi berhasil!")));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Navigation()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registrasi gagal, coba lagi.")),
      );
    }
  }
}
