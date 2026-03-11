import '../models/product_model.dart';

abstract class ProductRemoteDatasource {
  Future<List<ProductModel>> getAllProducts();
  Future<ProductModel> getProductById(String id);
  Future<void> createProduct(ProductModel model);
}

class ProductRemoteDatasourceImpl implements ProductRemoteDatasource {
  // TODO: inject Dio / http client

  @override
  Future<List<ProductModel>> getAllProducts() async {
    // TODO: implement API call
    throw UnimplementedError();
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    // TODO: implement API call
    throw UnimplementedError();
  }

  @override
  Future<void> createProduct(ProductModel model) async {
    // TODO: implement API call
    throw UnimplementedError();
  }
}
