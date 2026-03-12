import 'package:hive/hive.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';

class ProductLocalDataSource {
  final Box<ProductModel> _box = Hive.box<ProductModel>('products');

  List<ProductModel> getCachedProducts() => _box.values.toList();

  Future<void> cacheProducts(List<ProductModel> products) async {
    for (var product in products) {
      await _box.put(product.id, product);
    }
  }

  Future<void> cacheProduct(ProductModel product) async => await _box.put(product.id, product);

  ProductModel? getProductById(String id) => _box.get(id);

  Future<void> clearCache() async => await _box.clear();
}