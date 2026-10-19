import 'package:stronger_muscles/core/config/api_config.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/features/product/data/models/review_model.dart';

class ReviewRemoteDataSource {
  final ApiService _apiService;

  ReviewRemoteDataSource(this._apiService);

  /// Fetch paginated reviews for a specific product.
  Future<List<ReviewModel>> getProductReviews(
    String productId, {
    int page = 1,
  }) async {
    final response = await _apiService.get(
      ApiConfig.productReviews(productId),
      queryParameters: {'page': page},
      includeAuth: false,
    );

    final raw = response.data;
    List<dynamic> list = [];

    if (raw is Map) {
      if (raw['data'] is Map && raw['data']['data'] is List) {
        list = raw['data']['data'] as List<dynamic>;
      } else if (raw['data'] is List) {
        list = raw['data'] as List<dynamic>;
      }
    } else if (raw is List) {
      list = raw;
    }

    return list
        .whereType<Map<String, dynamic>>()
        .map((json) => ReviewModel.fromJson(json))
        .toList();
  }

  /// Fetch user's review for a product if logged in.
  Future<ReviewModel?> getUserProductReview(String productId) async {
    try {
      final response = await _apiService.get(
        ApiConfig.userProductReview(productId),
      );

      final raw = response.data;
      if (raw is Map && raw['data'] != null && raw['data'] is Map<String, dynamic>) {
        return ReviewModel.fromJson(raw['data'] as Map<String, dynamic>);
      }
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Submit or update review for a product.
  Future<ReviewModel> submitReview({
    required String productId,
    required double rating,
    required String comment,
  }) async {
    final response = await _apiService.post(
      ApiConfig.submitReview(productId),
      data: {
        'rating': rating,
        'comment': comment,
      },
    );

    final raw = response.data;
    final itemData = (raw is Map && raw['data'] != null) ? raw['data'] : raw;

    return ReviewModel.fromJson(itemData as Map<String, dynamic>);
  }

  /// Delete a review.
  Future<void> deleteReview(String reviewId) async {
    await _apiService.delete(ApiConfig.deleteReview(reviewId));
  }
}
