import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetProductsUsecase {
  final ProductRepository repository;

  GetProductsUsecase(this.repository);

  Future<List<ProductEntity>> call() => repository.getAllProducts();
}
