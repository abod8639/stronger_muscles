import 'package:get/get.dart';
import 'package:stronger_muscles/features/product/data/datasources/product_service.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';

class ProductRemoteDataSource extends GetxService {
  final ProductService _productService = Get.find();

  Future<List<ProductModel>> getProductsFromApi({String? categoryId, String? query, int page = 1}) async {
    return _productService.getProducts(
      categoryId: categoryId,
      query: query,
      page: page,
    );
  }

  Future<ProductModel> getProductDetailsFromApi(String id) async {
    return _productService.getProductDetails(id);
  }
}