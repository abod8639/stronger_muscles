import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetProductByIdUsecase {
  final ProductRepository repository;

  GetProductByIdUsecase(this.repository);

  Future<ProductEntity> call(String id) => repository.getProductById(id);
}
