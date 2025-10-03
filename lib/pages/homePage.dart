import 'package:flutter/material.dart';
import '../model/product.dart';
import 'detailPage.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final List<Product> products = [
    Product(
      name: "Kue Lapis",
      category: "Kue Basah",
      image: "asset/images/kue mamay.png",
      description:
          "Lapis Legit Aduhay\n"
          "Kategori: Kue Basah Tradisional\n"
          "Berat/Isi: 250 gr (±12 pcs)\n\n"
          "Komposisi: Tepung ketan, gula merah, kelapa parut, garam\n"
          "Rasa & Tekstur: Lembut, kenyal, manis meleleh saat digigit\n\n"
          "Tanggal Produksi: Hari pengiriman\n"
          "Expired / Ketahanan: 1 hari suhu ruang, 2 hari di kulkas",
      price: 6000,
    ),
    Product(
      name: "Kelepon",
      category: "Kue Tradisional",
      image: "asset/images/klepon.png",
      description:
          "Klepon Ketan Isi Gula Merah\n"
          "Kategori: Kue Basah Tradisional\n"
          "Berat/Isi: 250 gr (±12 pcs)\n\n"
          "Komposisi: Tepung ketan, gula merah, kelapa parut, garam\n"
          "Rasa & Tekstur: Lembut, kenyal, manis meleleh saat digigit\n\n"
          "Tanggal Produksi: Hari pengiriman\n"
          "Expired / Ketahanan: 1 hari suhu ruang, 2 hari di kulkas",
      price: 15000,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Color(0xFF6D4C41), // warna coklat
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                child: Column(
                  children: [
                    // Baris profil + tombol visit me + call me
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person, color: Colors.brown),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            "Hai Agung !",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          children: const [
                            Icon(Icons.photo_camera, color: Colors.white),
                            SizedBox(width: 5),
                            Text(
                              "visit me",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(width: 15),
                        Row(
                          children: const [
                            Icon(Icons.phone, color: Colors.white),
                            SizedBox(width: 5),
                            Text(
                              "call me",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Search bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          icon: Icon(Icons.search, color: Colors.grey),
                          hintText: "Search",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 🔹 Best Seller Produk
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Best Seller Produk",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),

              SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailPage(product: product),
                          ),
                        );
                      },
                      child: Container(
                        width: 150,
                        margin: const EdgeInsets.only(left: 16, right: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                              child: Image.asset(
                                product.image,
                                height: 120,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text("Rp ${product.price}"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
