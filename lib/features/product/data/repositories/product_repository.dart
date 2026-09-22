import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/features/product/data/datasources/product_local_datasource.dart';
import 'package:stronger_muscles/features/product/data/datasources/product_remote_datasource.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/core/services/api_service.dart';

part 'product_repository.g.dart';

@Riverpod(keepAlive: true)
ProductRemoteDataSource productRemoteDataSource(
  ProductRemoteDataSourceRef ref,
) {
  return ProductRemoteDataSource(ref.watch(apiServiceProvider));
}

@Riverpod(keepAlive: true)
ProductLocalDataSource productLocalDataSource(ProductLocalDataSourceRef ref) {
  return ProductLocalDataSource();
}

@Riverpod(keepAlive: true)
ProductRepository productRepository(ProductRepositoryRef ref) {
  return ProductRepository(
    ref.watch(productRemoteDataSourceProvider),
    ref.watch(productLocalDataSourceProvider),
  );
}

class ProductRepository {
  final ProductRemoteDataSource _remote;
  final ProductLocalDataSource _local;

  ProductRepository(this._remote, this._local);

  List<ProductModel> getCachedProducts() {
    return _local.getCachedProducts();
  }

  Future<List<ProductModel>> getProducts({
    String? categoryId,
    int page = 1,
  }) async {
    try {
      final products = await _remote.getProductsFromApi(
        categoryId: categoryId,
        page: page,
      );
      await _local.cacheProducts(products);
      return products;
    } on Failure catch (e) {
      if (e.type == FailureType.network &&
          _local.getCachedProducts().isNotEmpty) {
        return categoryId != null
            ? _local
                  .getCachedProducts()
                  .where((p) => p.categoryId == categoryId)
                  .toList()
            : _local.getCachedProducts();
      }
      rethrow;
    }
  }

  /// Fetches a single product by ID (cache-first, then API).
  Future<ProductModel> getProductById(String id) async {
    final cached = _local.getProductById(id);
    if (cached != null) return cached;

    final product = await _remote.getProductDetailsFromApi(id);
    await _local.cacheProduct(product);
    return product;
  }

  Future<List<ProductModel>> searchProducts(String query) async {
    if (query.trim().isEmpty) {
      return await getProducts();
    }

    try {
      return await _remote.getProductsFromApi(query: query);
    } on Failure catch (e) {
      if (e.type == FailureType.network) {
        return _local.getCachedProducts().where((p) {
          final name = p.getLocalizedName().toLowerCase();
          return name.contains(query.toLowerCase());
        }).toList();
      }
      rethrow;
    }
  }
}
