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

    test('copyWith updates specified fields and preserves others', () {
      const original = PromoEntity(
        id: 1,
        title: 'Original Title',
        subtitle: 'Original Subtitle',
        imageUrl: 'https://example.com/img.png',
        buttonText: 'Shop',
        hexBackgroundColor: '#112233',
        targetType: 'product',
        targetId: '99',
      );

      final updated = original.copyWith(
        title: 'New Title',
        targetId: '100',
      );

      expect(updated.id, 1);
      expect(updated.title, 'New Title');
      expect(updated.subtitle, 'Original Subtitle');
      expect(updated.imageUrl, 'https://example.com/img.png');
      expect(updated.buttonText, 'Shop');
      expect(updated.hexBackgroundColor, '#112233');
      expect(updated.targetType, 'product');
      expect(updated.targetId, '100');
    });

    test('toString includes key identifying fields', () {
      const entity = PromoEntity(
        id: 42,
        title: 'Special Promo',
        imageUrl: 'https://example.com/promo.png',
        targetType: 'brand',
        targetId: 'Optimum',
      );

      expect(entity.toString(), contains('42'));
      expect(entity.toString(), contains('Special Promo'));
      expect(entity.toString(), contains('brand'));
      expect(entity.toString(), contains('Optimum'));
    });
  });
}
