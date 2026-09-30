import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/features/product/data/datasources/product_local_datasource.dart';
import 'package:stronger_muscles/features/product/data/datasources/product_remote_datasource.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';
import 'package:stronger_muscles/features/product/domain/repositories/product_repository.dart';

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
  return ProductRepositoryImpl(
    ref.watch(productRemoteDataSourceProvider),
    ref.watch(productLocalDataSourceProvider),
  );
}

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource _remote;
  final ProductLocalDataSource _local;

  ProductRepositoryImpl(this._remote, this._local);

  @override
  List<ProductEntity> getCachedProducts() {
    return _local.getCachedProducts().map((p) => p.toEntity()).toList();
  }

  @override
  Future<List<ProductEntity>> getProducts({
    String? categoryId,
    int page = 1,
  }) async {
    try {
      final products = await _remote.getProductsFromApi(
        categoryId: categoryId,
        page: page,
      );
      await _local.cacheProducts(products);
      return products.map((p) => p.toEntity()).toList();
    } on Failure catch (e) {
      if (e.type == FailureType.network &&
          _local.getCachedProducts().isNotEmpty) {
        final cached = categoryId != null
            ? _local
                  .getCachedProducts()
                  .where((p) => p.categoryId == categoryId)
                  .toList()
            : _local.getCachedProducts();
        return cached.map((p) => p.toEntity()).toList();
      }
      rethrow;
    }
  }

  /// Fetches a single product by ID (cache-first, then API).
  @override
  Future<ProductEntity> getProductById(String id) async {
    final cached = _local.getProductById(id);
    if (cached != null) return cached.toEntity();

    final product = await _remote.getProductDetailsFromApi(id);
    await _local.cacheProduct(product);
    return product.toEntity();
  }

  @override
  Future<List<ProductEntity>> searchProducts(String query) async {
    if (query.trim().isEmpty) {
      return await getProducts();
    }

    try {
      final products = await _remote.getProductsFromApi(query: query);
      return products.map((p) => p.toEntity()).toList();
    } on Failure catch (e) {
      if (e.type == FailureType.network) {
        final cached = _local.getCachedProducts().where((p) {
          final name = p.getLocalizedName().toLowerCase();
          return name.contains(query.toLowerCase());
        }).toList();
        return cached.map((p) => p.toEntity()).toList();
      }
      rethrow;
    }
  }
}
