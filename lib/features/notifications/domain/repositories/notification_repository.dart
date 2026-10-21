import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/error/error.dart';
import 'package:stronger_muscles/features/notifications/domain/entities/notification_entity.dart';

/// Domain contract defining notification data operations.
/// Follows Result/Either pattern with typed [Failure] integration.
abstract class NotificationRepository {
  /// Fetches a paginated list of notifications and total unread count.
  Future<Either<Failure, NotificationsPayloadEntity>> getNotifications({
    int page = 1,
    int perPage = 20,
    CancelToken? cancelToken,
  });

  /// Fetches the count of unread notifications for badges.
  Future<Either<Failure, int>> getUnreadCount({CancelToken? cancelToken});

  /// Marks a specific notification as read.
  Future<Either<Failure, Unit>> markAsRead(
    String id, {
    CancelToken? cancelToken,
  });

  /// Marks all notifications as read.
  Future<Either<Failure, Unit>> markAllAsRead({CancelToken? cancelToken});
}
