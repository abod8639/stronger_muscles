import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/features/promo/data/models/promo_model.dart';
import 'package:stronger_muscles/features/promo/domain/entities/promo_entity.dart';

void main() {
  group('PromoModel Tests', () {
    test('backgroundColor parses hex string with hash symbol', () {
      const promo = PromoModel(
        id: 1,
        imageUrl: 'https://example.com/banner.png',
        buttonText: 'Shop',
        hexBackgroundColor: '#FF5733',
        targetType: 'category',
      );

      expect(promo.backgroundColor, const Color(0xFFFF5733));
    });

    test('backgroundColor parses hex string without hash symbol', () {
      const promo = PromoModel(
        id: 2,
        imageUrl: 'https://example.com/banner2.png',
        buttonText: 'Shop',
        hexBackgroundColor: '00AAFF',
        targetType: 'none',
      );

      expect(promo.backgroundColor, const Color(0xFF00AAFF));
    });

    test('backgroundColor falls back to Colors.white on invalid hex', () {
      const promo = PromoModel(
        id: 3,
        imageUrl: 'https://example.com/banner3.png',
        buttonText: 'Shop',
        hexBackgroundColor: 'invalid-hex-code',
        targetType: 'none',
      );

      expect(promo.backgroundColor, Colors.white);
    });

    test('fromJson applies default values when optional attributes omitted', () {
      final json = {
        'id': 10,
        'image_url': 'https://example.com/image.jpg',
      };

      final promo = PromoModel.fromJson(json);

      expect(promo.id, 10);
      expect(promo.imageUrl, 'https://example.com/image.jpg');
      expect(promo.buttonText, 'عرض الآن');
      expect(promo.hexBackgroundColor, '#FFFFFF');
      expect(promo.targetType, 'none');
      expect(promo.backgroundColor, const Color(0xFFFFFFFF));
    });

    test('toEntity converts PromoModel to PromoEntity accurately', () {
      const model = PromoModel(
        id: 5,
        title: 'Special Sale',
        subtitle: 'Up to 50% off',
        imageUrl: 'https://example.com/banner5.png',
        buttonText: 'Buy',
        hexBackgroundColor: '#123456',
        targetType: 'product',
        targetId: 'prod_99',
      );

      final entity = model.toEntity();

      expect(entity.id, 5);
      expect(entity.title, 'Special Sale');
      expect(entity.subtitle, 'Up to 50% off');
      expect(entity.imageUrl, 'https://example.com/banner5.png');
      expect(entity.buttonText, 'Buy');
      expect(entity.hexBackgroundColor, '#123456');
      expect(entity.targetType, 'product');
      expect(entity.targetId, 'prod_99');
      expect(entity.backgroundColor, const Color(0xFF123456));
    });

    test('fromEntity converts PromoEntity to PromoModel accurately', () {
      final entity = modelToEntity();

      final model = PromoModel.fromEntity(entity);

      expect(model.id, entity.id);
      expect(model.title, entity.title);
      expect(model.subtitle, entity.subtitle);
      expect(model.imageUrl, entity.imageUrl);
      expect(model.buttonText, entity.buttonText);
      expect(model.hexBackgroundColor, entity.hexBackgroundColor);
      expect(model.targetType, entity.targetType);
      expect(model.targetId, entity.targetId);
    });
  });
}

PromoEntity modelToEntity() {
  return const PromoEntity(
    id: 8,
    title: 'Protein Boost',
    subtitle: 'Extra 20%',
    imageUrl: 'https://example.com/banner8.png',
    buttonText: 'Order',
    hexBackgroundColor: '#AABBCC',
    targetType: 'brand',
    targetId: 'brand_optimum',
  );
}
