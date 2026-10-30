import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:stronger_muscles/core/config/api_config.dart';
import 'package:stronger_muscles/core/errors/errors.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/features/cart/data/models/cart_item_model.dart';

/// Contract for remote cart network operations via Dio.
abstract class CartRemoteDataSource {
  Future<List<CartItemModel>> getCartItems({CancelToken? cancelToken});

  Future<void> addToCart({
    required String productId,
    String? selectedFlavor,
    String? selectedSize,
    int quantity = 1,
    CancelToken? cancelToken,
  });

  Future<void> removeFromCart(String itemId, {CancelToken? cancelToken});

  Future<void> updateQuantity(
    String itemId,
    int quantity, {
    CancelToken? cancelToken,
  });

  Future<void> clearCart({CancelToken? cancelToken});
}

/// Concrete implementation of [CartRemoteDataSource] using [ApiService] and Dio.
class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final ApiService _apiService;

  CartRemoteDataSourceImpl(this._apiService);

  @override
  Future<List<CartItemModel>> getCartItems({CancelToken? cancelToken}) async {
    try {
      final response = await _apiService.get(
        ApiConfig.cart,
        cancelToken: cancelToken,
      );

      return await compute(parseCartItemsList, response.data);
    } on DioException catch (e) {
      throw NetworkErrorHandler.handle(e);
    } catch (e) {
      if (e is Failure) rethrow;
      throw ParsingException(
        message: 'فشل في قراءة بيانات السلة من الخادم',
        originalError: e,
      );
    }
  }

  @override
  Future<void> addToCart({
    required String productId,
    String? selectedFlavor,
    String? selectedSize,
    int quantity = 1,
    CancelToken? cancelToken,
  }) async {
    try {
      await _apiService.post(
        ApiConfig.cart,
        data: {
          'product_id': productId,
          'quantity': quantity,
          if (selectedFlavor != null) ...{
            'flavor': selectedFlavor,
            'selected_flavor': selectedFlavor,
          },
          if (selectedSize != null) ...{
            'size': selectedSize,
            'selected_size': selectedSize,
          },
        },
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw NetworkErrorHandler.handle(e);
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerException(
        message: 'فشل في إضافة العنصر إلى السلة على الخادم',
        data: e,
      );
    }
  }

  @override
  Future<void> removeFromCart(String itemId, {CancelToken? cancelToken}) async {
    try {
      await _apiService.delete(
        '${ApiConfig.cart}/$itemId',
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw NetworkErrorHandler.handle(e);
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerException(
        message: 'فشل في حذف العنصر من الخادم',
        data: e,
      );
    }
  }

  @override
  Future<void> updateQuantity(
    String itemId,
    int quantity, {
    CancelToken? cancelToken,
  }) async {
    try {
      await _apiService.put(
        '${ApiConfig.cart}/$itemId',
        data: {'quantity': quantity},
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw NetworkErrorHandler.handle(e);
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerException(
        message: 'فشل في تحديث كمية العنصر على الخادم',
        data: e,
      );
    }
  }

  @override
  Future<void> clearCart({CancelToken? cancelToken}) async {
    try {
      await _apiService.delete(
        ApiConfig.cart,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw NetworkErrorHandler.handle(e);
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerException(
        message: 'فشل في تفريغ السلة على الخادم',
        data: e,
      );
    }
  }
}
