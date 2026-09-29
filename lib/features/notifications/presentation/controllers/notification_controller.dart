import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/notification_model.dart';
import '../../data/repositories/notification_repository.dart';

class NotificationsState {
  final List<NotificationModel> notifications;
  final int unreadCount;
  final bool isLoading;
  final String? error;

  const NotificationsState({
    this.notifications = const [],
    this.unreadCount = 0,
    this.isLoading = false,
    this.error,
  });

  NotificationsState copyWith({
    List<NotificationModel>? notifications,
    int? unreadCount,
    bool? isLoading,
    String? error,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class NotificationNotifier extends StateNotifier<NotificationsState> {
  final NotificationRepository _repository;

  NotificationNotifier(this._repository) : super(const NotificationsState()) {
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await _repository.getNotifications();
      final List<NotificationModel> list = result['notifications'] ?? [];
      final int count = result['unread_count'] ?? list.where((n) => !n.isRead).length;

      state = state.copyWith(
        notifications: list,
        unreadCount: count,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString().replaceAll('Exception: ', ''),
      );
    }
  }

  Future<void> refresh() async {
    try {
      final result = await _repository.getNotifications();
      final List<NotificationModel> list = result['notifications'] ?? [];
      final int count = result['unread_count'] ?? list.where((n) => !n.isRead).length;

      state = state.copyWith(
        notifications: list,
        unreadCount: count,
        error: null,
      );
    } catch (_) {}
  }

  Future<void> markAsRead(String id) async {
    // Optimistic update
    final updatedList = state.notifications.map((n) {
      if (n.id == id && !n.isRead) {
        return n.copyWith(isRead: true);
      }
      return n;
    }).toList();

    final newCount = (state.unreadCount - 1).clamp(0, 9999);
    state = state.copyWith(notifications: updatedList, unreadCount: newCount);

    try {
      await _repository.markAsRead(id);
    } catch (_) {
      // Revert if failed
      refresh();
    }
  }

  Future<void> markAllAsRead() async {
    // Optimistic update
    final updatedList = state.notifications.map((n) => n.copyWith(isRead: true)).toList();
    state = state.copyWith(notifications: updatedList, unreadCount: 0);

    try {
      await _repository.markAllAsRead();
    } catch (_) {
      refresh();
    }
  }
}

final notificationControllerProvider = StateNotifierProvider<NotificationNotifier, NotificationsState>((ref) {
  final repo = ref.watch(notificationRepositoryProvider);
  return NotificationNotifier(repo);
});

final unreadNotificationCountProvider = Provider<int>((ref) {
  return ref.watch(notificationControllerProvider).unreadCount;
});
