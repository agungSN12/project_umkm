import 'package:flutter/material.dart';
import 'package:project_umkm/component/Contact.dart';

import 'package:project_umkm/component/cart.dart';
import 'package:project_umkm/model/paket.dart';
import 'package:project_umkm/pages/detailPage.dart';
import 'package:project_umkm/component/notification.dart';
import 'package:project_umkm/pages/detailpagePaket.dart';
import '../model/product.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // controller untuk search field
  final TextEditingController _searchController = TextEditingController();

  // data awal
  List<Product> _filteredProducts = products;

  @override
  void initState() {
    super.initState();
    // ketika user mengetik sesuatu, otomatis panggil fungsi filter
    _searchController.addListener(_filterProducts);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterProducts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredProducts = products;
      } else {
        _filteredProducts = products.where((product) {
          return product.name.toLowerCase().contains(query) ||
              product.category.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> banners = [
      {
        'image': 'assets/banner1.jpg',
        'text': 'Promo Kue Klepon, beli 2 gratis 1 🎉',
      },
      {
        'image': 'assets/banner2.jpg',
        'text': 'Pesanan kamu sedang diproses 🍰',
      },
      {
        'image': 'assets/banner3.jpg',
        'text': 'Dapatkan diskon 10% untuk pembelian pertama 💸',
      },
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Header
              Container(
                padding: const EdgeInsets.all(23),
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
                        const SizedBox(width: 10),
                        const NotificationPopup(),
                        const Expanded(
                          child: Text(
                            "Kiwari Baker",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            const SizedBox(width: 10),
                            IconButton(
                              onPressed: () {
                                Contact.show(
                                  context,
                                  title: "Hubungi via WhatsApp",
                                  label: "Nomor WhatsApp Toko:",
                                  value: "628143653225",
                                  accentColor: Colors.green,
                                );
                              },
                              icon: const Icon(Icons.call, color: Colors.white),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 15),
                        const CartButton(),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Search bar aktif
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          icon: Icon(Icons.search, color: Colors.grey),
                          hintText: "Cari produk...",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 180, // atur tinggi banner sesuai kebutuhan
                child: CarouselView(
                  itemExtent: MediaQuery.of(context).size.width,
                  // biar full ke kiri-kanan
                  children: const [
                    Image(
                      image: AssetImage("asset/images/apem.png"),
                      fit: BoxFit.cover,
                    ),
                    Image(
                      image: AssetImage("asset/images/lupis.png"),
                      fit: BoxFit.cover,
                    ),
                    Image(
                      image: AssetImage("asset/images/onde-onde.png"),
                      fit: BoxFit.cover,
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

              // 🔹 List produk hasil filter
              SizedBox(
                height: 180,
                child: _filteredProducts.isEmpty
                    ? const Center(child: Text("Produk tidak ditemukan 😢"))
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = _filteredProducts[index];
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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

              SizedBox(height: 5),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Text(
                  "Paket Produk",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: PaketProduct.length,
                  itemBuilder: (context, index) {
                    final paket = PaketProduct[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                DetailPagePaket(PaketProduct: paket),
                          ),
                        );
                      },

                      child: (Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        width: 170,
                        child: Stack(
                          children: [
                            Image.asset(paket.image, fit: BoxFit.cover),
                            Container(color: Colors.black.withOpacity(0.3)),
                            Center(
                              child: Text(
                                paket.name, // langsung pakai variabel
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
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
