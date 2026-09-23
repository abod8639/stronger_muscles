import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/features/profile/data/models/address_model.dart';
import 'package:stronger_muscles/features/profile/data/models/user_model.dart';

void main() {
  group('AddressModel Tests', () {
    test('fullAddress joins present fields with comma and skips empty or null', () {
      const fullAddr = AddressModel(
        id: 1,
        street: 'King Fahd Rd',
        city: 'Riyadh',
        state: 'Riyadh Province',
        postalCode: '12345',
        country: 'Saudi Arabia',
      );
      expect(
        fullAddr.fullAddress,
        'King Fahd Rd, Riyadh, Riyadh Province, 12345, Saudi Arabia',
      );

      const partialAddr = AddressModel(
        id: 2,
        street: 'Main Street',
        city: 'Jeddah',
        state: '',
        postalCode: null,
        country: 'Saudi Arabia',
      );
      expect(partialAddr.fullAddress, 'Main Street, Jeddah, Saudi Arabia');
    });

    test('shortAddress returns city and country', () {
      const addr = AddressModel(
        id: 1,
        street: 'Street 10',
        city: 'Dammam',
        country: 'Saudi Arabia',
      );
      expect(addr.shortAddress, 'Dammam, Saudi Arabia');
    });

    test('hasCoordinates returns true only when both lat and long exist', () {
      const withBoth = AddressModel(
        id: 1,
        street: 'Street',
        city: 'City',
        latitude: 24.7136,
        longitude: 46.6753,
      );
      expect(withBoth.hasCoordinates, isTrue);

      const withLatOnly = AddressModel(
        id: 2,
        street: 'Street',
        city: 'City',
        latitude: 24.7136,
      );
      expect(withLatOnly.hasCoordinates, isFalse);

      const withNone = AddressModel(id: 3, street: 'Street', city: 'City');
      expect(withNone.hasCoordinates, isFalse);
    });

    test('fromJson handles string IDs and integers seamlessly', () {
      final json = {
        'id': '45',
        'user_id': '10',
        'street': 'Olaya St',
        'city': 'Riyadh',
        'is_default': true,
      };

      final addr = AddressModel.fromJson(json);
      expect(addr.id, 45);
      expect(addr.userId, 10);
      expect(addr.isDefault, isTrue);
    });
  });

  group('UserModel Tests', () {
    test('fromJson parses boolean and integer flags correctly', () {
      final jsonWithNumbers = {
        'id': '12',
        'email': 'user@example.com',
        'name': 'Ahmed Ali',
        'notifications_enabled': 1,
        'is_active': 0,
      };

      final user1 = UserModel.fromJson(jsonWithNumbers);
      expect(user1.id, 12);
      expect(user1.notificationsEnabled, isTrue);
      expect(user1.isActive, isFalse);

      final jsonWithStrings = {
        'id': 14,
        'email': 'user2@example.com',
        'name': 'Sara',
        'notifications_enabled': 'true',
        'is_active': '1',
      };

      final user2 = UserModel.fromJson(jsonWithStrings);
      expect(user2.id, 14);
      expect(user2.notificationsEnabled, isTrue);
      expect(user2.isActive, isTrue);
    });

    test('fromJson parses nested addresses list', () {
      final json = {
        'id': 1,
        'email': 'test@test.com',
        'name': 'Test User',
        'addresses': [
          {
            'id': 100,
            'street': 'Street A',
            'city': 'Riyadh',
            'is_default': true,
          }
        ],
      };

      final user = UserModel.fromJson(json);
      expect(user.addresses, isNotNull);
      expect(user.addresses!.length, 1);
      expect(user.addresses!.first.street, 'Street A');
      expect(user.addresses!.first.isDefault, isTrue);
    });
  });
}
