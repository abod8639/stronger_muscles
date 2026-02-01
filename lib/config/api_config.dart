class ApiConfig {
  static String get baseUrl {
    const String port = '8080';
    const String ip = '192.168.1.17';
    // const String pcIp = 'localhost';

    // استخدم 10.0.2.2 إذا كنت تستخدم محاكي أندرويد (Android Emulator)
    // استخدم IP جهازك (مثل 192.168.1.17) إذا كنت تستخدم جوال حقيقي
    // const String pcIp = '192.168.1.17';
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
