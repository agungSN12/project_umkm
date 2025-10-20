class Cart {
  final int id;
  final String uid;
  final String productId;
  final String name;
  final String image;
  final int price;
  final int quantity;

  Cart({
    required this.id,
    required this.uid,
    required this.productId,
    required this.name,
    required this.image,
    required this.price,
    required this.quantity,
  });

  factory Cart.fromMap(Map<String, dynamic> map, int documentId, String uid) {
    return Cart(
      id: documentId,
      uid: uid,
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
      'uid': uid,
      'productId': productId,
      'name': name,
      'image': image,
      'price': price,
      'quantity': quantity,
    };
  }
}
