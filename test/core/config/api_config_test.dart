import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/core/config/api_config.dart';

void main() {
  group('ApiConfig Tests', () {
    test('routes constants are properly defined', () {
      expect(ApiConfig.login, '/auth/login');
      expect(ApiConfig.register, '/auth/register');
      expect(ApiConfig.googleSignIn, '/auth/google-signin');
      expect(ApiConfig.logout, '/auth/logout');
      expect(ApiConfig.updateProfileRoute, '/auth/update-profile');
      expect(ApiConfig.addresses, '/customer/addresses');
      expect(ApiConfig.promos, '/shop/promos');
      expect(ApiConfig.products, '/shop/products');
      expect(ApiConfig.categories, '/shop/categories');
      expect(ApiConfig.customerProfile, '/customer/profile');
      expect(ApiConfig.cart, '/customer/cart');
      expect(ApiConfig.orders, '/customer/orders');
      expect(ApiConfig.payOrder(12), '/customer/orders/12/pay');
      expect(ApiConfig.fcmToken, '/customer/fcm-token');
    });

    test('baseUrl returns default IP/port when dotenv is not set or empty', () {
      dotenv.loadFromString(envString: '', isOptional: true);
      expect(ApiConfig.baseUrl, 'http://192.168.1.17:8080/api/v1');
    });

    test('baseUrl appends /api/v1 if not already present in BASE_URL', () {
      dotenv.loadFromString(envString: 'BASE_URL=https://api.strongermuscles.com');
      expect(ApiConfig.baseUrl, 'https://api.strongermuscles.com/api/v1');
    });

    test('baseUrl preserves /api/v1 when already present in BASE_URL', () {
      dotenv.loadFromString(envString: 'BASE_URL=https://api.strongermuscles.com/api/v1');
      expect(ApiConfig.baseUrl, 'https://api.strongermuscles.com/api/v1');
    });
  });
}
