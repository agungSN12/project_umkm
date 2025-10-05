import 'package:flutter/material.dart';
import 'homePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'List Menu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Arial'),
      home: const ListMenuPage(),
    );
  }
}

class ListMenuPage extends StatelessWidget {
  const ListMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> products = [
      {
        "nama": "Kue Klepon",
        "kategori": "Kue Basah",
        "harga": 6000,
        "hargaAsli": 8000,
        "promo": true,
        "foto": "asset/images/klepon.png",
      },
      {
        "nama": "Kue Klepon (Jumbo)",
        "kategori": "Kue Basah",
        "harga": 10000,
        "hargaAsli": 13000,
        "promo": true,
        "foto": "asset/images/kue mamay.png",
      },
      {
        "nama": "Kue Santan Kelapa",
        "kategori": "Kue Basah",
        "harga": 10000,
        "hargaAsli": 13000,
        "promo": true,
        "foto": "asset/images/dadarG.png",
      },
      {
        "nama": "Pandan Leaves",
        "kategori": "Kue Basah",
        "harga": 10000,
        "hargaAsli": 13000,
        "promo": true,
        "foto": "asset/images/1.png",
      },
      {
        "nama": "Onde-Onde",
        "kategori": "Kue Basah",
        "harga": 10000,
        "hargaAsli": 13000,
        "promo": true,
        "foto": "asset/images/onde-onde.png",
      },
      {
        "nama": "Kue Talam Betawi",
        "kategori": "Kue Basah",
        "harga": 10000,
        "hargaAsli": 13000,
        "promo": true,
        "foto": "asset/images/talam.png",
      },
      {
        "nama": "Nagasari",
        "kategori": "Kue Basah",
        "harga": 10000,
        "hargaAsli": 13000,
        "promo": true,
        "foto": "asset/images/nagasari.png",
      },
      {
        "nama": "Kue Apem ",
        "kategori": "Kue Basah",
        "harga": 10000,
        "hargaAsli": 13000,
        "promo": true,
        "foto": "asset/images/apem.png",
      },
      {
        "nama": "Kue Lupis",
        "kategori": "Kue Basah",
        "harga": 10000,
        "hargaAsli": 13000,
        "promo": true,
        "foto": "asset/images/lupis.png",
      },
      {
        "nama": "Kue Lapis",
        "kategori": "Kue Basah",
        "harga": 10000,
        "hargaAsli": 13000,
        "promo": true,
        "foto": "asset/images/lapis.png",
      },
      {
        "nama": "Kue Putu",
        "kategori": "Kue Basah",
        "harga": 10000,
        "hargaAsli": 13000,
        "promo": true,
        "foto": "asset/images/putu.png",
      },
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
        ),
        title: const Text(
          "List Menu",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: ListView.separated(
        itemCount: products.length,
        separatorBuilder: (context, index) =>
            const Divider(thickness: 0.8, height: 20),
        itemBuilder: (context, index) {
          final item = products[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bagian kiri (teks + tombol hati)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item["nama"],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item["kategori"],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            "Rp ${item["harga"]}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Rp ${item["hargaAsli"]}",
                            style: const TextStyle(
                              fontSize: 12,
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 6),
                          if (item["promo"])
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                "Promo",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Icon(
                        Icons.favorite_border,
                        size: 20,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                ),

                // Bagian kanan (gambar + tombol)
                Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        item["foto"],
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text("Tambah"),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
