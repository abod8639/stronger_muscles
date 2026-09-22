import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/product/data/models/product_size_model.dart';
import 'package:stronger_muscles/features/profile/data/models/localized_string_model.dart';

void main() {
  group('ProductModel Helper Tests', () {
    const pWithDiscount = ProductModel(
      id: 'p-1',
      name: LocalizedString(en: 'Protein Powder', ar: 'بودرة بروتين'),
      description: LocalizedString(en: 'High quality whey', ar: 'واي عالي الجودة'),
      price: 200.0,
      discountPrice: 150.0,
    );

    const pWithoutDiscount = ProductModel(
      id: 'p-2',
      name: LocalizedString(en: 'Pre-workout', ar: 'طاقة قبل التمرين'),
      price: 100.0,
    );

    test('getLocalizedName returns correct language or fallback', () {
      expect(pWithDiscount.getLocalizedName(locale: 'en'), 'Protein Powder');
      expect(pWithDiscount.getLocalizedName(locale: 'ar'), 'بودرة بروتين');
    });

    test('hasDiscount and discountPercentage calculate correctly', () {
      expect(pWithDiscount.hasDiscount, true);
      expect(pWithDiscount.discountPercentage, 25); // (200 - 150) / 200 * 100 = 25%
      expect(pWithDiscount.baseEffectivePrice, 150.0);

      expect(pWithoutDiscount.hasDiscount, false);
      expect(pWithoutDiscount.discountPercentage, 0);
      expect(pWithoutDiscount.baseEffectivePrice, 100.0);
    });

    test('getEffectivePriceForSize returns correct variant price', () {
      const pWithSizes = ProductModel(
        id: 'p-3',
        price: 50.0,
        productSizes: [
          ProductSize(size: 'Small', price: 50.0),
          ProductSize(size: 'Large', price: 90.0, discountPrice: 80.0),
        ],
      );

      expect(pWithSizes.getEffectivePriceForSize('Small'), 50.0);
      expect(pWithSizes.getEffectivePriceForSize('Large'), 80.0);
      expect(pWithSizes.getEffectivePriceForSize('NonExistent'), 50.0);
    });
  });
}
