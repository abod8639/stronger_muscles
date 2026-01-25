import 'dart:convert';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import '../../config/api_config.dart';
import '../../data/models/product_model.dart';
import '../errors/failures.dart';

class ProductService extends GetxService {
  final ApiService _apiService = Get.put(ApiService());

  Box<ProductModel> get _productsBox => Hive.box<ProductModel>('products');

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
          if (categoryId != null) 'category': categoryId,
          if (query != null) 'search': query,
          'page': page.toString(),
          'limit': limit.toString(),
        },
      );

      print('DEBUG: Response status: ${response.statusCode}');

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
          products = innerList
              .map((json) => ProductModel.fromJson(json))
              .toList();
        } else if (decodedData['status'] == 'success' &&
            decodedData['data'] != null) {
          // Handle dynamic structure from backend if wrapped in success/data
          final list = decodedData['data'];
          if (list is List) {
            products = list.map((json) => ProductModel.fromJson(json)).toList();
          }
        }
      }

      // Cache products if it's the first page and no search/category filter (or customize as needed)
      if (products.isNotEmpty) {
        for (var p in products) {
          await _productsBox.put(p.id, p);
        }
      }

      return products;
    } on Failure catch (e) {
      print("DEBUG: Failure in getProducts: ${e.message}");
      // If it's a network error, try to return from cache
      if (e.type == FailureType.network &&
          categoryId == null &&
          query == null) {
        if (_productsBox.isNotEmpty) {
          print('DEBUG: Returning products from cache due to network error');
          return _productsBox.values.toList();
        }
      }
      rethrow;
    } catch (e) {
      print("DEBUG: Error in getProducts: $e");
      throw Failure(
        message: "حدث خطأ غير متوقع عند جلب المنتجات",
        type: FailureType.unknown,
        originalError: e,
      );
    }
  }

  Future<ProductModel> getProductById(String id) async {
    try {
      // Check cache first
      if (_productsBox.containsKey(id)) {
        print('DEBUG: Returning product $id from cache');
        return _productsBox.get(id)!;
      }

      final response = await _apiService.get('${ApiConfig.products}/$id');

      final decodedData = jsonDecode(response.body);

      // Handle response structure (check for 'data' wrap if present)
      final productData = (decodedData is Map && decodedData['data'] != null)
          ? decodedData['data']
          : decodedData;

      final product = ProductModel.fromJson(productData);

      // Save to cache
      await _productsBox.put(product.id, product);
      return product;
    } on Failure catch (e) {
      print("DEBUG: Failure in getProductById: ${e.message}");
      // Fallback to cache for details too if network fails
      if (e.type == FailureType.network && _productsBox.containsKey(id)) {
        return _productsBox.get(id)!;
      }
      rethrow;
    } catch (e) {
      print("DEBUG: Error in getProductById: $e");
      throw Failure(
        message: "فشل في تحميل تفاصيل المنتج",
        type: FailureType.unknown,
        originalError: e,
      );
    }
  }
}
