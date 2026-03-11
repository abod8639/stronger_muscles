import '../models/product_model.dart';

abstract class ProductLocalDatasource {
  Future<List<ProductModel>> getCachedProducts();
  Future<void> cacheProducts(List<ProductModel> models);
}

class ProductLocalDatasourceImpl implements ProductLocalDatasource {
  // TODO: inject SharedPreferences / Hive / Isar

  @override
  Future<List<ProductModel>> getCachedProducts() async {
    // TODO: implement local read
    throw UnimplementedError();
  }

  @override
  Future<void> cacheProducts(List<ProductModel> models) async {
    // TODO: implement local write
    throw UnimplementedError();
  }
}
