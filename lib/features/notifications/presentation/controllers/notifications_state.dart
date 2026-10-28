import 'package:flutter/foundation.dart';
import 'package:stronger_muscles/features/notifications/domain/entities/notification_entity.dart';

/// Immutable UI state representing the user notifications and unread badge count.
@immutable
class NotificationsState {
  final List<NotificationEntity> notifications;
  final int unreadCount;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final int currentPage;
  final String? errorMessage;

  const NotificationsState({
    this.notifications = const [],
    this.unreadCount = 0,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.currentPage = 1,
    this.errorMessage,
  });

  NotificationsState copyWith({
    List<NotificationEntity>? notifications,
    int? unreadCount,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    int? currentPage,
    String? errorMessage,
    bool clearError = false,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationsState &&
          runtimeType == other.runtimeType &&
          unreadCount == other.unreadCount &&
          isLoading == other.isLoading &&
          isLoadingMore == other.isLoadingMore &&
          hasMore == other.hasMore &&
          currentPage == other.currentPage &&
          errorMessage == other.errorMessage &&
          listEquals(notifications, other.notifications);

  @override
  int get hashCode => Object.hash(
        unreadCount,
        isLoading,
        isLoadingMore,
        hasMore,
        currentPage,
        errorMessage,
        Object.hashAll(notifications),
      );
}
