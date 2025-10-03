import 'package:flutter/material.dart';
import '../model/product.dart';
import 'homePage.dart';

class DetailPage extends StatelessWidget {
  final Product product;

  const DetailPage({super.key, required this.product});

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
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  Text(product.description),
                  const SizedBox(height: 20),
                  Text(
                    "Rp. ${product.price}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.brown,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () {},
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
