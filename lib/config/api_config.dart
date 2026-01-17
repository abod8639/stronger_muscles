
class ApiConfig {
  // Set this to true if using Android Emulator, false for Physical Device
  // static const bool useEmulator = false;

  static String get baseUrl {
    // For Web testing, we use localhost directly.
    // Note: 'dart:io' imports cause crashes on Web, so we removed Platform logic for this specific test.
    // return 'http://localhost:8080';
    return 'http://192.168.1.17:8080/api/v1'; // Change to your PC's IP
    // return 'http://10.0.2.2:8080'; // Change to your PC's IP

  }

  // Auth
  static const String login = '/auth/login';
  static const String googleSignIn = '/auth/google-signin';
  static const String updateProfileRoute = '/auth/update-profile';

  // Products (Public)
  static const String products = '/shop/products';
  // Categories (Public)
  static const String categories = '/shop/categories';
  
  // Customer (Protected)
  static const String customerProfile = '/customer/profile';
  static const String cart = '/customer/cart';
  static const String orders = '/customer/orders';
  

  // Legacy/Deprecated - Keep for compatibility until services are updated
  static const String usersStats = '/customer/profile'; 
}
