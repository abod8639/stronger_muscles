import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/features/product/data/models/category_model.dart';
import 'package:stronger_muscles/features/product/data/models/review_model.dart';
import 'package:stronger_muscles/features/profile/data/models/localized_string_model.dart';

void main() {
  group('CategoryModel Tests', () {
    const category = CategoryModel(
      id: 'cat-1',
      name: LocalizedString(ar: 'فيتامينات', en: 'Vitamins'),
      description: LocalizedString(
        ar: 'مكملات الفيتامينات والمعادن',
        en: 'Vitamin and mineral supplements',
      ),
      sortOrder: 1,
      isActive: true,
    );

    test('getLocalizedName and getLocalizedDescription return correct language text', () {
      expect(category.getLocalizedName(locale: 'ar'), 'فيتامينات');
      expect(category.getLocalizedName(locale: 'en'), 'Vitamins');

      expect(
        category.getLocalizedDescription(locale: 'ar'),
        'مكملات الفيتامينات والمعادن',
      );
      expect(
        category.getLocalizedDescription(locale: 'en'),
        'Vitamin and mineral supplements',
      );
    });

    test('returns empty string when name or description is null', () {
      const emptyCat = CategoryModel(id: 'cat-empty');
      expect(emptyCat.getLocalizedName(locale: 'en'), isEmpty);
      expect(emptyCat.getLocalizedDescription(locale: 'ar'), isEmpty);
    });

    test('fromJson deserializes nested structure correctly', () {
      final json = {
        'id': 'cat-2',
        'name': {'ar': 'بروتين', 'en': 'Protein'},
        'sort_order': 2,
        'is_active': true,
      };

      final cat = CategoryModel.fromJson(json);
      expect(cat.id, 'cat-2');
      expect(cat.getLocalizedName(locale: 'en'), 'Protein');
    });
  });

  group('ReviewModel Tests', () {
    test('fromJson converts integer rating to double and sets defaults', () {
      final json = {
        'id': 'rev-1',
        'productId': 'prod-1',
        'userId': 'user-1',
        'userName': 'Dexter',
        'comment': 'Great quality!',
        'rating': 5,
        'isVerifiedPurchase': true,
        'createdAt': '2025-01-10T12:00:00.000Z',
      };

      final review = ReviewModel.fromJson(json);

      expect(review.id, 'rev-1');
      expect(review.userName, 'Dexter');
      expect(review.rating, 5.0);
      expect(review.isVerifiedPurchase, isTrue);
      expect(review.comment, 'Great quality!');
      expect(review.createdAt, DateTime.parse('2025-01-10T12:00:00.000Z'));

      final map = review.toJson();
      expect(map['rating'], 5.0);
      expect(map['comment'], 'Great quality!');
    });
  });
}
