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
class ProductRepository extends _$ProductRepository {
  @override
  void build() {}

  List<ProductModel> getCachedProducts() {
    return ref.read(productLocalDataSourceProvider).getCachedProducts();
  }

  Future<List<ProductModel>> getProducts({
    String? categoryId,
    int page = 1,
  }) async {
    final remote = ref.read(productRemoteDataSourceProvider);
    final local = ref.read(productLocalDataSourceProvider);

    try {
      final products = await remote.getProductsFromApi(
        categoryId: categoryId,
        page: page,
      );
      await local.cacheProducts(products);
      return products;
    } on Failure catch (e) {
      if (e.type == FailureType.network &&
          local.getCachedProducts().isNotEmpty) {
        return categoryId != null
            ? local
                  .getCachedProducts()
                  .where((p) => p.categoryId == categoryId)
                  .toList()
            : local.getCachedProducts();
      }
      rethrow;
    }
  }

  Future<List<ProductModel>> searchProducts(String query) async {
    final remote = ref.read(productRemoteDataSourceProvider);
    final local = ref.read(productLocalDataSourceProvider);

    if (query.trim().isEmpty) {
      return await getProducts();
    }

    try {
      return await remote.getProductsFromApi(query: query);
    } on Failure catch (e) {
      if (e.type == FailureType.network) {
        return local.getCachedProducts().where((p) {
          final name = p.getLocalizedName().toLowerCase();
          return name.contains(query.toLowerCase());
        }).toList();
      }
      rethrow;
    }
  }
}
