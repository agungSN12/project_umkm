import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'package:project_umkm/controller/cart.controller.dart';
import 'package:project_umkm/controller/form.controller.dart';
import 'package:project_umkm/pages/checkOutPage.dart';
import 'package:project_umkm/services/auth.service.dart';

import 'package:provider/provider.dart';

class CartButton extends StatefulWidget {
  const CartButton({super.key});

  @override
  State<CartButton> createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton> {
  final CartController cartController = CartController();
  @override
  Widget build(BuildContext context) {
    final uid = Provider.of<AuthService>(context).currentUser?.uid ?? "";
    return StreamBuilder<QuerySnapshot>(
      stream: FirestoreHelper().streamDocumentsByUser(
        collectionName: "cart",
        uid: uid,
      ),
      builder: (context, snapshot) {
        int totalDocs = snapshot.hasData ? snapshot.data!.docs.length : 0;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
              onPressed: () {
                showPopover(
                  context: context,
                  direction: PopoverDirection.bottom,
                  backgroundColor: Colors.white,
                  width: 250,
                  height: 500,
                  arrowHeight: 12,
                  arrowWidth: 24,
                  transitionDuration: const Duration(milliseconds: 180),
                  bodyBuilder: (context) => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Keranjang Anda",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Divider(),
                        Expanded(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: cartController.streamCartByUser(uid),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              if (!snapshot.hasData ||
                                  snapshot.data!.docs.isEmpty) {
                                return const Center(
                                  child: Text("Keranjang kosong"),
                                );
                              }

                              final carts = snapshot.data!.docs;

                              // 🔹 Hitung total harga semua item
                              num totalHarga = 0;
                              for (var doc in carts) {
                                final data = doc.data() as Map<String, dynamic>;
                                final harga = (data['price'] ?? 0) as num;
                                final jumlah = (data['quantity'] ?? 1) as num;
                                totalHarga += harga * jumlah;
                              }

                              return Column(
                                children: [
                                  Flexible(
                                    child: ListView.builder(
                                      itemCount: carts.length,
                                      itemBuilder: (context, index) {
                                        final data =
                                            carts[index].data()
                                                as Map<String, dynamic>;

                                        return ListTile(
                                          dense: true,
                                          leading: data['image'] != null
                                              ? Image.asset(
                                                  data['image'],
                                                  width: 40,
                                                  height: 40,
                                                  fit: BoxFit.cover,
                                                )
                                              : const Icon(Icons.fastfood),
                                          title: Text(data['name'] ?? 'Produk'),
                                          subtitle: Text(
                                            "Rp ${data['price']}  x${data['quantity']}",
                                          ),
                                          trailing: IconButton(
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            onPressed: () async {
                                              final confirm = await showDialog<bool>(
                                                context: context,
                                                builder: (ctx) => AlertDialog(
                                                  title: const Text(
                                                    "Hapus item",
                                                  ),
                                                  content: const Text(
                                                    "Yakin ingin menghapus produk ini dari keranjang?",
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                            ctx,
                                                            false,
                                                          ),
                                                      child: const Text(
                                                        "Batal",
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                            ctx,
                                                            true,
                                                          ),
                                                      child: const Text(
                                                        "Hapus",
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );

                                              if (confirm == true) {
                                                showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (_) => const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  ),
                                                );

                                                try {
                                                  cartController.deleteCart(
                                                    data["productId"],
                                                  );
                                                } catch (e) {
                                                  print('Gagal hapus: $e');
                                                } finally {
                                                  if (Navigator.of(
                                                    context,
                                                  ).canPop()) {
                                                    Navigator.of(context).pop();
                                                  }
                                                }

                                                if (context.mounted) {
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                        'Item berhasil dihapus ',
                                                      ),
                                                    ),
                                                  );
                                                }
                                              }
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),

                                  const Divider(),

                                  // 🔹 Tampilkan total harga di bawah
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "Total: Rp ${totalHarga.toStringAsFixed(0)}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  Center(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFF6D4C41,
                                        ),
                                      ),
                                      onPressed: () {
                                        if (!snapshot.hasData) return;

                                        // Konversi snapshot ke List<Map<String, dynamic>>
                                        List<Map<String, dynamic>>
                                        carts = snapshot.data!.docs
                                            .map(
                                              (doc) =>
                                                  doc.data()
                                                      as Map<String, dynamic>,
                                            )
                                            .toList();

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => CheckoutPage(
                                              data: carts,
                                              totalPrice: totalHarga,
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "Checkout",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // 🔴 Badge jumlah item
            if (totalDocs > 0)
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Text(
                    '$totalDocs',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
