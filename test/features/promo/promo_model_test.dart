import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/features/promo/data/models/promo_model.dart';

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
  });
}
