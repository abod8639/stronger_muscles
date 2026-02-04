import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/core/services/product_service.dart';
import '../../data/models/product_model.dart';
import '../../data/models/category_model.dart';

class ProductRepository {
  final ProductService _apiService = Get.find<ProductService>();
  final Box<ProductModel> _box = Hive.box<ProductModel>('products');

  List<ProductModel> getCachedProducts() {
    return _box.values.toList();
  }

  Future<List<ProductModel>> getAllProducts() async {
    try {
      final products = await _apiService.getProducts(); // استدعاء الـ API

      // تحديث الكاش: نستخدم putAll لتحسين الأداء (Single Transaction)
      if (products.isNotEmpty) {
        await _box.clear();
        final productMap = {for (var p in products) p.id: p};
        await _box.putAll(productMap);
      }
      
      return products;
    } on Failure catch (e) {
      // إذا حدث خطأ شبكة، نعود للكاش كخيار احتياطي (Fallback)
      if (e.type == FailureType.network && _box.isNotEmpty) {
        return _box.values.toList();
      }
      rethrow;
    }
  }

  Future<ProductModel> getProductById(String id) async {
  if (_box.containsKey(id)) {
    print('DEBUG: Product $id found in cache');
    return _box.get(id)!;
  }
  try {
    final product = await _apiService.getProductDetails(id);
    
    await _box.put(id, product);
    
    return product;
  } on Failure {
    if (_box.containsKey(id)) {
      return _box.get(id)!;
    }
    rethrow;
  }
}

  Future<List<ProductModel>> getProductsByCategory(String categoryId) async {
    try {
      return await _apiService.getProducts(categoryId: categoryId);
    } on Failure catch (e) {
      if (e.type == FailureType.network) {
        return _box.values.where((p) => p.categoryId == categoryId).toList();
      }
      rethrow;
    }
  }

  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      return await _apiService.getProducts(query: query);
    } on Failure catch (e) {
      if (e.type == FailureType.network) {
        return _box.values
            .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      rethrow;
    }
  }


  Future<List<ProductModel>> getFeaturedProducts() async {
    final all = await getAllProducts();
    all.sort((a, b) => b.averageRating.compareTo(a.averageRating));
    return all.take(6).toList();
  }

  Future<List<CategoryModel>> getAllCategories() async {
    return PredefinedCategories.categories;
  }

  Future<List<ProductModel>> getProteinProducts() => getProductsByCategory('protein');
  Future<List<ProductModel>> getCreatineProducts() => getProductsByCategory('creatine');
  Future<List<ProductModel>> getAminoProducts() => getProductsByCategory('amino');
  Future<List<ProductModel>> getBCAAProducts() => getProductsByCategory('bcaa');
}