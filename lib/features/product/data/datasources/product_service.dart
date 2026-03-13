import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import '../../../../core/config/api_config.dart';
import '../../../../core/errors/failures.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';

part 'product_service.g.dart';

@Riverpod(keepAlive: true)
ProductService productService(ProductServiceRef ref) {
  return ProductService(ref.watch(apiServiceProvider));
}

class ProductService {
  final ApiService _apiService;

  ProductService(this._apiService);

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
          'page': page,
          'limit': limit,
        },
      );

      return _parseProductsList(response.data);
    } catch (e) {
      throw _handleError(e, "حدث خطأ عند جلب المنتجات");
    }
  }

  Future<ProductModel> getProductDetails(String id) async {
    try {
      final response = await _apiService.get('${ApiConfig.products}/$id');
      final data = response.data;

      final productData = (data is Map && data['data'] != null)
          ? data['data']
          : data;

      return ProductModel.fromJson(productData);
    } catch (e) {
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
