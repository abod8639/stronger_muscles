import '../../data/models/product_model.dart';
import '../../data/models/category_model.dart';
import 'package:collection/collection.dart';

class ProductRepository {
  // This is a dummy repository to simulate fetching product details.
  // In a real application, this would interact with a backend API or database.

  static const int delay = 100;

  Future<ProductModel?> getProductById(String id) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: delay));

    return dummyProducts.firstWhereOrNull((product) => product.id == id);
  }

  Future<List<ProductModel>> getAllProducts() async {
    await Future.delayed(const Duration(milliseconds: delay));
    return dummyProducts;
  }
  //   Future<List<ProductModel>> getAllProducts() async {
  //   final snapshot = await _firestore.collection('products').get();
  //   return snapshot.docs.map((doc) => ProductModel.fromJson(doc.data())).toList();
  // }

  Future<List<ProductModel>> getProductsByCategory(String categoryId) async {
    await Future.delayed(const Duration(milliseconds: delay));
    return dummyProducts.where((p) => p.categoryId == categoryId).toList();
  }
//   Future<List<ProductModel>> getProducts({int page = 1, int pageSize = 20}) async {
//   final query = _firestore.collection('products')
//     .limit(pageSize)
//     .startAfterDocument(lastDocument);
//   // ...
// }

  Future<List<ProductModel>> getProteinProducts() async {
    return getProductsByCategory('protein');
  }

  Future<List<ProductModel>> getCreatineProducts() async {
    return getProductsByCategory('creatine');
  }

  Future<List<ProductModel>> getAminoProducts() async {
    return getProductsByCategory('amino');
  }

  Future<List<ProductModel>> getBCAAProducts() async {
    return getProductsByCategory('bcaa');
  }

  Future<List<ProductModel>> getPreWorkoutProducts() async {
    return getProductsByCategory('preworkout');
  }

  Future<List<ProductModel>> getMassGainerProducts() async {
    return getProductsByCategory('massgainer');
  }

  Future<List<CategoryModel>> getAllCategories() async {
    await Future.delayed(const Duration(milliseconds: delay));
    return PredefinedCategories.categories;
  }

  Future<List<ProductModel>> searchProducts(String query) async {
    await Future.delayed(const Duration(milliseconds: delay));
    final lowerQuery = query.toLowerCase();
    return dummyProducts.where((p) {
      return p.name.toLowerCase().contains(lowerQuery) ||
          p.description.toLowerCase().contains(lowerQuery) ||
          (p.brand?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }

  Future<List<ProductModel>> getFeaturedProducts() async {
    await Future.delayed(const Duration(milliseconds: delay));
    // Return top rated products
    final sorted = [...dummyProducts];
    sorted.sort((a, b) => b.averageRating.compareTo(a.averageRating));
    return sorted.take(6).toList();
  }
}


// Dummy product data with new structure
final List<ProductModel> dummyProducts = [
  // Protein Products

];
