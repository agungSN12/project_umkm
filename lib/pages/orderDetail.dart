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

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final produk = data['produk'] ?? [];
              final status = data['status'] ?? 'unknown';
              final alamat = data['alamat'] ?? '-';
              final catatan = data['catatan'] ?? '-';
              final grandTotal = data['total'] ?? 0;
              final biayaPengiriman = data['biayaPengiriman'] ?? 0;
              final opsiPengiriman = data['opsiPengiriman'] ?? '-';
              final nohp = data["nohp"];
              final name = data["name"];
              final koordinat = data['koordinat'] as Map<String, dynamic>?;

              // Ambil lat dan lng
              final double lat = koordinat?['lat'] ?? 0.0;
              final double lng = koordinat?['lng'] ?? 0.0;

              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nama Customer: $name",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "Status: $status",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text("Pengiriman: $opsiPengiriman"),
                      const SizedBox(height: 8),
                      Text("No. HP: ${nohp}"),
                      Text("Alamat: $alamat"),
                      Row(
                        children: [
                          Text("lat: $lat"),
                          SizedBox(width: 10),
                          Text("lng: ${lng}"),
                        ],
                      ),

                      Text("Catatan: $catatan"),
                      const Divider(),
                      const Text(
                        "Daftar Produk",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: produk.length,
                        itemBuilder: (context, i) {
                          final item = produk[i];
                          return ListTile(
                            leading: Image.asset(
                              item['image'] ?? '',
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                            title: Text(item['name'] ?? 'Produk'),
                            subtitle: Text("Rp ${item['price']}"),
                          );
                        },
                      ),
                      const Divider(),
                      ListTile(
                        title: const Text("Biaya Pengiriman"),
                        trailing: Text("Rp $biayaPengiriman"),
                      ),
                      ListTile(
                        title: const Text("Total"),
                        trailing: Text("Rp $grandTotal"),
                      ),
                      if (userRole == 'admin')
                        ElevatedButton.icon(
                          onPressed: () =>
                              _updateStatus(context, status, docs[index]),
                          icon: const Icon(Icons.sync),
                          label: const Text("Ubah Status Pesanan"),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _updateStatus(
    BuildContext context,
    String currentStatus,
    QueryDocumentSnapshot docId,
  ) async {
    String nextStatus = 'completed';
    bool isAlreadyCompleted = currentStatus == 'completed';
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

    await docId.reference.update({'status': nextStatus});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Status diubah menjadi $nextStatus')),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text("Sukses"),
          ],
        ),
        content: Text(
          isAlreadyCompleted
              ? "Pesanan sudah selesai "
              : "Status diubah menjadi $nextStatus ",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
