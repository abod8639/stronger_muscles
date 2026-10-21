import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/error/error.dart';
import 'package:stronger_muscles/features/notifications/data/datasources/notification_remote_data_source.dart';
import 'package:stronger_muscles/features/notifications/data/models/notification_model.dart';
import 'package:stronger_muscles/features/notifications/domain/repositories/notification_repository.dart';

/// Concrete implementation of domain [NotificationRepository].
/// Integrates directly with [NetworkErrorHandler.execute] returning [Either<Failure, T>].
class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _remoteDataSource;

  NotificationRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, NotificationsPayloadEntity>> getNotifications({
    int page = 1,
    int perPage = 20,
    CancelToken? cancelToken,
  }) async {
    return NetworkErrorHandler.execute<NotificationsPayloadEntity>(() async {
      final result = await _remoteDataSource.getNotifications(
        page: page,
        perPage: perPage,
        cancelToken: cancelToken,
      );

      final List<NotificationModel> list =
          (result['notifications'] as List<NotificationModel>?) ?? [];
      final int count = result['unread_count'] as int? ??
          list.where((n) => !n.isRead).length;

      return NotificationsPayloadEntity(
        notifications: list.map((m) => m.toEntity()).toList(),
        unreadCount: count,
      );
    });
  }

  @override
  Future<Either<Failure, int>> getUnreadCount({CancelToken? cancelToken}) async {
    return NetworkErrorHandler.execute<int>(() async {
      return await _remoteDataSource.getUnreadCount(cancelToken: cancelToken);
    });
  }

  @override
  Future<Either<Failure, Unit>> markAsRead(
    String id, {
    CancelToken? cancelToken,
  }) async {
    return NetworkErrorHandler.execute<Unit>(() async {
      await _remoteDataSource.markAsRead(id, cancelToken: cancelToken);
      return unit;
    });
  }

  @override
  Future<Either<Failure, Unit>> markAllAsRead({
    CancelToken? cancelToken,
  }) async {
    return NetworkErrorHandler.execute<Unit>(() async {
      await _remoteDataSource.markAllAsRead(cancelToken: cancelToken);
      return unit;
    });
  }
}
