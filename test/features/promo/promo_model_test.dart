import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/features/promo/data/mappers/promo_mapper.dart';
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
      expect(promo.title, isNull);
      expect(promo.subtitle, isNull);
      expect(promo.targetId, isNull);
    });

    test('toJson produces expected map structure', () {
      const promo = PromoModel(
        id: 5,
        title: 'Special Summer',
        subtitle: 'Up to 50% off',
        imageUrl: 'https://example.com/summer.png',
        buttonText: 'Explore',
        hexBackgroundColor: '#112233',
        targetType: 'product',
        targetId: 'prod_99',
      );

      final json = promo.toJson();

      expect(json['id'], 5);
      expect(json['title'], 'Special Summer');
      expect(json['subtitle'], 'Up to 50% off');
      expect(json['image_url'], 'https://example.com/summer.png');
      expect(json['button_text'], 'Explore');
      expect(json['background_color'], '#112233');
      expect(json['target_type'], 'product');
      expect(json['target_id'], 'prod_99');
    });

    test('toEntity converts model to PromoEntity correctly', () {
      const promo = PromoModel(
        id: 7,
        title: 'Flash Sale',
        subtitle: '24 hours only',
        imageUrl: 'https://example.com/flash.png',
        buttonText: 'Grab Now',
        hexBackgroundColor: '#FFAA00',
        targetType: 'category',
        targetId: 'cat_supplements',
      );

      final entity = promo.toEntity();

      expect(entity.id, promo.id);
      expect(entity.title, promo.title);
      expect(entity.subtitle, promo.subtitle);
      expect(entity.imageUrl, promo.imageUrl);
      expect(entity.buttonText, promo.buttonText);
      expect(entity.hexBackgroundColor, promo.hexBackgroundColor);
      expect(entity.targetType, promo.targetType);
      expect(entity.targetId, promo.targetId);
    });

    test('toModel converts PromoEntity to PromoModel correctly', () {
      const entity = PromoEntity(
        id: 8,
        title: 'Protein Boost',
        subtitle: 'Extra 20%',
        imageUrl: 'https://example.com/banner8.png',
        buttonText: 'Order',
        hexBackgroundColor: '#AABBCC',
        targetType: 'brand',
        targetId: 'brand_optimum',
      );

      final model = entity.toModel();

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
