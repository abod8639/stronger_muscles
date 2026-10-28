import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/core/error/error.dart';
import 'package:stronger_muscles/features/auth/auth_feature.dart';
import 'package:stronger_muscles/features/notifications/presentation/controllers/notifications_di.dart';
import 'package:stronger_muscles/features/notifications/presentation/controllers/notifications_state.dart';

export 'notifications_state.dart';

part 'notification_controller.g.dart';

@Riverpod(keepAlive: true)
class NotificationController extends _$NotificationController {
  static const int _pageSize = 20;

  int _currentPage = 1;
  int get currentPage => _currentPage;

  bool _isLoadingMore = false;
  bool get isLoadingMore => _isLoadingMore;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  bool _isMutating = false;

  @override
  FutureOr<NotificationsState> build() async {
    _currentPage = 1;
    _isLoadingMore = false;
    _hasMore = true;
    _isMutating = false;

    // Guard: Only fetch notifications for authenticated users
    final isLoggedIn = ref.watch(
      authControllerProvider.select((state) => state.valueOrNull != null),
    );
    if (!isLoggedIn) {
      return const NotificationsState();
    }

    final getNotifications = ref.watch(getNotificationsUseCaseProvider);
    final result = await getNotifications(page: 1, perPage: _pageSize);

    return result.fold(
      (failure) {
        if (failure is CancelFailure || failure.type == FailureType.auth) {
          return const NotificationsState();
        }
        throw failure;
      },
      (data) {
        if (data.notifications.length < _pageSize || !data.hasMore) {
          _hasMore = data.hasMore;
        }
        return NotificationsState(
          notifications: data.notifications,
          unreadCount: data.unreadCount,
          hasMore: data.hasMore,
          currentPage: 1,
        );
      },
    );
  }

  /// Reloads notifications with visual loading indicator and sets AsyncError on failure.
  Future<void> loadNotifications() async {
    final isLoggedIn = ref.read(
      authControllerProvider.select((state) => state.valueOrNull != null),
    );
    if (!isLoggedIn) {
      state = const AsyncData(NotificationsState());
      return;
    }

    _currentPage = 1;
    _isLoadingMore = false;
    _hasMore = true;

    state = const AsyncLoading();

    final getNotifications = ref.read(getNotificationsUseCaseProvider);
    final result = await getNotifications(page: 1, perPage: _pageSize);

    result.fold(
      (failure) {
        if (failure is CancelFailure || failure.type == FailureType.auth) {
          state = const AsyncData(NotificationsState());
          return;
        }
        state = AsyncError(failure, failure.stackTrace ?? StackTrace.current);
      },
      (data) {
        _hasMore = data.hasMore && data.notifications.length >= _pageSize;
        state = AsyncData(
          NotificationsState(
            notifications: data.notifications,
            unreadCount: data.unreadCount,
            hasMore: _hasMore,
            currentPage: 1,
          ),
        );
      },
    );
  }

  /// Paginated fetch for subsequent notification items with guard clauses.
  Future<void> loadMoreNotifications() async {
    if (_isLoadingMore || !_hasMore) return;

    final current = state.valueOrNull;
    if (current == null || current.notifications.isEmpty) return;

    _isLoadingMore = true;
    final nextPage = _currentPage + 1;

    final getNotifications = ref.read(getNotificationsUseCaseProvider);
    final result = await getNotifications(page: nextPage, perPage: _pageSize);

    _isLoadingMore = false;

    result.fold(
      (failure) {
        // Retain existing notification list on pagination failure
      },
      (data) {
        if (data.notifications.isEmpty || data.notifications.length < _pageSize) {
          _hasMore = false;
        } else {
          _hasMore = data.hasMore;
        }

        if (data.notifications.isNotEmpty) {
          _currentPage = nextPage;
          state = AsyncData(
            current.copyWith(
              notifications: [...current.notifications, ...data.notifications],
              unreadCount: data.unreadCount,
              hasMore: _hasMore,
              currentPage: nextPage,
            ),
          );
        }
      },
    );
  }

  /// Background refresh without flashing a blank loading screen.
  Future<void> refresh() async {
    final isLoggedIn = ref.read(
      authControllerProvider.select((state) => state.valueOrNull != null),
    );
    if (!isLoggedIn) {
      state = const AsyncData(NotificationsState());
      return;
    }

    _currentPage = 1;
    _isLoadingMore = false;
    _hasMore = true;

    final getNotifications = ref.read(getNotificationsUseCaseProvider);
    final result = await getNotifications(page: 1, perPage: _pageSize);

    result.fold(
      (failure) {
        if (failure.type == FailureType.auth) {
          state = const AsyncData(NotificationsState());
        }
      },
      (data) {
        _hasMore = data.hasMore && data.notifications.length >= _pageSize;
        state = AsyncData(
          NotificationsState(
            notifications: data.notifications,
            unreadCount: data.unreadCount,
            hasMore: _hasMore,
            currentPage: 1,
          ),
        );
      },
    );
  }

  /// Optimistically marks a notification as read and calls the domain usecase.
  Future<void> markAsRead(String id) async {
    final current = state.valueOrNull;
    if (current == null) return;

    final target = current.notifications.where((n) => n.id == id).firstOrNull;
    if (target == null || target.isRead) return;

    final updatedList = current.notifications.map((n) {
      if (n.id == id && !n.isRead) {
        return n.copyWith(isRead: true);
      }
      return n;
    }).toList();

    final newCount = (current.unreadCount - 1).clamp(0, 9999);
    state = AsyncData(
      current.copyWith(
        notifications: updatedList,
        unreadCount: newCount,
      ),
    );

    final markAsReadUseCase = ref.read(markAsReadUseCaseProvider);
    final result = await markAsReadUseCase(id);

    result.fold(
      (failure) {
        // Rollback on failure
        refresh();
      },
      (_) {},
    );
  }

  /// Optimistically marks all notifications as read with guard clause.
  Future<void> markAllAsRead() async {
    if (_isMutating) return;

    final current = state.valueOrNull;
    if (current == null || current.unreadCount == 0) return;

    _isMutating = true;

    final updatedList =
        current.notifications.map((n) => n.copyWith(isRead: true)).toList();
    state = AsyncData(
      current.copyWith(
        notifications: updatedList,
        unreadCount: 0,
      ),
    );

    final markAllUseCase = ref.read(markAllAsReadUseCaseProvider);
    final result = await markAllUseCase();

    _isMutating = false;

    result.fold(
      (failure) {
        refresh();
      },
      (_) {},
    );
  }

  /// Deletes a specific notification with optimistic removal.
  Future<void> deleteNotification(String id) async {
    final current = state.valueOrNull;
    if (current == null) return;

    final target = current.notifications.where((n) => n.id == id).firstOrNull;
    if (target == null) return;

    final wasUnread = !target.isRead;
    final updatedList = current.notifications.where((n) => n.id != id).toList();
    final newCount = wasUnread
        ? (current.unreadCount - 1).clamp(0, 9999)
        : current.unreadCount;

    state = AsyncData(
      current.copyWith(
        notifications: updatedList,
        unreadCount: newCount,
      ),
    );

    final deleteUseCase = ref.read(deleteNotificationUseCaseProvider);
    final result = await deleteUseCase(id);

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
  return notificationState.valueOrNull?.unreadCount ?? 0;
}
