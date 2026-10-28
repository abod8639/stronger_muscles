import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/error/error.dart';
import 'package:stronger_muscles/features/notifications/domain/entities/notification_entity.dart';

/// Domain contract defining notification data operations.
/// Follows Result/Either pattern via fpdart with typed [Failure] integration.
/// 100% Pure Dart with zero dependencies on Flutter UI or network libraries.
abstract class NotificationRepository {
  /// Fetches a paginated list of notifications and total unread count.
  Future<Either<Failure, NotificationsPayloadEntity>> getNotifications({
    int page = 1,
    int perPage = 20,
  });

  /// Fetches the count of unread notifications for badges.
  Future<Either<Failure, int>> getUnreadCount();

  /// Marks a specific notification as read.
  Future<Either<Failure, Unit>> markAsRead(String id);

  /// Marks all notifications as read.
  Future<Either<Failure, Unit>> markAllAsRead();

  /// Deletes a specific notification.
  Future<Either<Failure, Unit>> deleteNotification(String id);

  /// Clears all user notifications.
  Future<Either<Failure, Unit>> clearAllNotifications();
}
