import 'package:get/get.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/product/data/datasources/product_service.dart';

class SearchRemoteDataSource {
  final ProductService _productService = Get.find();

  Future<List<ProductModel>> fetchProductsFromApi(String query) async {
    return await _productService.getProducts(query: query);
  }
}