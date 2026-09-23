import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/features/home/data/models/selection_model.dart';
import 'package:stronger_muscles/features/profile/data/models/localized_string_model.dart';
import 'package:stronger_muscles/features/profile/data/models/user_stats_model.dart';

void main() {
  group('LocalizedString Tests', () {
    test('getValue returns requested locale or falls back properly', () {
      const dualLang = LocalizedString(ar: 'مرحبا', en: 'Hello');
      expect(dualLang.getValue(locale: 'ar'), 'مرحبا');
      expect(dualLang.getValue(locale: 'en'), 'Hello');

      const arabicOnly = LocalizedString(ar: 'عربي فقط', en: null);
      expect(arabicOnly.getValue(locale: 'ar'), 'عربي فقط');
      expect(arabicOnly.getValue(locale: 'en'), 'عربي فقط');

      const englishOnly = LocalizedString(ar: null, en: 'English Only');
      expect(englishOnly.getValue(locale: 'ar'), 'English Only');
      expect(englishOnly.getValue(locale: 'en'), 'English Only');

      const empty = LocalizedString();
      expect(empty.getValue(locale: 'ar'), isEmpty);
      expect(empty.getValue(locale: 'en'), isEmpty);
    });
  });

  group('UserStats and Response Tests', () {
    test('fromJson deserializes UserStats and nested orders correctly', () {
      final json = {
        'id': 7,
        'name': 'Dexter Dev',
        'photo_url': 'https://example.com/avatar.jpg',
        'has_ordered': true,
        'orders_count': 1,
        'orders': [
          {
            'id': 'ord-777',
            'user_id': '7',
            'address_id': 'addr-1',
            'subtotal': 150.0,
            'total_amount': 150.0,
            'status': 'delivered',
          }
        ],
      };

      final stats = UserStats.fromJson(json);
      expect(stats.id, 7);
      expect(stats.name, 'Dexter Dev');
      expect(stats.hasOrdered, isTrue);
      expect(stats.ordersCount, 1);
      expect(stats.orders.length, 1);
      expect(stats.orders.first.id, 'ord-777');
    });

    test('UsersStatsResponse parses total users count and user list', () {
      final json = {
        'total_users': 1,
        'users': [
          {
            'id': 1,
            'name': 'User A',
            'has_ordered': false,
            'orders_count': 0,
            'orders': [],
          }
        ],
      };

      final response = UsersStatsResponse.fromJson(json);
      expect(response.totalUsers, 1);
      expect(response.users.length, 1);
      expect(response.users.first.name, 'User A');
    });
  });

  group('SelectionsModel Tests', () {
    test('initializes with label, icon, and id', () {
      final selection = SelectionsModel(
        label: 'Categories',
        icon: Icons.category,
        id: 'cat_sel',
      );

      expect(selection.label, 'Categories');
      expect(selection.icon, Icons.category);
      expect(selection.id, 'cat_sel');
    });
  });
}
