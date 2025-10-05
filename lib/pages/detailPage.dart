import 'package:flutter/material.dart';
import 'package:project_umkm/component/cart.dart';
import 'package:project_umkm/model/chartModel.dart';
import 'package:project_umkm/services/firebase_service.dart';
import '../model/product.dart';

class DetailPage extends StatefulWidget {
  final Product product;

  const DetailPage({super.key, required this.product});
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int quantity = 1;

  FirebaseService firebaseService = new FirebaseService();

  void _increment() {
    setState(() => quantity++);
  }

  void _decrement() {
    if (quantity > 1) {
      setState(() => quantity--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.asset(
                  widget.product.image,
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
                Positioned(top: 40, right: 80, child: CartButton()),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.category,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.product.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: const [
                      CircleAvatar(
                        backgroundImage: AssetImage("asset/images/abidin.png"),
                      ),
                      SizedBox(width: 10),
                      Text("Muhammad Zaenal Abidin - Cook"),
                      SizedBox(width: 70),
                      Icon(
                        Icons.phone,
                        color: Color.fromARGB(255, 182, 108, 11),
                        size: 30,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Description",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(widget.product.description),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Harga di kiri
                      Text(
                        "Rp. ${widget.product.price}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown,
                        ),
                      ),

                      // Quantity di kanan
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: _decrement,
                                ),
                                Text(
                                  quantity.toString(),
                                  style: const TextStyle(fontSize: 16),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: _increment,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.brown,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () {
                      try {
                        Cart cart = new Cart(
                          id: widget.product.Id,
                          productId: widget.product.productId,
                          name: widget.product.name,
                          image: widget.product.image,
                          price: widget.product.price,
                          quantity: quantity,
                        );
                        firebaseService.addCart(cart);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Produk berhasil ditambahkan ke keranjang 🛒",
                              ),
                              duration: Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      } catch (error) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Gagal menambahkan produk: $error"),
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
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
