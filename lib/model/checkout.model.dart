class CheckoutModel {
  final String namaProduk;
  final int harga;
  final int jumlahAwal;
  final String gambar;
  final String alamat;
  final String noTelp;

  CheckoutModel({
    required this.namaProduk,
    required this.harga,
    this.jumlahAwal = 1,
    required this.gambar,
    required this.alamat,
    required this.noTelp,
  });
}
