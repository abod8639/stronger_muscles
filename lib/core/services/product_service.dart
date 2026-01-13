import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../config/api_config.dart';
import '../../data/models/product_model.dart';
import '../errors/failures.dart';

class ProductService extends GetxService {
  
  String get _productBaseUrl => '${ApiConfig.baseUrl}${ApiConfig.products}';
  
  Box<ProductModel> get _productsBox => Hive.box<ProductModel>('products');

  Future<List<ProductModel>> getProducts({
    String? categoryId,
    String? query,
    int page = 1,
    int limit = 20,
  }) async {
    try {
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

        List<ProductModel> products = [];
        if (decodedData is List) {
          products = (decodedData)
              .map((json) => ProductModel.fromJson(json))
              .toList();
        } else if (decodedData is Map) {
          final data = decodedData['data'];
          if (data is List) {
            products = data.map((json) => ProductModel.fromJson(json)).toList();
          } else if (data is Map && data['data'] is List) {
            final innerList = data['data'] as List;
            products = innerList.map((json) => ProductModel.fromJson(json)).toList();
          }
        }
        
        // Cache products if it's the first page and no search/category filter (or customize as needed)
        // For efficiency, let's cache all products we get
        if (products.isNotEmpty) {
           for (var p in products) {
             await _productsBox.put(p.id, p);
           }
        }
        
        return products;
      } else {
         // If server fails, try to return from cache if applicable
         if (categoryId == null && query == null) {
           return _productsBox.values.toList();
         }
         throw Failure(
            message: "خطأ في الخادم: ${response.statusCode}",
            type: FailureType.server,
         );
      }
    } catch (e) {
      print("DEBUG: Error in getProducts: $e");
      
      // On network error, return cached products
      if (e is http.ClientException || e.toString().contains('SocketException')) {
         if (_productsBox.isNotEmpty) {
           print('DEBUG: Returning products from cache due to network error');
           return _productsBox.values.toList();
         }
        throw Failure(
          message: "تعذر الوصول إلى الخادم. تأكد من تشغيل السيرفر وعنوان الـ IP", 
          type: FailureType.network, 
          originalError: e
        );
      }
      
      if (e is Failure) rethrow;
      throw Failure(message: "حدث خطأ غير متوقع: $e", type: FailureType.unknown, originalError: e);
    }
  }

  Future<ProductModel> getProductById(String id) async {
    try {
      // Check cache first
      if (_productsBox.containsKey(id)) {
        print('DEBUG: Returning product $id from cache');
        return _productsBox.get(id)!;
      }

      final uri = Uri.parse('$_productBaseUrl/$id');
      print('DEBUG: Fetching product from $uri');
      final response = await http.get(uri);
      
      if (response.statusCode == 200) {
        final decodedData = jsonDecode(response.body);
        final product = ProductModel.fromJson(decodedData);
        // Save to cache
        await _productsBox.put(product.id, product);
        return product;
      } else {
        throw Failure(message: "المنتج غير موجود", type: FailureType.server);
      }
    } catch (e) {
      print("DEBUG: Error in getProductById: $e");
      
      // Fallback to cache on network error
      if (e is http.ClientException || e.toString().contains('SocketException')) {
        if (_productsBox.containsKey(id)) {
          return _productsBox.get(id)!;
        }
      }

      if (e is Failure) rethrow;
      throw Failure(message: "فشل في تحميل المنتج", type: FailureType.unknown, originalError: e);
    }
  }
}



