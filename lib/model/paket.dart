class Paket {
  final int Id;
  final String productId;
  final String name;
  final String category;
  final String image;
  final String description;
  final int price;

  Paket({
    required this.Id,
    required this.productId,
    required this.name,
    required this.category,
    required this.image,
    required this.description,
    required this.price,
  });
}

final List<Paket> PaketProduct = [
  Paket(
    Id: 1,
    productId: "e001",
    name: "Paket Maulid",
    category: "Kue Basah",
    image: "asset/images/nagasari.png",
    description:
        "Isi 12 pcs Kue Klepon, 10 pcs Onde-Onde, dan 8 pcs Kue Apem.\nCocok untuk peringatan Maulid Nabi atau acara keagamaan kecil.",
    price: 50000,
  ),
  Paket(
    Id: 2,
    productId: "e002",
    name: "Paket Arisan",
    category: "Kue Basah",
    image: "asset/images/lapis.png",
    description:
        "Isi 10 pcs Kue Lapis, 8 pcs Dadar Gulung, dan 6 pcs Nagasari.\nCocok untuk snack box arisan keluarga atau komunitas.",
    price: 60000,
  ),
  Paket(
    Id: 3,
    productId: "e003",
    name: "Paket Ulang Tahun",
    category: "Kue Basah",
    image: "asset/images/apem.png",
    description:
        "Isi 12 pcs Kue Apem, 10 pcs Pandan Leaves, dan 8 pcs Kue Talam.\nCocok untuk pesta ulang tahun anak-anak atau dewasa.",
    price: 70000,
  ),
  Paket(
    Id: 4,
    productId: "e004",
    name: "Paket Syukuran",
    category: "Kue Basah",
    image: "asset/images/onde-onde.png",
    description:
        "Isi 10 pcs Onde-Onde, 8 pcs Kue Putu, dan 6 pcs Kue Dadar.\nPas untuk acara syukuran rumah atau acara keluarga.",
    price: 55000,
  ),
  Paket(
    Id: 5,
    productId: "e005",
    name: "Paket Pernikahan",
    category: "Kue Basah",
    image: "asset/images/talam.png",
    description:
        "Isi 15 pcs Kue Talam, 12 pcs Kue Lapis, dan 10 pcs Nagasari.\nCocok untuk dessert table pesta pernikahan atau resepsi.",
    price: 120000,
  ),
  Paket(
    Id: 6,
    productId: "e006",
    name: "Paket Event Kantor",
    category: "Kue Basah",
    image: "asset/images/nagasari.png",
    description:
        "Isi 10 pcs Nagasari, 10 pcs Dadar Gulung, dan 10 pcs Kue Klepon.\nCocok untuk rapat, meeting, atau snack kantor.",
    price: 80000,
  ),
  Paket(
    Id: 7,
    productId: "e007",
    name: "Paket Arisan RT",
    category: "Kue Basah",
    image: "asset/images/putu.png",
    description:
        "Isi 8 pcs Kue Putu, 8 pcs Kue Apem, dan 6 pcs Onde-Onde.\nCocok untuk arisan lingkungan atau RT.",
    price: 50000,
  ),
];
