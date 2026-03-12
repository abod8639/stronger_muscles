import 'package:get/get.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import '../../../../core/config/api_config.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';

class ProductRemoteDataSource extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  Future<List<ProductModel>> getProductsFromApi({String? categoryId, String? query, int page = 1}) async {
    final response = await _apiService.get(
      ApiConfig.products,
      queryParameters: {'category': categoryId, 'search': query, 'page': page},
    );
    return _parseProductsList(response.data);
  }

  Future<ProductModel> getProductDetailsFromApi(String id) async {
    final response = await _apiService.get('${ApiConfig.products}/$id');
    final data = response.data;
    final productData = (data is Map && data['data'] != null) ? data['data'] : data;
    return ProductModel.fromJson(productData);
  }

  List<ProductModel> _parseProductsList(dynamic data) {
    List<dynamic> list = [];
    if (data is List) list = data;
    else if (data is Map) {
      final rawData = data['data'];
      if (rawData is List) list = rawData;
    }
    return list.map((json) => ProductModel.fromJson(json)).toList();
  }
}