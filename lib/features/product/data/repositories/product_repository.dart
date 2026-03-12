import 'package:get/get.dart';
import 'package:stronger_muscles/features/product/data/datasources/product_local_datasource.dart';
import 'package:stronger_muscles/features/product/data/datasources/product_remote_datasource.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/core/errors/failures.dart';

class ProductRepository {
  final ProductRemoteDataSource _remote = Get.find<ProductRemoteDataSource>();
  final ProductLocalDataSource _local = ProductLocalDataSource();

  List<ProductModel> getCachedProducts() => _local.getCachedProducts();

  Future<List<ProductModel>> getProducts({String? categoryId, int page = 1}) async {
    try {
      final products = await _remote.getProductsFromApi(categoryId: categoryId, page: page);
      await _local.cacheProducts(products);
      return products;
    } on Failure catch (e) {
      if (e.type == FailureType.network && _local.getCachedProducts().isNotEmpty) {
        return categoryId != null 
            ? _local.getCachedProducts().where((p) => p.categoryId == categoryId).toList()
            : _local.getCachedProducts();
      }
      rethrow;
    }
  }

  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      return await _remote.getProductsFromApi(query: query);
    } on Failure catch (e) {
      if (e.type == FailureType.network) {
        return _local.getCachedProducts().where((p) => 
          p.getLocalizedName().toLowerCase().contains(query.toLowerCase())).toList();
      }
      rethrow;
    }
  }
}