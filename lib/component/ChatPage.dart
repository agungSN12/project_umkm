import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String initialMessage;
  const ChatPage({super.key, required this.initialMessage});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<Map<String, String>> messages =
      []; // {role: "user"/"bot", text: ""}
  final TextEditingController _controller = TextEditingController();

  final List<String> suggestedQuestions = [
    "Apa saja jenis kue basah yang dijual?",
    "Apakah menerima pesanan dalam jumlah besar?",
    "Di mana lokasi UMKM Kiwari?",
    "Apakah bisa pesan lewat WhatsApp?",
    "Apakah ada kue tradisional khas daerah?",
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialMessage.isNotEmpty) {
      messages.add({"role": "user", "text": widget.initialMessage});
      _botReply(widget.initialMessage);
    }
  }

  void _sendMessage([String? text]) {
    final message = text ?? _controller.text.trim();
    if (message.isEmpty) return;

    setState(() {
      messages.add({"role": "user", "text": message});
    });

    _controller.clear();
    _botReply(message);
  }

  void _botReply(String message) {
    String reply;

    if (message.toLowerCase().contains("jenis") ||
        message.toLowerCase().contains("kue")) {
      reply =
          "Kami menjual berbagai kue basah tradisional seperti klepon, putu ayu, kue lapis, lemper, dan nagasari.";
    } else if (message.toLowerCase().contains("pesan") ||
        message.toLowerCase().contains("jumlah besar")) {
      reply =
          "Tentu! Kami menerima pesanan dalam jumlah besar untuk acara seperti arisan, hajatan, dan rapat. Sebaiknya pesan 2–3 hari sebelumnya ya.";
    } else if (message.toLowerCase().contains("lokasi")) {
      reply =
          "UMKM Kiwari berlokasi di Jl. Melati No. 23, Bandung. Kami juga melayani pemesanan online.";
    } else if (message.toLowerCase().contains("whatsapp")) {
      reply = "Bisa! Silakan hubungi kami di WhatsApp 0812-3456-7890 📱";
    } else if (message.toLowerCase().contains("tradisional")) {
      reply =
          "Ya, kami fokus pada kue tradisional khas Nusantara yang dibuat dengan bahan alami tanpa pengawet.";
    } else {
      reply =
          "Terima kasih atas pertanyaannya! Untuk info lebih lanjut, silakan hubungi kami via WhatsApp 😊";
    }

    setState(() {
      messages.add({"role": "bot", "text": reply});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat dengan Bot"),
        foregroundColor: Colors.white,
        backgroundColor: const Color(0xFF6D4C41),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isUser = msg["role"] == "user";
                return Align(
                  alignment: isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: isUser
                          ? const Color.fromARGB(255, 216, 153, 81)
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      msg["text"]!,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // 🔹 Daftar pertanyaan cepat
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: suggestedQuestions.map((q) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6D4C41),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () => _sendMessage(q),
                    child: Text(q, textAlign: TextAlign.center),
                  ),
                );
              }).toList(),
            ),
          ),

          // 🔹 Input field
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.only(bottom: 80, right: 20, left: 20),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Tulis pesan...",
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFF6D4C41)),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
