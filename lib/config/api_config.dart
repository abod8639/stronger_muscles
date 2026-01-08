
class ApiConfig {
  // Set this to true if using Android Emulator, false for Physical Device
  // static const bool useEmulator = false;

  static String get baseUrl {
    // For Web testing, we use localhost directly.
    // Note: 'dart:io' imports cause crashes on Web, so we removed Platform logic for this specific test.
    // return 'http://localhost:8080';
    return 'http://192.168.1.17:8080'; // Change to your PC's IP
    // return 'http://10.0.2.2:8080'; // Change to your PC's IP

  }

  // Auth
  static const String register = '/api/v1/auth/register';
  static const String login = '/api/v1/auth/login';
  static const String googleSignIn = '/api/v1/auth/google-signin';
  static const String me = '/api/v1/auth/me';
  static const String updateProfile = '/api/v1/auth/update-profile';

  // Products
  static const String products = '/api/v1/products';
  
  // Orders
  static const String orders = '/api/v1/orders';
  
  // Cart
  static const String cart = '/api/v1/cart';

  // Categories
  static const String categories = '/api/v1/categories';
  
  // Addresses
  static const String addresses = '/api/v1/addresses';
  
  // Dashboard
  static const String usersStats = '/api/v1/dashboard/users-stats';
  
}
