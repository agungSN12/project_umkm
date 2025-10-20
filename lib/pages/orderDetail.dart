import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_umkm/controller/orders.controller.dart';

class OrderDetailPage extends StatelessWidget {
  final String status;
  final String? userRole; // 'admin' atau 'user'
  final String? uid; // 'admin' atau 'user'

  final OrdersController ordersController = OrdersController();

  OrderDetailPage({Key? key, required this.status, this.userRole, this.uid})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Pesanan"), centerTitle: true),
      body: StreamBuilder<QuerySnapshot>(
        stream: ordersController.getOrdersByStatus(
          uid: uid ?? "",
          status: status,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return const Center(child: Text("Pesanan tidak ditemukan"));
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text("Tidak ada pesanan"));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final data = docs[index].data() as Map<String, dynamic>;
                final produk = data['produk'] ?? [];
                final status = data['status'] ?? 'unknown';
                final alamat = data['alamat'] ?? '-';
                final catatan = data['catatan'] ?? '-';
                final grandTotal = data['grandTotal'] ?? 0;
                final biayaPengiriman = data['biayaPengiriman'] ?? 0;
                final opsiPengiriman = data['opsiPengiriman'] ?? '-';
                return Row(
                  children: [
                    Card(
                      child: ListTile(
                        title: Text("Status: $status"),
                        subtitle: Text("Pengiriman: $opsiPengiriman"),
                      ),
                    ),

                    const SizedBox(height: 16),
                    const Text(
                      "Alamat Pengiriman",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(alamat),
                    const SizedBox(height: 8),
                    Text("Catatan: $catatan"),

                    const SizedBox(height: 16),
                    const Divider(),
                    const Text(
                      "Daftar Produk",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),

                    // 🛍️ Daftar produk
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: produk.length,
                      itemBuilder: (context, index) {
                        final item = produk[index];
                        return Card(
                          child: ListTile(
                            leading: Image.asset(
                              item['image'] ?? '',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            title: Text(item['name'] ?? 'Produk'),
                            subtitle: Text("Rp ${item['price']}"),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 16),
                    const Divider(),

                    // 💰 Ringkasan pembayaran
                    ListTile(
                      title: const Text("Biaya Pengiriman"),
                      trailing: Text("Rp $biayaPengiriman"),
                    ),
                    ListTile(
                      title: const Text("Total"),
                      trailing: Text("Rp $grandTotal"),
                    ),

                    const SizedBox(height: 20),

                    // 🧭 Tombol aksi untuk admin
                    if (userRole == 'admin') ...[
                      ElevatedButton.icon(
                        onPressed: () {
                          _updateStatus(context, status);
                        },
                        icon: const Icon(Icons.sync),
                        label: const Text("Ubah Status Pesanan"),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ),
                    ],
                  ],

                  // 🧾 Status dan info dasar
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _updateStatus(BuildContext context, String currentStatus) async {
    String nextStatus = 'completed';

    switch (currentStatus) {
      case 'pending_payment':
        nextStatus = 'in_process';
        break;
      case 'in_process':
        nextStatus = 'shipped';
        break;
      case 'shipped':
        nextStatus = 'completed';
        break;
      default:
        nextStatus = 'completed';
    }

    // await FirebaseFirestore.instance.collection('orders').doc(orderId).update({
    //   'status': nextStatus,
    // });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Status diubah menjadi $nextStatus')),
    );
  }
}
