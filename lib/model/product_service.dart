// import 'package:project_umkm/model/product.dart';

// class ProductService {
//   // Ambil semua produk
//   List<Product> getAllProducts() {
//     return products;
//   }

//   // Filter produk berdasarkan nama/kategori
//   List<Product> searchProducts(String query) {
//     if (query.isEmpty) return products; // jika kosong, tampil semua

//     final lowerQuery = query.toLowerCase();
//     return products.where((product) {
//       return product.name.toLowerCase().contains(lowerQuery) ||
//           product.category.toLowerCase().contains(lowerQuery);
//     }).toList();
//   }
// }
