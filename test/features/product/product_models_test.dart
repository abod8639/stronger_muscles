import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/features/product/data/models/image_url_model.dart';
import 'package:stronger_muscles/features/product/data/models/product_category_model.dart';
import 'package:stronger_muscles/features/product/data/models/product_size_model.dart';
import 'package:stronger_muscles/features/profile/data/models/localized_string_model.dart';

void main() {
  group('ProductSize Tests', () {
    test('effectivePrice and hasDiscount return correct values', () {
      const sizeWithDiscount = ProductSize(
        size: '1kg',
        price: 100.0,
        discountPrice: 80.0,
      );

      expect(sizeWithDiscount.effectivePrice, 80.0);
      expect(sizeWithDiscount.hasDiscount, isTrue);
      expect(sizeWithDiscount.discountPercentage, 20.0);

      const sizeNoDiscount = ProductSize(
        size: '2kg',
        price: 180.0,
      );

      expect(sizeNoDiscount.effectivePrice, 180.0);
      expect(sizeNoDiscount.hasDiscount, isFalse);
      expect(sizeNoDiscount.discountPercentage, 0.0);
    });

    test('fromJson and toJson maintain ProductSize integrity', () {
      final json = {
        'size': '5lb',
        'price': 250.0,
        'discount_price': 200.0,
      };

      final size = ProductSize.fromJson(json);
      expect(size.size, '5lb');
      expect(size.price, 250.0);
      expect(size.discountPrice, 200.0);

      final serialized = size.toJson();
      expect(serialized['size'], '5lb');
      expect(serialized['price'], 250.0);
      expect(serialized['discount_price'], 200.0);
    });
  });

  group('ImageUrl Tests', () {
    test('fromJson and toJson map thumbnail, medium, and original correctly', () {
      final json = {
        'thumbnail': 'https://example.com/thumb.jpg',
        'medium': 'https://example.com/med.jpg',
        'original': 'https://example.com/orig.jpg',
      };

      final image = ImageUrl.fromJson(json);
      expect(image.thumbnail, 'https://example.com/thumb.jpg');
      expect(image.medium, 'https://example.com/med.jpg');
      expect(image.original, 'https://example.com/orig.jpg');

      final serialized = image.toJson();
      expect(serialized['thumbnail'], 'https://example.com/thumb.jpg');
      expect(serialized['medium'], 'https://example.com/med.jpg');
      expect(serialized['original'], 'https://example.com/orig.jpg');
    });
  });

  group('ProductCategory Tests', () {
    test('getLocalizedName returns translated name or empty string', () {
      const category = ProductCategory(
        id: 'cat-supplements',
        name: LocalizedString(ar: 'مكملات', en: 'Supplements'),
      );

      expect(category.getLocalizedName(locale: 'ar'), 'مكملات');
      expect(category.getLocalizedName(locale: 'en'), 'Supplements');

      const categoryNullName = ProductCategory(id: 'cat-empty');
      expect(categoryNullName.getLocalizedName(), isEmpty);
    });
  });
}
