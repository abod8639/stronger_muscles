import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:stronger_muscles/core/config/api_config.dart';
import 'package:stronger_muscles/core/error/error.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/features/home/data/models/selection_model.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';

/// Top-level isolate function for processing raw category JSON data without UI thread jank.
List<SelectionsModel> parseCategoriesIsolate(dynamic data) {
  return SelectionsModel.fromJsonList(data);
}

/// Top-level isolate function for processing raw product JSON list in background isolate.
List<ProductModel> parseProductsIsolate(dynamic data) {
  if (data == null) return const [];

  List<dynamic> list = const [];
  if (data is List) {
    list = data;
  } else if (data is Map) {
    final rawData = data['data'] ?? data['items'] ?? data['products'];
    if (rawData is List) {
      list = rawData;
    } else if (rawData is Map && rawData['data'] is List) {
      list = rawData['data'];
    }
  }

  final results = <ProductModel>[];
  for (final item in list) {
    if (item is Map) {
      try {
        final safeMap = Map<String, dynamic>.from(item);
        results.add(ProductModel.fromJson(safeMap));
      } catch (_) {
        // Drop malformed individual items defensively to avoid payload crash
      }
    }
  }
  return results;
}

/// Remote data source contract for Home feature.
abstract class HomeRemoteDataSource {
  Future<List<SelectionsModel>> getCategories({CancelToken? cancelToken});

  Future<List<ProductModel>> getProducts({
    String? categoryId,
    int page = 1,
    int limit = 20,
    CancelToken? cancelToken,
  });
}

/// Concrete implementation of [HomeRemoteDataSource] with explicit timeouts,
/// background isolate execution, and cancellation handling.
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiService _apiService;
  static const Duration _networkTimeout = Duration(seconds: 15);

  HomeRemoteDataSourceImpl(this._apiService);

  @override
  Future<List<SelectionsModel>> getCategories({CancelToken? cancelToken}) async {
    try {
      final response = await _apiService.get(
        ApiConfig.categories,
        cancelToken: cancelToken,
        timeout: _networkTimeout,
      );

      // Offload JSON decoding and category models mapping to background isolate
      return await compute(parseCategoriesIsolate, response.data);
    } on DioException catch (e, st) {
      throw NetworkErrorHandler.handleDioError(e, st);
    } catch (e, st) {
      if (e is Failure) rethrow;
      throw NetworkErrorHandler.handle(e, st);
    }
  }

  @override
  Future<List<ProductModel>> getProducts({
    String? categoryId,
    int page = 1,
    int limit = 20,
    CancelToken? cancelToken,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'page': page,
        'limit': limit,
      };

      if (categoryId != null && categoryId.isNotEmpty) {
        queryParams['category'] = categoryId;
      }

      final response = await _apiService.get(
        ApiConfig.products,
        queryParameters: queryParams,
        cancelToken: cancelToken,
        timeout: _networkTimeout,
      );

      // Offload heavy products parsing to background isolate to prevent UI freezing
      return await compute(parseProductsIsolate, response.data);
    } on DioException catch (e, st) {
      throw NetworkErrorHandler.handleDioError(e, st);
    } catch (e, st) {
      if (e is Failure) rethrow;
      throw NetworkErrorHandler.handle(e, st);
    }
  }
}
