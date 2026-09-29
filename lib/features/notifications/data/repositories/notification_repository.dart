import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../datasources/notification_remote_data_source.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final remoteDataSource = ref.watch(notificationRemoteDataSourceProvider);
  return NotificationRepositoryImpl(remoteDataSource);
});

abstract class NotificationRepository {
  Future<Map<String, dynamic>> getNotifications({int page = 1, int perPage = 20});
  Future<int> getUnreadCount();
  Future<void> markAsRead(String id);
  Future<void> markAllAsRead();
}

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _remoteDataSource;

  NotificationRepositoryImpl(this._remoteDataSource);

  @override
  Future<Map<String, dynamic>> getNotifications({int page = 1, int perPage = 20}) {
    return _remoteDataSource.getNotifications(page: page, perPage: perPage);
  }

  @override
  Future<int> getUnreadCount() {
    return _remoteDataSource.getUnreadCount();
  }

  @override
  Future<void> markAsRead(String id) {
    return _remoteDataSource.markAsRead(id);
  }

  @override
  Future<void> markAllAsRead() {
    return _remoteDataSource.markAllAsRead();
  }
}
