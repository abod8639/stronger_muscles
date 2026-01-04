import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../../config/api_config.dart';
import '../../data/models/product_model.dart';
import '../errors/failures.dart';

class ProductService extends GetxService {
  String get _productBaseUrl => '${ApiConfig.baseUrl}${ApiConfig.products}';

  Future<List<ProductModel>> getProducts({
    String? categoryId,
    String? query,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      // Build URI with query parameters
      final uri = Uri.parse(_productBaseUrl).replace(queryParameters: {
        if (categoryId != null) 'category': categoryId,
        if (query != null) 'search': query,
        'page': page.toString(),
        'limit': limit.toString(),
      });

      print('DEBUG: Fetching products from $uri');
      final response = await http.get(uri);

      print('DEBUG: Response status: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        print('DEBUG: Response data type: ${decodedData.runtimeType}');

        if (decodedData is List) {
          return (decodedData)
              .map((json) => ProductModel.fromJson(json))
              .toList();
        } else if (decodedData is Map) {
          final data = decodedData['data'];
          if (data is List) {
            return data.map((json) => ProductModel.fromJson(json)).toList();
          } else if (data is Map && data['data'] is List) {
            final innerList = data['data'] as List;
            return innerList.map((json) => ProductModel.fromJson(json)).toList();
          }
        }
      } else {
         throw Failure(
            message: "خطأ في الخادم: ${response.statusCode}",
            type: FailureType.server,
         );
      }
      
      print('DEBUG: Failed to load products (structure mismatch): ${response.body}');
      return [];
    } catch (e) {
      print("DEBUG: Error in getProducts: $e");
      if (e is Failure) rethrow;

      if (e is http.ClientException || e.toString().contains('SocketException')) {
        throw Failure(
          message: "تعذر الوصول إلى الخادم. تأكد من تشغيل السيرفر وعنوان الـ IP", 
          type: FailureType.network, 
          originalError: e
        );
      }
      
      throw Failure(message: "حدث خطأ غير متوقع: $e", type: FailureType.unknown, originalError: e);
    }
  }

  Future<ProductModel> getProductById(String id) async {
    try {
      final uri = Uri.parse('$_productBaseUrl/$id');
      print('DEBUG: Fetching product from $uri');
      final response = await http.get(uri);
      
      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        return ProductModel.fromJson(decodedData);
      } else {
        throw Failure(message: "المنتج غير موجود", type: FailureType.server);
      }
    } catch (e) {
      print("DEBUG: Error in getProductById: $e");
      if (e is Failure) rethrow;
      throw Failure(message: "فشل في تحميل المنتج", type: FailureType.unknown, originalError: e);
    }
  }
}



