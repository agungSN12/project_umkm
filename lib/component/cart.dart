import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'package:project_umkm/services/firebase_service.dart';

class CartButton extends StatefulWidget {
  const CartButton({super.key});

  @override
  State<CartButton> createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseService().getCart(),
      builder: (context, snapshot) {
        // Hitung total dokumen
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
                  height: 400,
                  arrowHeight: 12,
                  arrowWidth: 24,
                  transitionDuration: const Duration(milliseconds: 180),
                  bodyBuilder: (context) => Padding(
                    padding: const EdgeInsets.all(10.0),
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
                            stream: FirebaseService().getCart(),
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

                              // Ambil data dari Firestore

                              final carts = snapshot.data!.docs;

                              return ListView.builder(
                                itemCount: carts.length,
                                itemBuilder: (context, index) {
                                  final data =
                                      carts[index].data()
                                          as Map<String, dynamic>;

                                  return ListTile(
                                    dense: true,
                                    leading: const Icon(Icons.fastfood),
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
                                        // Tampilkan dialog konfirmasi
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: const Text("Hapus item"),
                                            content: const Text(
                                              "Yakin ingin menghapus produk ini dari keranjang?",
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(ctx, false),
                                                child: const Text("Batal"),
                                              ),
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(ctx, true),
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
                                          // Tampilkan loading
                                          showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (_) => const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          );

                                          try {
                                            // Jalankan delete
                                            FirebaseService().deleteCart(
                                              data["productId"],
                                            );
                                          } catch (e) {
                                            print('Gagal hapus: $e');
                                          } finally {
                                            // Tutup loading dialog
                                            if (Navigator.of(context).canPop())
                                              Navigator.of(context).pop();
                                          }

                                          // Snackbar notifikasi
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Item berhasil dihapus 🗑️',
                                                ),
                                              ),
                                            );
                                          }
                                        }
                                      },
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),

                        const Divider(),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6D4C41),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Checkout",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // 🔴 Badge jumlah item troli
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
