import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  static String get baseUrl {
    final envUrl = dotenv.env['BASE_URL'];
    if (envUrl != null) {
      return envUrl.endsWith('/api/v1') ? envUrl : '$envUrl/api/v1';
    }
    const String port = '8080';
    const String ip = '192.168.1.17';

    return 'http://$ip:$port/api/v1';
  }

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String googleSignIn = '/auth/google-signin';
  static const String logout = '/auth/logout';
  static const String testLogin = '/auth/test-login';
  static const String updateProfileRoute = '/auth/update-profile';
  static const String addresses = '/customer/addresses';

  // Promos (Public)
  static const String promos = '/shop/promos';

  // Products (Public)
  static const String products = '/shop/products';

  // Categories (Public)
  static const String categories = '/shop/categories';

  // Customer (Protected)
  static const String customerProfile = '/customer/profile';
  static const String cart = '/customer/cart';
  static const String orders = '/customer/orders';
  static String payOrder(dynamic orderId) => '/customer/orders/$orderId/pay';
  static const String fcmToken = '/customer/fcm-token';

  // Legacy/Deprecated - Keep for compatibility until services are updated
  static const String usersStats = '/customer/profile';
}
