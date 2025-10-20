import 'package:flutter/material.dart';
import 'package:project_umkm/component/navbar.component.dart';
import 'package:project_umkm/controller/auth.controller.dart';
import 'package:project_umkm/model/users.model.dart';
import 'package:project_umkm/pages/loginPage.dart';
import 'package:project_umkm/services/auth.service.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final nohpController = TextEditingController();

  final AuthController authController = AuthController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("asset/images/bgReg.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.5)),

          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 40,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Sora',
                      ),
                    ),
                    const SizedBox(height: 40),

                    _buildTextField(
                      controller: usernameController,
                      icon: Icons.person,
                      hint: "Masukan Username",
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: nohpController,
                      icon: Icons.phone,
                      hint: "Masukan Nomor Telepon",
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: emailController,
                      icon: Icons.email,
                      hint: "Masukan Email",
                    ),
                    const SizedBox(height: 16),

                    _buildTextField(
                      controller: passwordController,
                      icon: Icons.lock,
                      hint: "Masukan Password",
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6D4C41),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 20),
                        ),
                        onPressed: () async {
                          final username = usernameController.text.trim();
                          final email = emailController.text.trim();
                          final nohp = nohpController.text.trim();
                          final password = passwordController.text.trim();

                          if (username.isEmpty ||
                              password.isEmpty ||
                              email.isEmpty ||
                              nohp.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Semua field harus diisi"),
                              ),
                            );
                            return;
                          }

                          final user = Users(
                            uid: '',
                            name: username,
                            email: email,
                            nohp: nohp,
                            password: password,
                            alamat: '',
                            photoURL: '',
                            role: 'user',
                          );

                          await authController.handleRegister(
                            context: context,
                            user: user,
                          );
                        },
                        child: const Text(
                          "SUBMIT",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => loginPage()),
                        );
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('asset/images/Google.png', height: 24),
                          const SizedBox(width: 20),
                          TextButton(
                            onPressed: () async {
                              await auth.signInWithGoogle();
                              if (auth.user != null) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text("Berhasil"),
                                    content: const Text("Login berhasil!"),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => Navigation(),
                                            ),
                                          );
                                        },
                                        child: const Text("OK"),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Login gagal, coba lagi"),
                                  ),
                                );
                              }
                            },
                            child: Text(
                              "Masuk dengan Google",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.black),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
