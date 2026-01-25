import 'package:stronger_muscles/data/models/review_model.dart';

/// Fake reviews data for testing and demonstration purposes
class FakeReviews {
  static List<ReviewModel> getFakeReviews({String productId = 'default'}) {
    return [
      ReviewModel(
        id: 'review_001',
        productId: productId,
        userId: 'user_001',
        userName: 'Sarah Johnson',
        comment:
            'Absolutely love this product! The quality is outstanding and it has really helped me achieve my fitness goals. Highly recommend to anyone serious about their workout routine.',
        rating: 5.0,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      ReviewModel(
        id: 'review_002',
        productId: productId,
        userId: 'user_002',
        userName: 'Mike Thompson',
        comment:
            'Great product overall. Does exactly what it promises. The only minor issue is the delivery took a bit longer than expected, but the product itself is top-notch.',
        rating: 4.5,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      ReviewModel(
        id: 'review_003',
        productId: productId,
        userId: 'user_003',
        userName: 'Emily Chen',
        comment:
            'Good quality but a bit pricey. Works well for my needs though. I\'ve been using it for a month now and seeing decent results.',
        rating: 4.0,
        createdAt: DateTime.now().subtract(const Duration(days: 12)),
      ),
      ReviewModel(
        id: 'review_004',
        productId: productId,
        userId: 'user_004',
        userName: 'David Martinez',
        comment:
            'Excellent! This is my third purchase. The durability is impressive and it has become an essential part of my daily workout routine. Worth every penny!',
        rating: 5.0,
        createdAt: DateTime.now().subtract(const Duration(days: 18)),
      ),
      ReviewModel(
        id: 'review_005',
        productId: productId,
        userId: 'user_005',
        userName: 'Jessica Williams',
        comment:
            'Pretty good product. It meets my expectations and the customer service was very helpful when I had questions about usage.',
        rating: 4.0,
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
      ),
      ReviewModel(
        id: 'review_006',
        productId: productId,
        userId: 'user_006',
        userName: 'Alex Brown',
        comment:
            'Fantastic quality! I\'ve tried several similar products and this one stands out. The results speak for themselves. My friends have been asking what I\'m using!',
        rating: 5.0,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      ReviewModel(
        id: 'review_007',
        productId: productId,
        userId: 'user_007',
        userName: 'Rachel Green',
        comment:
            'Decent product but had some issues with the packaging. The item itself works fine once I got it set up properly.',
        rating: 3.5,
        createdAt: DateTime.now().subtract(const Duration(days: 45)),
      ),
      ReviewModel(
        id: 'review_008',
        productId: productId,
        userId: 'user_008',
        userName: 'Tom Anderson',
        comment:
            'Best purchase I\'ve made this year! The quality exceeds expectations and I\'ve already recommended it to my gym buddies. Five stars all the way!',
        rating: 5.0,
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
      ),
      ReviewModel(
        id: 'review_009',
        productId: productId,
        userId: 'user_009',
        userName: 'Lisa Parker',
        comment:
            'Very satisfied with this purchase. It\'s well-made, durable, and exactly as described. Would definitely buy again.',
        rating: 4.5,
        createdAt: DateTime.now().subtract(const Duration(days: 75)),
      ),
      ReviewModel(
        id: 'review_010',
        productId: productId,
        userId: 'user_010',
        userName: 'James Wilson',
        comment:
            'Good value for money. Does the job well and I haven\'t had any issues so far. Solid product overall.',
        rating: 4.0,
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
      ),
      ReviewModel(
        id: 'review_011',
        productId: productId,
        userId: 'user_011',
        userName: 'hosam gogo',
        comment:
            'Good value for money. Does the job well and I haven\'t had any issues so far. Solid product overall.',
        rating: 3.5,
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
      ),
    ];
  }

  /// Get a subset of reviews for testing
  static List<ReviewModel> getTopReviews({
    int count = 5,
    String productId = 'default',
  }) {
    final allReviews = getFakeReviews(productId: productId);
    return allReviews.take(count).toList();
  }

  /// Get reviews filtered by minimum rating
  static List<ReviewModel> getReviewsByRating(
    double minRating, {
    String productId = 'default',
  }) {
    return getFakeReviews(
      productId: productId,
    ).where((review) => review.rating >= minRating).toList();
  }

  /// Calculate average rating
  static double getAverageRating({String productId = 'default'}) {
    final reviews = getFakeReviews(productId: productId);
    if (reviews.isEmpty) return 0.0;

    final totalRating = reviews.fold<double>(
      0.0,
      (sum, review) => sum + review.rating,
    );

    return totalRating / reviews.length;
  }
}
