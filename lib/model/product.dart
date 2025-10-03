class Product {
  final int id;
  final String name;
  final String description;
  final double price;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
  });
}

final List<Product> dummyProducts = [
  Product(id: 1, name: "lemper", description: "lemper adalah", price: 2000),
  Product(id: 2, name: "kue sus", description: "kue sus adalah", price: 2000),
  Product(
    id: 3,
    name: "kue lapis",
    description: "kue lapis adalah",
    price: 1000,
  ),
];
