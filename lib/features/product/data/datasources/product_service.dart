import 'package:get/get.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/errors/failures.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';

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
          'category': ?categoryId,
          'search': ?query,
          'page': page, 
          'limit': limit,
        },
      );

      // استخدام response.data مباشرة
      return _parseProductsList(response.data);
    } catch (e) {
      throw _handleError(e, "حدث خطأ عند جلب المنتجات");
    }
  }

  Future<ProductModel> getProductDetails(String id) async {
    try {
      final response = await _apiService.get('${ApiConfig.products}/$id');
      final data = response.data;

      // فحص البيانات المستلمة من Laravel Resource
      final productData = (data is Map && data['data'] != null)
          ? data['data']
          : data;

      return ProductModel.fromJson(productData);
    } catch (e) {
      // الـ ApiService يرمي Failure بالفعل، لذا rethrow كافية
      rethrow;
    }
  }

  List<ProductModel> _parseProductsList(dynamic data) {
    List<dynamic> list = [];

    if (data is List) {
      list = data;
    } else if (data is Map) {
      final rawData = data['data'];
      if (rawData is List) {
        list = rawData;
      } else if (rawData is Map && rawData['data'] is List) {
        list = rawData['data'];
      }
    }

    return list.map((json) => ProductModel.fromJson(json)).toList();
  }

  Failure _handleError(dynamic e, String defaultMsg) {
    if (e is Failure) return e;
    return Failure(message: defaultMsg, type: FailureType.unknown);
  }
}
