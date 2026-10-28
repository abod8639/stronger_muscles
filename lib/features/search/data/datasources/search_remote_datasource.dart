import 'package:stronger_muscles/core/config/api_config.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';

/// Contract for remote search queries via HTTP/Dio.
abstract class SearchRemoteDataSource {
  Future<List<ProductModel>> searchProducts(String query);
}

/// Remote data source implementation using Dio via [ApiService].
class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final ApiService _apiService;

  SearchRemoteDataSourceImpl(this._apiService);

  @override
  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      final response = await _apiService.get(
        ApiConfig.products,
        queryParameters: {
          'search': query,
          'limit': 50,
        },
      );

      final data = response.data;
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

      return list
          .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      if (e is Failure) rethrow;
      throw const Failure(
        message: 'تعذر جلب نتائج البحث من الخادم',
        type: FailureType.unknown,
      );
    }
  }
}
