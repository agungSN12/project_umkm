import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: CheckoutPage()));
}

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  int jumlah = 1;
  String catatan = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 234, 234),
      appBar: AppBar(
        title: const Text(
          "Checkout",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 182, 108, 11),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 🏠 Container Alamat Pengiriman
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Alamat Pengiriman Kamu",
                      style: TextStyle(fontSize: 15),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Color.fromARGB(255, 182, 108, 11),
                          size: 26,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "Rumah - Nama User",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '(+62) 896-542-329-69',
                          style: TextStyle(
                            fontWeight: FontWeight.w100,
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 34, top: 6),
                      child: Text(
                        "Dsn. Ciburaleng, Kec. Cimanggung, Kab. Sumedang",
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Icon(
                          Icons.local_shipping,
                          color: Color.fromARGB(255, 182, 108, 11),
                          size: 26,
                        ),
                        const SizedBox(width: 3),
                        const Text('Opsi Pengiriman'),
                        const SizedBox(width: 3),
                        const Icon(Icons.info, color: Colors.grey, size: 20),
                        const Spacer(),
                        Text(
                          'Jarak 4.2km',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text("Prioritas < 30 Menit"),
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Color.fromARGB(255, 182, 108, 11),
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            "Standar - 30 Menit",
                            style: TextStyle(
                              color: Color.fromARGB(255, 182, 108, 11),
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text("Terjadwal"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 4),

              //  Container Catatan Pesanan
              Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pesan Untuk Penjual'),
                    ElevatedButton(
                      onPressed: () {
                        TextEditingController controller =
                            TextEditingController(text: catatan);

                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text(
                                "Tambah Catatan",
                                style: TextStyle(color: Colors.black),
                              ),
                              content: TextField(
                                controller: controller,
                                maxLines: 3,
                                decoration: const InputDecoration(
                                  hintText: "Masukkan catatan pesanan",
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text(
                                    "Batal",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      catatan = controller.text;
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Konfirmasi"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 182, 108, 11),
                      ),
                      child: const Text(
                        "Tambah Catatan",
                        style: TextStyle(
                          color: (Color.fromARGB(255, 255, 255, 255)),
                        ),
                      ),
                    ),
                    // const SizedBox(height: 10),
                    // Text(
                    //   catatan.isEmpty
                    //       ? "Belum ada catatan"
                    //       : "Catatan: $catatan",
                    // ),
                  ],
                ),
              ),
              // Container Hasil Input dari catatan
              const SizedBox(height: 0),
              Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Catatan:', style: TextStyle(fontSize: 18)),
                            const SizedBox(width: 230),
                            Text(
                              catatan.isEmpty
                                  ? "Belum ada catatan"
                                  : "$catatan",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 4),

              //  Detail Pesanan
              Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.storefront,
                          color: Color.fromARGB(255, 182, 108, 11),
                        ),
                        const Text(
                          "Kiwari Bakery",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),
                    Row(
                      children: [
                        // Jika belum ada asset, comment dulu
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'asset/images/putu.png',
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),

                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Kue Putu Tradisional Isi Gula Merah"),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (jumlah > 1) jumlah--;
                                    });
                                  },
                                  icon: const Icon(Icons.remove_circle_outline),
                                  color: Colors.brown,
                                ),
                                Text(
                                  "$jumlah",
                                  style: const TextStyle(fontSize: 16),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      jumlah++;
                                    });
                                  },
                                  icon: const Icon(Icons.add_circle_outline),
                                  color: Colors.brown,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Rp10.000",
                              style: TextStyle(
                                fontSize: 16,
                                color: Color.fromARGB(255, 182, 108, 11),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 4),

              // Rincian Pembayaran
              Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.payment,
                          color: Color.fromARGB(255, 182, 108, 11),
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          'Rincian Pembayaran',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Total Pesanan (1 menu)',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text('10.000'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Total Biaya Pengiriman ?',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          '11.000',
                          style: TextStyle(
                            color: Color.fromARGB(255, 182, 108, 11),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Biaya Layanan ?',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text('4.000'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          'Total',
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                        Text(
                          '25.000',
                          style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 182, 108, 11),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 4),

              //  Tombol Buat Pesanan
              Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Pesan Sekarang?',
                      style: TextStyle(fontSize: 15),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        print('Pesanan dibuat!');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          182,
                          108,
                          11,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Buat Pesanan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
