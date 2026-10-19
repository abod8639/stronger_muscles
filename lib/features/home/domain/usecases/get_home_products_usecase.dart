import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';
import 'package:stronger_muscles/features/product/domain/repositories/product_repository.dart';

/// Use case to fetch products for home view (cached or remote, with optional categoryId filter and pagination).
class GetHomeProductsUseCase {
  final ProductRepository _productRepository;

  const GetHomeProductsUseCase(this._productRepository);

  Future<List<ProductEntity>> call({String? categoryId, int page = 1}) async {
    if ((categoryId == null || categoryId.isEmpty) && page == 1) {
      final cached = _productRepository.getCachedProducts();
      if (cached.isNotEmpty) {
        return cached;
      }
    }
    return _productRepository.getProducts(categoryId: categoryId, page: page);
  }
}
