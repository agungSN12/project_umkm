class Product {
  final int Id;
  final String productId;
  final String name;
  final String category;
  final String image;
  final String description;
  final int price;

  Product({
    required this.Id,
    required this.productId,
    required this.name,
    required this.category,
    required this.image,
    required this.description,
    required this.price,
  });
}

final List<Product> products = [
  Product(
    Id: 1,
    productId: "k001",
    name: "Kue Lapis",
    category: "Kue Basah",
    image: "asset/images/kue mamay.png",
    description:
        "Lapis Legit Aduhay\n"
        "Kategori: Kue Basah Tradisional\n"
        "Berat/Isi: 250 gr (±12 pcs)\n\n"
        "Komposisi: Tepung ketan, gula merah, kelapa parut, garam\n"
        "Rasa & Tekstur: Lembut, kenyal, manis meleleh saat digigit\n\n"
        "Tanggal Produksi: Hari pengiriman\n"
        "Expired / Ketahanan: 1 hari suhu ruang, 2 hari di kulkas",
    price: 6000,
  ),
  Product(
    Id: 2,
    productId: "k002",
    name: "Kelepon",
    category: "Kue Tradisional",
    image: "asset/images/klepon.png",
    description:
        "Klepon Ketan Isi Gula Merah\n"
        "Kategori: Kue Basah Tradisional\n"
        "Berat/Isi: 250 gr (±12 pcs)\n\n"
        "Komposisi: Tepung ketan, gula merah, kelapa parut, garam\n"
        "Rasa & Tekstur: Lembut, kenyal, manis meleleh saat digigit\n\n"
        "Tanggal Produksi: Hari pengiriman\n"
        "Expired / Ketahanan: 1 hari suhu ruang, 2 hari di kulkas",
    price: 15000,
  ),
];
