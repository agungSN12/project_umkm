import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: UserPage()));
}

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 234, 234),
      // appBar: AppBar(title: const Text('User Page')),
      body: SingleChildScrollView(
        // child: Padding(
        //   padding: const EdgeInsets.only(top: 40),
        child: Column(
          children: [
            Container(
              color: Color(0xFF6D4C41),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 40,
                  left: 16,
                  right: 16,
                  bottom: 40,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ClipOval(
                          child: Image.asset(
                            'asset/images/abidin.png',
                            width: 70,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Nama User",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            fontFamily: 'Poppins',
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(width: 10),
                    IconButton(
                      icon: const Icon(
                        Icons.logout,
                        color: Color.fromARGB(255, 247, 247, 247),
                      ),
                      onPressed: () {
                        // Belum ada aksinya
                      },
                    ),
                  ],
                ),
              ),
            ),
            // Pesan
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                // border: Border.all(width: 10),
                borderRadius: BorderRadius.circular(0),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.mail, color: Color(0xFF6D4C41)),
                        onPressed: () {
                          // Belum ada aksinya
                        },
                      ),
                      Expanded(
                        child: Text(
                          'Verifikasi Emailmu Agar kami dapat memastikan identiasmu, melindungi akunmu, dan menerima update pesananmu.',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            //Transaksi
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                // border: Border.all(width: 10),
                borderRadius: BorderRadius.circular(0),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Transaksi",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 2),
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.attach_money,
                              color: Color(0xFF6D4C41),
                            ),
                            onPressed: () {
                              // Belum ada aksinya
                            },
                          ),
                          Text('Bayar'),
                        ],
                      ),
                      const SizedBox(width: 5),
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.hourglass_bottom,
                              color: Color(0xFF6D4C41),
                            ),
                            onPressed: () {
                              // Belum ada aksinya
                            },
                          ),
                          Text('Diproses'),
                        ],
                      ),
                      const SizedBox(width: 5),
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.delivery_dining,
                              color: Color(0xFF6D4C41),
                            ),
                            onPressed: () {
                              // Belum ada aksinya
                            },
                          ),
                          Text('Dikirim'),
                        ],
                      ),
                      const SizedBox(width: 5),
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.check_circle,
                              color: Color(0xFF6D4C41),
                            ),
                            onPressed: () {
                              // Belum ada aksinya
                            },
                          ),
                          Text('Sudah Tiba'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Saldo Dan Point
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                // border: Border.all(width: 10),
                borderRadius: BorderRadius.circular(0),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "Saldo & Point",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.account_balance_wallet,
                              color: Color(0xFF6D4C41),
                            ),
                            onPressed: () {
                              // Belum ada aksinya
                            },
                          ),
                          Text(
                            'Rp 100.000',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text('Saldo'),
                        ],
                      ),
                      Container(width: 1, height: 70, color: Colors.grey),
                      Column(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.circle, color: Colors.amber),
                            onPressed: () {
                              // Belum ada aksinya
                            },
                          ),
                          Text(
                            'Rp0',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          Text('Bonus'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Bantuan
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: const [
                  Row(
                    children: [
                      Text(
                        'Bantuan',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  ListTile(
                    leading: Icon(Icons.help_outline),
                    title: Text("Pusat Bantuan"),
                    trailing: Icon(Icons.chevron_right),
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.support_agent),
                    title: Text("Chat Dengan Kiwari"),
                    trailing: Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // ),
    );
  }
}
