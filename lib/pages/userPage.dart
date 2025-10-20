import 'package:flutter/material.dart';
import 'package:project_umkm/component/location.component.dart';
import 'package:project_umkm/component/navbar.component.dart';
import 'package:project_umkm/controller/orders.controller.dart';
import 'package:project_umkm/services/auth.service.dart';
import 'package:provider/provider.dart';

class UserPage extends StatefulWidget {
  final String? seller_uid;

  const UserPage({Key? key, this.seller_uid}) : super(key: key);
  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  void initState() {
    super.initState();
    final uid = context.read<AuthService>().currentUser?.uid;

    if (uid != null) {
      context.read<OrdersController>().startListening(uid, widget.seller_uid);
    }
  }

  @override
  void dispose() {
    context.read<OrdersController>().stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ordersController = Provider.of<OrdersController>(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 235, 234, 234),

      body: SingleChildScrollView(
        child: Consumer<AuthService>(
          builder: (context, auth, _) {
            final user = auth.currentUser;
            return Column(
              children: [
                Container(
                  color: Color(0xFF6D4C41),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 40,
                      left: 16,
                      right: 16,
                      bottom: 40,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Navigation(),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.arrow_back_outlined,
                                color: Colors.white,
                              ),
                            ),

                            CircleAvatar(
                              radius: 15,
                              backgroundImage: NetworkImage(
                                user?.photoURL ??
                                    'https://via.placeholder.com/150',
                              ),
                            ),

                            const SizedBox(width: 8),
                            Text(
                              "${user?.name}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                fontFamily: 'Poppins',
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(width: 10),
                        IconButton(
                          icon: const Icon(
                            Icons.logout,
                            color: Color.fromARGB(255, 247, 247, 247),
                          ),
                          onPressed: () async {
                            final shouldLogout = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Konfirmasi Logout"),
                                content: const Text(
                                  "Apakah kamu yakin ingin keluar dari akun ini?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false), // batal
                                    child: const Text("Batal"),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(
                                      context,
                                      true,
                                    ), // konfirmasi logout
                                    child: const Text(
                                      "Keluar",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );

                            if (shouldLogout == true) {
                              await auth.signOut();

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Berhasil logout"),
                                ),
                              );

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Navigation(),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                // Pesan
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // border: Border.all(width: 10),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.mail,
                              color: Color(0xFF6D4C41),
                            ),
                            onPressed: () {},
                          ),
                          Expanded(
                            child: Text(
                              'Verifikasi Emailmu Agar kami dapat memastikan identiasmu, melindungi akunmu, dan menerima update pesananmu.',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                //Transaksi
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // border: Border.all(width: 10),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Transaksi",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Consumer<OrdersController>(
                        builder: (context, ordersController, _) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              if (user?.role == 'admin') ...[
                                Column(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.confirmation_num,
                                        color: Color(0xFF6D4C41),
                                      ),
                                      onPressed: () {},
                                    ),
                                    const Text('Konfirmasi'),
                                  ],
                                ),
                                Column(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.hourglass_bottom,
                                        color: Color(0xFF6D4C41),
                                      ),
                                      onPressed: () {},
                                    ),
                                    const Text('diproses'),
                                  ],
                                ),
                                Column(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delivery_dining,
                                        color: Color(0xFF6D4C41),
                                      ),
                                      onPressed: () {},
                                    ),
                                    const Text('Mengirim'),
                                  ],
                                ),
                                Column(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.check_circle,
                                        color: Color(0xFF6D4C41),
                                      ),
                                      onPressed: () {},
                                    ),
                                    const Text('Selesai'),
                                  ],
                                ),
                              ] else ...[
                                // Bayar
                                _iconWithBadge(
                                  icon: Icons.attach_money,
                                  label: 'Bayar',
                                  badgeCount: ordersController.pendingPayments,
                                  onPressed: () {},
                                ),
                                // Diproses
                                _iconWithBadge(
                                  icon: Icons.hourglass_bottom,
                                  label: 'Diproses',
                                  badgeCount: ordersController.inProcess,
                                  onPressed: () {},
                                ),
                                // Dikirim
                                _iconWithBadge(
                                  icon: Icons.delivery_dining,
                                  label: 'Dikirim',
                                  badgeCount: ordersController.shipped,
                                  onPressed: () {},
                                ),
                                // Selesai
                                _iconWithBadge(
                                  icon: Icons.check_circle,
                                  label: 'Selesai',
                                  badgeCount: ordersController.completed,
                                  onPressed: () {},
                                ),
                              ],
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Saldo Dan Point
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // border: Border.all(width: 10),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Saldo & Point",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.account_balance_wallet,
                                  color: Color(0xFF6D4C41),
                                ),
                                onPressed: () {
                                  // Belum ada aksinya
                                },
                              ),
                              Text(
                                'Rp 100.000',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              Text('Saldo'),
                            ],
                          ),
                          Container(width: 1, height: 70, color: Colors.grey),
                          Column(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.circle,
                                  color: Colors.amber,
                                ),
                                onPressed: () {
                                  // Belum ada aksinya
                                },
                              ),
                              Text(
                                'Rp0',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              Text('Bonus'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Bantuan
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: const [
                      Row(
                        children: [
                          Text(
                            'Bantuan',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      ListTile(
                        leading: Icon(Icons.help_outline),
                        title: Text("Pusat Bantuan"),
                        trailing: Icon(Icons.chevron_right),
                      ),
                      Divider(),
                      ListTile(
                        leading: Icon(Icons.support_agent),
                        title: Text("Chat Dengan Kiwari"),
                        trailing: Icon(Icons.chevron_right),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Alamat Saya',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton.icon(
                        onPressed: () {
                          if (user != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PickLocationPage(userId: user.uid),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("User belum login")),
                            );
                          }
                        },
                        icon: const Icon(Icons.location_on),
                        label: const Text('Pilih Alamat di Maps'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6D4C41),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

Widget _iconWithBadge({
  required IconData icon,
  required String label,
  required int badgeCount,
  required VoidCallback onPressed,
}) {
  return Column(
    children: [
      IconButton(
        icon: Stack(
          children: [
            Icon(icon, color: Color(0xFF6D4C41)),
            if (badgeCount > 0)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$badgeCount',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
          ],
        ),
        onPressed: onPressed,
      ),
      Text(label),
    ],
  );
}
