class Cart {
  final int id;
  final String productId;
  final String name;
  final String image;
  final int price;
  final int quantity;

  Cart({
    required this.id,
    required this.productId,
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
  });

  // Konversi dari Map (data Firestore) ke objek Cart
  factory Cart.fromMap(Map<String, dynamic> map, int documentId) {
    return Cart(
      id: documentId,
      productId: map['productId'] ?? '',
      name: map['name'] ?? '',
      image: map['image'] ?? '',
      price: map['price'] ?? 0,
      quantity: map['quantity'] ?? 1,
    );
  }

  // Konversi dari Cart ke Map (untuk disimpan ke Firestore)
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'image': image,
      'price': price,
      'quantity': quantity,
    };
  }
}
