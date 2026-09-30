import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';

/// Domain contract defining product data operations.
abstract class ProductRepository {
  List<ProductEntity> getCachedProducts();
  Future<List<ProductEntity>> getProducts({String? categoryId, int page = 1});
  Future<ProductEntity> getProductById(String id);
  Future<List<ProductEntity>> searchProducts(String query);
}
