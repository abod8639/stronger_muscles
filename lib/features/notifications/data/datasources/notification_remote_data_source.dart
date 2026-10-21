import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/config/api_config.dart';
import 'package:stronger_muscles/core/error/error.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import '../models/notification_model.dart';

/// Top-level isolate function to parse notification payload on a background thread.
Map<String, dynamic> parseNotificationsPayloadIsolate(dynamic data) {
  final notifications = NotificationModel.fromJsonList(data);

  int unreadCount = 0;
  if (data is Map && data['unread_count'] != null) {
    unreadCount = (data['unread_count'] as num).toInt();
  } else {
    unreadCount = notifications.where((n) => !n.isRead).length;
  }

  return {
    'notifications': notifications,
    'unread_count': unreadCount,
  };
}

final notificationRemoteDataSourceProvider =
    Provider<NotificationRemoteDataSource>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return NotificationRemoteDataSourceImpl(apiService);
});

abstract class NotificationRemoteDataSource {
  Future<Map<String, dynamic>> getNotifications({
    int page = 1,
    int perPage = 20,
    CancelToken? cancelToken,
  });

  Future<int> getUnreadCount({CancelToken? cancelToken});

  Future<void> markAsRead(String id, {CancelToken? cancelToken});

  Future<void> markAllAsRead({CancelToken? cancelToken});
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final ApiService _apiService;
  static const Duration _timeout = Duration(seconds: 15);

  NotificationRemoteDataSourceImpl(this._apiService);

  @override
  Future<Map<String, dynamic>> getNotifications({
    int page = 1,
    int perPage = 20,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _apiService.get(
        ApiConfig.customerNotifications,
        queryParameters: {'page': page, 'per_page': perPage},
        cancelToken: cancelToken,
        timeout: _timeout,
      );

      // Offload JSON decoding and entity mapping to background isolate via compute
      return await compute(parseNotificationsPayloadIsolate, response.data);
    } on DioException catch (e, st) {
      throw NetworkErrorHandler.handleDioError(e, st);
    } catch (e, st) {
      if (e is Failure) rethrow;
      throw NetworkErrorHandler.handle(e, st);
    }
  }

  @override
  Future<int> getUnreadCount({CancelToken? cancelToken}) async {
    try {
      final response = await _apiService.get(
        ApiConfig.customerNotificationsUnreadCount,
        cancelToken: cancelToken,
        timeout: _timeout,
      );

      final data = response.data;
      if (data is Map && data['unread_count'] != null) {
        return (data['unread_count'] as num).toInt();
      }
      return 0;
    } on DioException catch (e, st) {
      throw NetworkErrorHandler.handleDioError(e, st);
    } catch (e, st) {
      if (e is Failure) rethrow;
      throw NetworkErrorHandler.handle(e, st);
    }
  }

  @override
  Future<void> markAsRead(String id, {CancelToken? cancelToken}) async {
    try {
      await _apiService.post(
        ApiConfig.markNotificationAsRead(id),
        cancelToken: cancelToken,
        timeout: _timeout,
      );
    } on DioException catch (e, st) {
      throw NetworkErrorHandler.handleDioError(e, st);
    } catch (e, st) {
      if (e is Failure) rethrow;
      throw NetworkErrorHandler.handle(e, st);
    }
  }

  @override
  Future<void> markAllAsRead({CancelToken? cancelToken}) async {
    try {
      await _apiService.post(
        ApiConfig.markAllNotificationsAsRead,
        cancelToken: cancelToken,
        timeout: _timeout,
      );
    } on DioException catch (e, st) {
      throw NetworkErrorHandler.handleDioError(e, st);
    } catch (e, st) {
      if (e is Failure) rethrow;
      throw NetworkErrorHandler.handle(e, st);
    }
  }
}
