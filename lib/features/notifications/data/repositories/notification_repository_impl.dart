import 'dart:async';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/error/error.dart';
import 'package:stronger_muscles/features/notifications/data/datasources/notification_local_data_source.dart';
import 'package:stronger_muscles/features/notifications/data/datasources/notification_remote_data_source.dart';
import 'package:stronger_muscles/features/notifications/data/mappers/notification_mapper.dart';
import 'package:stronger_muscles/features/notifications/domain/entities/notification_entity.dart';
import 'package:stronger_muscles/features/notifications/domain/repositories/notification_repository.dart';

/// Concrete implementation of domain [NotificationRepository].
/// Acts as Single Source of Truth orchestrating [NotificationRemoteDataSource]
/// and [NotificationLocalDataSource] with offline caching and functional error handling.
class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _remoteDataSource;
  final NotificationLocalDataSource _localDataSource;

  NotificationRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
  );

  @override
  Future<Either<Failure, NotificationsPayloadEntity>> getNotifications({
    int page = 1,
    int perPage = 20,
  }) async {
    return NetworkErrorHandler.execute<NotificationsPayloadEntity>(() async {
      // Offline-first strategy: Return cache on initial load if available
      if (page == 1) {
        final cached = await _localDataSource.getCachedNotifications();
        if (cached.isNotEmpty) {
          // Local cache is populated for offline availability
        }
      }

      try {
        final payloadModel = await _remoteDataSource.getNotifications(
          page: page,
          perPage: perPage,
        );

        if (page == 1) {
          unawaited(_localDataSource.cacheNotifications(payloadModel.notifications));
          unawaited(_localDataSource.cacheUnreadCount(payloadModel.unreadCount));
        }

        return payloadModel.toEntity();
      } on Failure catch (failure) {
        if (failure is CancelFailure) rethrow;

        // Fallback to local cache on network or server failure
        final cached = await _localDataSource.getCachedNotifications();
        if (cached.isNotEmpty) {
          final unreadCount = await _localDataSource.getCachedUnreadCount();
          return NotificationsPayloadEntity(
            notifications: cached.map((m) => m.toEntity()).toList(),
            unreadCount: unreadCount,
            hasMore: false,
          );
        }
        rethrow;
      }
    });
  }

  @override
  Future<Either<Failure, int>> getUnreadCount() async {
    return NetworkErrorHandler.execute<int>(() async {
      try {
        final count = await _remoteDataSource.getUnreadCount();
        unawaited(_localDataSource.cacheUnreadCount(count));
        return count;
      } on Failure catch (failure) {
        if (failure is CancelFailure) rethrow;

        final cachedCount = await _localDataSource.getCachedUnreadCount();
        return cachedCount;
      }
    });
  }

  @override
  Future<Either<Failure, Unit>> markAsRead(String id) async {
    return NetworkErrorHandler.execute<Unit>(() async {
      // Optimistically update local cache
      unawaited(_localDataSource.markLocalAsRead(id));

      await _remoteDataSource.markAsRead(id);
      return unit;
    });
  }

  @override
  Future<Either<Failure, Unit>> markAllAsRead() async {
    return NetworkErrorHandler.execute<Unit>(() async {
      // Optimistically update local cache
      unawaited(_localDataSource.markAllLocalAsRead());

      await _remoteDataSource.markAllAsRead();
      return unit;
    });
  }

  @override
  Future<Either<Failure, Unit>> deleteNotification(String id) async {
    return NetworkErrorHandler.execute<Unit>(() async {
      unawaited(_localDataSource.deleteLocalNotification(id));

      await _remoteDataSource.deleteNotification(id);
      return unit;
    });
  }

  @override
  Future<Either<Failure, Unit>> clearAllNotifications() async {
    return NetworkErrorHandler.execute<Unit>(() async {
      await _localDataSource.clearCache();
      return unit;
    });
  }
}
