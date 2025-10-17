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
    name: "Kue Klepon",
    category: "Kue Basah",
    image: "asset/images/klepon.png",
    description:
        "Kue Klepon Tradisional\n"
        "Kategori: Kue Basah Tradisional\n"
        "Isi: ±12 pcs\n"
        "Komposisi: Tepung ketan, gula merah, kelapa parut\n"
        "Rasa: Manis legit, kenyal, dan gurih kelapa\n"
        "Harga Asli: Rp 8.000\n"
        "Promo: Rp 6.000",
    price: 6000,
  ),
  Product(
    Id: 2,
    productId: "k002",
    name: "Kue Klepon (Jumbo)",
    category: "Kue Basah",
    image: "asset/images/klepon.png",
    description:
        "Klepon ukuran jumbo isi gula merah leleh.\n"
        "Kategori: Kue Basah Tradisional\n"
        "Isi: ±8 pcs\n"
        "Komposisi: Tepung ketan, gula merah, kelapa parut\n"
        "Rasa: Kenyal dan manis.\n"
        "Harga: Rp 10.000",
    price: 10000,
  ),
  Product(
    Id: 3,
    productId: "k003",
    name: "Kue Santan Kelapa",
    category: "Kue Basah",
    image: "asset/images/dadarG.png",
    description:
        "Kue lembut rasa santan dan kelapa.\n"
        "Harga Asli: Rp 13.000\n"
        "Promo: Rp 10.000",
    price: 10000,
  ),
  Product(
    Id: 4,
    productId: "k004",
    name: "Pandan Leaves",
    category: "Kue Basah",
    image: "asset/images/1.png",
    description:
        "Kue pandan harum dan lembut.\n"
        "Harga Asli: Rp 13.000\n"
        "Promo: Rp 10.000",
    price: 10000,
  ),
  Product(
    Id: 5,
    productId: "k005",
    name: "Onde-Onde",
    category: "Kue Basah",
    image: "asset/images/onde-onde.png",
    description:
        "Onde-onde isi kacang hijau, kulit kenyal dan gurih wijen.\n"
        "Harga Asli: Rp 13.000\n"
        "Promo: Rp 10.000",
    price: 10000,
  ),
  Product(
    Id: 6,
    productId: "k006",
    name: "Kue Talam Betawi",
    category: "Kue Basah",
    image: "asset/images/talam.png",
    description:
        "Kue talam khas Betawi, rasa manis dan gurih santan.\n"
        "Harga Asli: Rp 13.000\n"
        "Promo: Rp 10.000",
    price: 10000,
  ),
  Product(
    Id: 7,
    productId: "k007",
    name: "Nagasari",
    category: "Kue Basah",
    image: "asset/images/nagasari.png",
    description:
        "Nagasari isi pisang manis dan gurih.\n"
        "Harga Asli: Rp 13.000\n"
        "Promo: Rp 10.000",
    price: 10000,
  ),
  Product(
    Id: 8,
    productId: "k008",
    name: "Kue Apem",
    category: "Kue Basah",
    image: "asset/images/apem.png",
    description:
        "Kue apem tradisional, manis dan lembut.\n"
        "Harga Asli: Rp 13.000\n"
        "Promo: Rp 10.000",
    price: 10000,
  ),
  Product(
    Id: 9,
    productId: "k009",
    name: "Kue Lupis",
    category: "Kue Basah",
    image: "asset/images/lupis.png",
    description:
        "Lupis ketan manis gula merah, disajikan dengan kelapa parut.\n"
        "Harga Asli: Rp 13.000\n"
        "Promo: Rp 10.000",
    price: 10000,
  ),
  Product(
    Id: 10,
    productId: "k010",
    name: "Kue Lapis",
    category: "Kue Basah",
    image: "asset/images/lapis.png",
    description:
        "Kue lapis berwarna-warni dengan rasa manis lembut.\n"
        "Harga Asli: Rp 13.000\n"
        "Promo: Rp 10.000",
    price: 10000,
  ),
  Product(
    Id: 11,
    productId: "k011",
    name: "Kue Putu",
    category: "Kue Basah",
    image: "asset/images/putu.png",
    description:
        "Kue putu isi gula merah aroma pandan.\n"
        "Harga Asli: Rp 13.000\n"
        "Promo: Rp 10.000",
    price: 10000,
  ),
];
