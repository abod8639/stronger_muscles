import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/features/promo/domain/entities/promo_entity.dart';

void main() {
  group('PromoEntity Tests', () {
    test('backgroundColor parses valid hex color string', () {
      const entity = PromoEntity(
        id: 1,
        imageUrl: 'https://example.com/banner.png',
        hexBackgroundColor: '#FF9900',
      );

      expect(entity.backgroundColor, const Color(0xFFFF9900));
    });

    test('backgroundColor falls back to white on malformed hex', () {
      const entity = PromoEntity(
        id: 2,
        imageUrl: 'https://example.com/banner.png',
        hexBackgroundColor: 'not-a-color',
      );

      expect(entity.backgroundColor, const Color(0xFFFFFFFF));
    });

    test('value equality works as expected', () {
      const entity1 = PromoEntity(
        id: 1,
        title: 'Title',
        imageUrl: 'https://example.com/banner.png',
        buttonText: 'Click',
        targetType: 'none',
      );

      const entity2 = PromoEntity(
        id: 1,
        title: 'Title',
        imageUrl: 'https://example.com/banner.png',
        buttonText: 'Click',
        targetType: 'none',
      );

      expect(entity1, equals(entity2));
      expect(entity1.hashCode, equals(entity2.hashCode));
    });

    test('different attributes produce unequal entities', () {
      const entity1 = PromoEntity(
        id: 1,
        imageUrl: 'https://example.com/banner1.png',
      );

      const entity2 = PromoEntity(
        id: 2,
        imageUrl: 'https://example.com/banner2.png',
      );

      expect(entity1, isNot(equals(entity2)));
    });
  });
}
