import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:project_umkm/component/formatNumber.component.dart';
import 'package:project_umkm/controller/cart.controller.dart';
import 'package:project_umkm/controller/location.controller.dart';
import 'package:project_umkm/controller/users.controller.dart';
import 'package:project_umkm/model/users.model.dart';
import 'package:project_umkm/pages/userPage.dart';
import 'package:project_umkm/services/auth.service.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatefulWidget {
  final List<Map<String, dynamic>> data;
  final num totalPrice;

  const CheckoutPage({super.key, required this.data, required this.totalPrice});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  LatLng? userLocation;
  String? selectedShippingOption;
  String catatan = "";
  @override
  void initState() {
    super.initState();
    _loadUserLocation();
  }

  void _loadUserLocation() async {
    final authUser = context.read<AuthService>().currentUser;

    if (authUser != null) {
      final locationData = await LocationController().getLocation(authUser.uid);
      if (mounted) {
        setState(() {
          userLocation = locationData;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    CartController cartController = CartController();

    num biayaPengiriman = 11000;
    num biayaLayanan = 4000;

    String? name = "";
    String? alamat = "";
    String? nohp = "";
    String uid = "";
    final formatterNumber = FormatNumber();
    final userController usercontroller = userController();
    String? sellerUID;

    num total = widget.totalPrice + biayaPengiriman + biayaLayanan;
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
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
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Consumer<AuthService>(
                  builder: (context, auth, _) {
                    final user = auth.currentUser;

                    if (user == null) {
                      return Center(child: CircularProgressIndicator());
                    }
                    name = user.name;
                    alamat = user.alamat;
                    nohp = user.nohp;
                    uid = user.uid;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("", style: TextStyle(fontSize: 15)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Color.fromARGB(255, 182, 108, 11),
                              size: 26,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Rumah - ${user.name}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              formatterNumber.formatIndoPhone(user.nohp),
                              style: TextStyle(
                                fontWeight: FontWeight.w100,
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 34, top: 6),
                          child: Column(
                            children: [
                              Text(
                                "${user.alamat}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              FutureBuilder<LatLng?>(
                                future: LocationController().getLocation(
                                  user.uid,
                                ),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Padding(
                                      padding: EdgeInsets.only(top: 4),
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    );
                                  }

                                  return Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      userLocation != null
                                          ? "Koordinat: ${userLocation!.latitude}, ${userLocation!.longitude}"
                                          : "Koordinat tidak tersedia",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
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
                            const Icon(
                              Icons.info,
                              color: Colors.grey,
                              size: 20,
                            ),
                            const Spacer(),
                            Text(
                              'Jarak 4.2km',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _shippingOption("Prioritas < 30 Menit"),
                            _shippingOption("Standar - 30 Menit"),
                            _shippingOption("Terjadwal"),
                            SizedBox(width: 10),
                            Container(
                              child: ElevatedButton(
                                onPressed: () async {
                                  await usercontroller
                                      .fetchUsersByRoleSortedByDistance(
                                        context,
                                        userLocation!,
                                        'admin',
                                      );

                                  if (usercontroller.users.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "Tidak ada seller tersedia",
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  Users? selected = await showDialog<Users>(
                                    context: context,
                                    builder: (context) => SimpleDialog(
                                      title: const Text("Pilih Seller"),
                                      children: usercontroller.users.map((
                                        admin,
                                      ) {
                                        return SimpleDialogOption(
                                          onPressed: () =>
                                              Navigator.pop(context, admin),
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                  admin.photoURL,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              Text(admin.name),
                                            ],
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  );
                                  if (selected != null) {
                                    usercontroller.selectUser(selected);
                                    sellerUID = selected.uid;
                                  }
                                },
                                child: Text(
                                  usercontroller.selectedUser != null
                                      ? usercontroller.selectedUser!.name
                                      : "Pilih Seller",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(height: 4),

              Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(width: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Pesan Untuk Penjual'),
                    Text(
                      catatan.isEmpty
                          ? "Belum ada catatan"
                          : "Catatan: $catatan",
                    ),
                    const SizedBox(height: 10),
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
                  ],
                ),
              ),
              // Container Hasil Input dari catatan
              const SizedBox(height: 10),

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
                    Column(
                      children: widget.data.map((item) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  item['image'],
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['name'],
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Text(
                                        "Rp${item['price']}",
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Color.fromARGB(
                                            255,
                                            182,
                                            108,
                                            11,
                                          ),
                                        ),
                                      ),
                                      Text(" x ${item["quantity"]}"),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }).toList(),
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
                      children: [
                        Text(
                          'Total Pesanan ',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          formatter.format(widget.totalPrice),
                          style: TextStyle(
                            color: Color.fromARGB(255, 182, 108, 11),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Biaya Pengiriman ?',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          formatter.format(biayaPengiriman),
                          style: TextStyle(
                            color: Color.fromARGB(255, 182, 108, 11),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Biaya Layanan ?',
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          formatter.format(biayaLayanan),
                          style: TextStyle(
                            color: Color.fromARGB(255, 182, 108, 11),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                        Text(
                          formatter.format(total),
                          style: TextStyle(
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
                      onPressed: () async {
                        if (userLocation == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Lokasi belum tersedia"),
                            ),
                          );
                          return;
                        }
                        if (selectedShippingOption == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Pilih opsi pengiriman"),
                            ),
                          );
                          return;
                        }
                        if (sellerUID == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Pilih seller")),
                          );
                          return;
                        }

                        try {
                          final isValid =
                              userLocation != null &&
                              selectedShippingOption != null &&
                              sellerUID != null &&
                              nohp != null &&
                              name != null &&
                              alamat != null;

                          if (!isValid) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Lengkapi semua data sebelum checkout",
                                ),
                              ),
                            );
                            return;
                          }
                          await cartController.checkout(
                            uid: uid,
                            name: name!,
                            nohp: nohp!,
                            alamat: alamat!,
                            lokasi: userLocation!,
                            sellerUID: sellerUID!,
                            catatan: catatan,
                            opsi_pengiriman: selectedShippingOption!,
                            products: widget.data,
                            totalPrice: total,
                          );

                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 20,
                                horizontal: 20,
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                    size: 80,
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    "Pesanan Berhasil",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    "Pesanan berhasil dibuat!",
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              actionsAlignment: MainAxisAlignment.center,
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Tutup"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            UserPage(seller_uid: sellerUID),
                                      ),
                                    );
                                    debugPrint(
                                      "Seller UID dikirim ke UserPage: $sellerUID",
                                    );
                                  },
                                  child: const Text("Lihat Pesanan Anda"),
                                ),
                              ],
                            ),
                          );
                        } catch (e) {
                          // Jika terjadi error
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Gagal membuat pesanan: $e"),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
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

  Widget _shippingOption(String label) {
    bool isSelected = selectedShippingOption == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedShippingOption = label;
        });
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? const Color.fromARGB(255, 182, 108, 11)
                : Colors.grey,
          ),
          borderRadius: BorderRadius.circular(6),
          color: isSelected
              ? const Color.fromARGB(50, 182, 108, 11)
              : Colors.white,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? const Color.fromARGB(255, 182, 108, 11)
                : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
