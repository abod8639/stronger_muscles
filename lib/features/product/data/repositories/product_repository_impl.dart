import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';
import '../datasources/product_local_datasource.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource remoteDatasource;
  final ProductLocalDatasource localDatasource;

  ProductRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  @override
  Future<List<ProductEntity>> getAllProducts() async {
    final models = await remoteDatasource.getAllProducts();
    await localDatasource.cacheProducts(models);
    return models;
  }

  @override
  Future<ProductEntity> getProductById(String id) =>
      remoteDatasource.getProductById(id);

  @override
  Future<void> createProduct(ProductEntity entity) =>
      remoteDatasource.createProduct(ProductModel(id: entity.id, name: entity.name));
}
