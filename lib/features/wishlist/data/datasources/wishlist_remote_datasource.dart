import 'package:dio/dio.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/features/wishlist/data/models/wishlist_item_model.dart';

/// Contract for remote wishlist operations via Dio.
abstract class WishlistRemoteDataSource {
  /// Fetches remote wishlist items for the authenticated customer.
  Future<List<WishlistItemModel>> getWishlist();

  /// Adds a product to the remote wishlist.
  Future<void> addToWishlist(String productId);

  /// Removes a product from the remote wishlist.
  Future<void> removeFromWishlist(String productId);
}

/// Remote data source implementation utilizing [ApiService].
class WishlistRemoteDataSourceImpl implements WishlistRemoteDataSource {
  final ApiService _apiService;

  static const String _wishlistEndpoint = '/customer/wishlist';

  WishlistRemoteDataSourceImpl(this._apiService);

  @override
  Future<List<WishlistItemModel>> getWishlist() async {
    try {
      final response = await _apiService.get(_wishlistEndpoint);
      final data = response.data;

      List<dynamic> list = [];
      if (data is List) {
        list = data;
      } else if (data is Map && data['data'] != null) {
        final dynamic nested = data['data'];
        if (nested is List) {
          list = nested;
        }
      }

      return list
          .whereType<Map<String, dynamic>>()
          .map((json) => WishlistItemModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      // 404 or unimplemented remote endpoint gracefully resolves to empty list
      if (e.response?.statusCode == 404) {
        return [];
      }
      rethrow;
    } catch (e) {
      if (e is Failure) rethrow;
      throw const Failure(
        message: 'تعذر مزامنة قائمة الرغبات مع الخادم',
        type: FailureType.unknown,
      );
    }
  }

  @override
  Future<void> addToWishlist(String productId) async {
    try {
      await _apiService.post(
        _wishlistEndpoint,
        data: {'product_id': productId},
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return;
      rethrow;
    }
  }

  @override
  Future<void> removeFromWishlist(String productId) async {
    try {
      await _apiService.delete('$_wishlistEndpoint/$productId');
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return;
      rethrow;
    }
  }
}
