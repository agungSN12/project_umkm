import 'package:flutter/material.dart';
import 'package:project_umkm/component/FireStoreHelper.component.dart';
import 'package:project_umkm/component/navbar.component.dart';
import 'package:project_umkm/pages/registerPage.dart';
import 'package:project_umkm/services/auth.service.dart';
import 'package:provider/provider.dart';

class loginPage extends StatelessWidget {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final helper = FirestoreHelper();

  @override
  Widget build(BuildContext context) {
    Future<void> _onLogin() async {
      final username = usernameController.text.trim();
      final password = passwordController.text.trim();

      await helper.submitToFirestore(
        context: context,
        collectionName: "users",
        data: {
          "username": username,
          "password": password,
          "createdAt": DateTime.now(),
        },
      );
    }

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
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Navigation(),
                                ),
                              );
                            },
                            icon: Icon(Icons.arrow_back),
                          ),
                        ),
                        const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontFamily: 'Sora',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // Username
                    _buildTextField(
                      controller: usernameController,
                      icon: Icons.person,
                      hint: "Masukan Username",
                    ),
                    const SizedBox(height: 16),

                    // Password
                    _buildTextField(
                      controller: passwordController,
                      icon: Icons.lock,
                      hint: "Masukan Password",
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),

                    const SizedBox(height: 20),

                    // Tombol Submit
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
                        onPressed: () {
                          _onLogin();
                        },
                        child: const Text(
                          "LOGIN",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: const Text(
                            "Atau Login Dengan",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),

                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterPage(),
                              ),
                            );
                          },
                          child: const Text(
                            "Sign In",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Tombol Google
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
                                          Navigator.pop(
                                            context,
                                          ); // tutup dialog
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
                                // jika login gagal
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
