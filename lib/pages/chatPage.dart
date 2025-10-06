import 'package:flutter/material.dart';
import 'package:project_umkm/component/ChatComponent.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AssistantPage(),
    );
  }
}

class AssistantPage extends StatefulWidget {
  const AssistantPage({super.key});

  @override
  State<AssistantPage> createState() => _AssistantPageState();
}

class _AssistantPageState extends State<AssistantPage> {
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      final firstMessage = _controller.text;
      _controller.clear();

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatComponent(initialMessage: firstMessage),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🖼️ Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  "asset/images/bg.png",
                ), // ganti sesuai gambar kamu
                fit: BoxFit.cover,
              ),
            ),
          ),

          // ✨ Konten utama
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Greeting Section
                  const Text(
                    "Hi Customer 👋",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 8,
                          color: Colors.black87,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Ada yang bisa Rere bantu?",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                      shadows: [
                        Shadow(
                          blurRadius: 6,
                          color: Colors.black87,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // 💬 Input Box (Sekarang di atas)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            decoration: const InputDecoration(
                              hintText: "Tanya Rere di sini ya! 😘",
                              border: InputBorder.none,
                            ),
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.send,
                            color: Color(0xFF6D4C41),
                          ),
                          onPressed: _sendMessage,
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// 💭 Halaman Chat
