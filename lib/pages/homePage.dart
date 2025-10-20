import 'package:flutter/material.dart';
import 'package:project_umkm/component/cart.component.dart';
import 'package:project_umkm/component/notification.component.dart';
import 'package:project_umkm/model/paket.model.dart';
import 'package:project_umkm/model/product.model.dart';
import 'package:project_umkm/pages/detailPageProduk.dart';
import 'package:project_umkm/pages/loginPage.dart';
import 'package:project_umkm/pages/userPage.dart';
import 'package:project_umkm/services/auth.service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _filteredProducts = products;

  @override
  void initState() {
    super.initState();
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(23),
                decoration: const BoxDecoration(
                  color: Color(0xFF6D4C41),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                child: Consumer<AuthService>(
                  builder: (context, auth, _) {
                    final user = auth.currentUser;

                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                child: user != null
                                    ? Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      UserPage(),
                                                ),
                                              );
                                            },
                                            child: CircleAvatar(
                                              radius: 15,
                                              backgroundImage:
                                                  user.photoURL != null &&
                                                      user.photoURL.isNotEmpty
                                                  ? NetworkImage(user.photoURL)
                                                  : const AssetImage(
                                                          "asset/images/default_profile.png",
                                                        )
                                                        as ImageProvider,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            "Hi ${user.name}",
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Align(
                                        alignment: Alignment.centerLeft,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    loginPage(),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            foregroundColor: Color(0xFF6D4C41),
                                          ),
                                          child: const Text("Login"),
                                        ),
                                      ),
                              ),
                            ),
                            Row(
                              children: [
                                const SizedBox(width: 10),
                                if (user?.role != 'admin') CartButton(),
                                const SizedBox(width: 15),
                                NotificationPopup(),
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
                    );
                  },
                ),
              ),

              SizedBox(
                height: 180,
                child: CarouselView(
                  itemExtent: MediaQuery.of(context).size.width,
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
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Best Seller Produk",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),

              // Produk hasil filter
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
                                  builder: (_) =>
                                      DetailPageProduk(product: product),
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

              const SizedBox(height: 5),
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
                            builder: (_) => DetailPageProduk(product: paket),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        width: 170,
                        child: Stack(
                          children: [
                            Image.asset(paket.image, fit: BoxFit.cover),
                            Container(color: Colors.black.withOpacity(0.3)),
                            Center(
                              child: Text(
                                paket.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                ),
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
