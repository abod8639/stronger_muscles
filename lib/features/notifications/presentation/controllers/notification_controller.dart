import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/core/error/error.dart';
import 'package:stronger_muscles/features/notifications/data/repositories/notification_repository.dart';
import 'package:stronger_muscles/features/notifications/domain/entities/notification_entity.dart';

part 'notification_controller.g.dart';

/// Immutable UI state representing the user notifications and unread badge count.
@immutable
class NotificationsState {
  final List<NotificationEntity> notifications;
  final int unreadCount;

  const NotificationsState({
    this.notifications = const [],
    this.unreadCount = 0,
  });

  NotificationsState copyWith({
    List<NotificationEntity>? notifications,
    int? unreadCount,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotificationsState &&
          runtimeType == other.runtimeType &&
          unreadCount == other.unreadCount &&
          listEquals(notifications, other.notifications);

  @override
  int get hashCode => Object.hash(unreadCount, Object.hashAll(notifications));
}

@Riverpod(keepAlive: true)
class NotificationController extends _$NotificationController {
  CancelToken? _cancelToken;

  @override
  FutureOr<NotificationsState> build() async {
    _cancelToken = CancelToken();

    ref.onDispose(() {
      _cancelToken?.cancel('NotificationController disposed');
      _cancelToken = null;
    });

    final repository = ref.watch(notificationRepositoryProvider);
    final result = await repository.getNotifications(cancelToken: _cancelToken);

    return result.fold(
      (failure) {
        if (failure is CancelFailure) {
          return const NotificationsState();
        }
        throw failure;
      },
      (data) => NotificationsState(
        notifications: data.notifications,
        unreadCount: data.unreadCount,
      ),
    );
  }

  /// Reloads notifications with visual loading indicator and sets AsyncError on failure.
  Future<void> loadNotifications() async {
    _cancelToken?.cancel('Reloading notifications');
    _cancelToken = CancelToken();

    state = const AsyncLoading();

    final repository = ref.read(notificationRepositoryProvider);
    final result = await repository.getNotifications(cancelToken: _cancelToken);

    result.fold(
      (failure) {
        if (failure is CancelFailure) return;
        state = AsyncError(failure, failure.stackTrace ?? StackTrace.current);
      },
      (data) {
        state = AsyncData(
          NotificationsState(
            notifications: data.notifications,
            unreadCount: data.unreadCount,
          ),
        );
      },
    );
  }

  /// Background refresh without flashing a blank loading screen.
  Future<void> refresh() async {
    _cancelToken?.cancel('Refreshing notifications');
    _cancelToken = CancelToken();

    final repository = ref.read(notificationRepositoryProvider);
    final result = await repository.getNotifications(cancelToken: _cancelToken);

    result.fold(
      (failure) {
        // Silently retain current data if background refresh fails
      },
      (data) {
        state = AsyncData(
          NotificationsState(
            notifications: data.notifications,
            unreadCount: data.unreadCount,
          ),
        );
      },
    );
  }

  /// Optimistically marks a notification as read and calls the backend.
  Future<void> markAsRead(String id) async {
    final current = state.value;
    if (current == null) return;

    final updatedList = current.notifications.map((n) {
      if (n.id == id && !n.isRead) {
        return n.copyWith(isRead: true);
      }
      return n;
    }).toList();

    final newCount = (current.unreadCount - 1).clamp(0, 9999);
    state = AsyncData(current.copyWith(
      notifications: updatedList,
      unreadCount: newCount,
    ));

    final repository = ref.read(notificationRepositoryProvider);
    final result = await repository.markAsRead(id);

    result.fold(
      (failure) {
        // Revert on failure
        refresh();
      },
      (_) {},
    );
  }

  /// Optimistically marks all notifications as read.
  Future<void> markAllAsRead() async {
    final current = state.value;
    if (current == null) return;

    final updatedList =
        current.notifications.map((n) => n.copyWith(isRead: true)).toList();
    state = AsyncData(current.copyWith(
      notifications: updatedList,
      unreadCount: 0,
    ));

    final repository = ref.read(notificationRepositoryProvider);
    final result = await repository.markAllAsRead();

    result.fold(
      (failure) {
        refresh();
      },
      (_) {},
    );
  }
}

/// Global provider exposing the total unread notification count for badges.
@Riverpod(keepAlive: true)
int unreadNotificationCount(UnreadNotificationCountRef ref) {
  final notificationState = ref.watch(notificationControllerProvider);
  return notificationState.value?.unreadCount ?? 0;
}
