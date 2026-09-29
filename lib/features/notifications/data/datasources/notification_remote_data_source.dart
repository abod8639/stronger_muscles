import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/config/api_config.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import '../models/notification_model.dart';

final notificationRemoteDataSourceProvider = Provider<NotificationRemoteDataSource>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return NotificationRemoteDataSourceImpl(apiService);
});

abstract class NotificationRemoteDataSource {
  Future<Map<String, dynamic>> getNotifications({int page = 1, int perPage = 20});
  Future<int> getUnreadCount();
  Future<void> markAsRead(String id);
  Future<void> markAllAsRead();
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final ApiService _apiService;

  NotificationRemoteDataSourceImpl(this._apiService);

  @override
  Future<Map<String, dynamic>> getNotifications({int page = 1, int perPage = 20}) async {
    try {
      final response = await _apiService.get(
        ApiConfig.customerNotifications,
        queryParameters: {'page': page, 'per_page': perPage},
      );

      final data = response.data;
      List<dynamic> items = [];
      if (data is Map && data['data'] is List) {
        items = data['data'];
      } else if (data is List) {
        items = data;
      }

      final notifications = items.map((json) => NotificationModel.fromJson(json)).toList();
      final unreadCount = (data is Map && data['unread_count'] != null)
          ? (data['unread_count'] as num).toInt()
          : notifications.where((n) => !n.isRead).length;

      return {
        'notifications': notifications,
        'unread_count': unreadCount,
      };
    } catch (e) {
      if (e is Failure) rethrow;
      throw Failure(message: 'تعذر جلب الإشعارات', type: FailureType.unknown);
    }
  }

  @override
  Future<int> getUnreadCount() async {
    try {
      final response = await _apiService.get(ApiConfig.customerNotificationsUnreadCount);
      final data = response.data;
      if (data is Map && data['unread_count'] != null) {
        return (data['unread_count'] as num).toInt();
      }
      return 0;
    } catch (e) {
      if (e is Failure) rethrow;
      return 0;
    }
  }

  @override
  Future<void> markAsRead(String id) async {
    try {
      await _apiService.post(ApiConfig.markNotificationAsRead(id));
    } catch (e) {
      if (e is Failure) rethrow;
      throw Failure(message: 'فشل في تحديث حالة الإشعار', type: FailureType.unknown);
    }
  }

  @override
  Future<void> markAllAsRead() async {
    try {
      await _apiService.post(ApiConfig.markAllNotificationsAsRead);
    } catch (e) {
      if (e is Failure) rethrow;
      throw Failure(message: 'فشل في تحديث حالة جميع الإشعارات', type: FailureType.unknown);
    }
  }
}
