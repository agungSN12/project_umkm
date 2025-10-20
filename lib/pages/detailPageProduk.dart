import 'package:flutter/material.dart';
import 'package:project_umkm/controller/cart.controller.dart';
import 'package:project_umkm/controller/form.controller.dart';
import 'package:provider/provider.dart';
import 'package:project_umkm/component/contact.component.dart';
import 'package:project_umkm/component/cart.component.dart';
import 'package:project_umkm/model/chart.model.dart';
import 'package:project_umkm/services/auth.service.dart';
import 'package:project_umkm/services/firestore.service.dart';

class DetailPageProduk extends StatefulWidget {
  final dynamic product;

  const DetailPageProduk({super.key, required this.product});

  @override
  State<DetailPageProduk> createState() => _DetailPageProdukState();
}

class _DetailPageProdukState extends State<DetailPageProduk> {
  int quantity = 1;
  final FirestoreService firebaseService = FirestoreService();

  void _increment() => setState(() => quantity++);
  void _decrement() => setState(() {
    if (quantity > 1) quantity--;
  });

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final authService = Provider.of<AuthService>(context, listen: false);
    final currentUser = authService.currentUser;
    final cartController = CartController();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                product.image.toString().startsWith('http')
                    ? Image.network(
                        product.image,
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                      )
                    : Image.asset(
                        product.image,
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                Positioned(
                  top: 40,
                  left: 16,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
                Positioned(
                  top: 40,
                  right: 16,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: IconButton(
                      icon: const Icon(Icons.share),
                      onPressed: () {},
                    ),
                  ),
                ),
                if (currentUser?.role != 'admin')
                  Positioned(top: 40, right: 80, child: CartButton()),
              ],
            ),

            // --- Detail Produk ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (product.category != null)
                    Text(
                      product.category,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  const SizedBox(height: 4),
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Info Toko / Penjual
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage("asset/images/abidin.png"),
                      ),
                      const SizedBox(width: 10),
                      const Text("Muhammad Zaenal Abidin - Cook"),
                      const Spacer(),
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
                        icon: const Icon(
                          Icons.phone,
                          color: Color.fromARGB(255, 182, 108, 11),
                          size: 30,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  const Text(
                    "Description",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(product.description ?? "-"),
                  const SizedBox(height: 20),

                  // Harga &
                  if (currentUser?.role != 'admin')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Rp. ${product.price}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: _decrement,
                            ),
                            Text(quantity.toString()),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: _increment,
                            ),
                          ],
                        ),
                      ],
                    ),

                  const SizedBox(height: 20),
                  if (currentUser?.role != 'admin')
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.brown,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: () async {
                        final authService = Provider.of<AuthService>(
                          context,
                          listen: false,
                        );
                        final currentUser = authService.currentUser;

                        if (currentUser == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Kamu harus login terlebih dahulu"),
                            ),
                          );
                          return;
                        }

                        try {
                          Cart cart = Cart(
                            id: 0,
                            uid: currentUser.uid,
                            productId: product.productId,
                            name: product.name,
                            image: product.image,
                            price: product.price,
                            quantity: quantity,
                          );

                          await cartController.addCart(
                            context: context,
                            collectionName: "cart",
                            data: cart.toMap(),
                            docId: cart.productId,
                          );

                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Produk berhasil ditambahkan ke keranjang",
                                ),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        } catch (error) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "Gagal menambahkan produk: $error",
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      child: const Text("Add to Cart"),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
