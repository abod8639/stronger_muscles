import 'dart:convert';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import '../../config/api_config.dart';
import '../../data/models/product_model.dart';
import '../errors/failures.dart';

class ProductService extends GetxService {
  final ApiService _apiService = Get.find<ApiService>();

  Future<List<ProductModel>> getProducts({
    String? categoryId,
    String? query,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiService.get(
        ApiConfig.products,
        queryParameters: {
          'category': categoryId,
          'search': query,
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      final decodedData = jsonDecode(response.body);
      return _parseProductsList(decodedData);
    } catch (e) {
      throw _handleError(e, "حدث خطأ عند جلب المنتجات");
    }
  }

  Future<ProductModel> getProductDetails(String id) async {
    try {
      final response = await _apiService.get('${ApiConfig.products}/$id');
      final decodedData = jsonDecode(response.body);

      final productData = (decodedData is Map && decodedData['data'] != null)
          ? decodedData['data']
          : decodedData;

      return ProductModel.fromJson(productData);
    } catch (e) {
      rethrow;
    }
  }

  List<ProductModel> _parseProductsList(dynamic decodedData) {
    List<dynamic> list = [];
    if (decodedData is List) {
      list = decodedData;
    } else if (decodedData is Map) {
      final data = decodedData['data'];
      if (data is List) {
        list = data;
      } else if (data is Map && data['data'] is List) {
        list = data['data'];
      }
    }
    return list.map((json) => ProductModel.fromJson(json)).toList();
  }

  Failure _handleError(dynamic e, String defaultMsg) {
    if (e is Failure) return e;
    return Failure(
      message: defaultMsg,
      type: FailureType.unknown,
      originalError: e,
    );
  }
}
