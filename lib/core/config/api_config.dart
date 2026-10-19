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

  // Reviews (Public & Customer)
  static String productReviews(String productId) => '/shop/products/$productId/reviews';
  static String submitReview(String productId) => '/customer/products/$productId/reviews';
  static String userProductReview(String productId) => '/customer/products/$productId/user-review';
  static String deleteReview(String reviewId) => '/customer/reviews/$reviewId';

  // Customer (Protected)
  static const String customerProfile = '/customer/profile';
  static const String cart = '/customer/cart';
  static const String orders = '/customer/orders';
  static String payOrder(dynamic orderId) => '/customer/orders/$orderId/pay';
  static const String fcmToken = '/customer/fcm-token';

  // Notifications (Customer Protected)
  static const String customerNotifications = '/customer/notifications';
  static const String customerNotificationsUnreadCount = '/customer/notifications/unread-count';
  static String markNotificationAsRead(dynamic id) => '/customer/notifications/$id/read';
  static const String markAllNotificationsAsRead = '/customer/notifications/read-all';

  // Support & Complaints
  static const String customerSupportTickets = '/customer/support/tickets';
  static const String publicSupportTicket = '/shop/support/tickets';
  static String customerSupportTicketDetails(dynamic id) => '/customer/support/tickets/$id';
  static String customerSupportTicketMessages(dynamic id) => '/customer/support/tickets/$id/messages';
  static String customerCloseSupportTicket(dynamic id) => '/customer/support/tickets/$id/close';

  // Legacy/Deprecated - Keep for compatibility until services are updated
  static const String usersStats = '/customer/profile';
}
