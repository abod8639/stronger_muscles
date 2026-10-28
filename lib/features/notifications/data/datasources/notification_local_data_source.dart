import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/features/notifications/data/models/notification_model.dart';

/// Local data source contract for caching notifications in Hive.
abstract class NotificationLocalDataSource {
  Future<List<NotificationModel>> getCachedNotifications();
  Future<void> cacheNotifications(List<NotificationModel> notifications);

  Future<int> getCachedUnreadCount();
  Future<void> cacheUnreadCount(int count);

  Future<void> markLocalAsRead(String id);
  Future<void> markAllLocalAsRead();
  Future<void> deleteLocalNotification(String id);

  Future<void> clearCache();
}

/// Concrete Hive implementation of [NotificationLocalDataSource] with robust in-memory fallback.
class NotificationLocalDataSourceImpl implements NotificationLocalDataSource {
  static const String boxName = 'notifications_box';
  static const String _notificationsKey = 'cached_notifications';
  static const String _unreadCountKey = 'cached_unread_count';

  Box? _box;
  final Map<String, dynamic> _inMemoryFallback = {};
  bool _hiveFailed = false;

  NotificationLocalDataSourceImpl([Box? box]) : _box = box;

  Future<Box?> _getBoxSafe() async {
    if (_box != null && _box!.isOpen) return _box;
    if (_hiveFailed) return null;
    try {
      if (Hive.isBoxOpen(boxName)) {
        _box = Hive.box(boxName);
      } else {
        _box = await Hive.openBox(boxName);
      }
      return _box;
    } catch (e) {
      _hiveFailed = true;
      debugPrint('[NotificationLocalDataSource] Hive storage fallback active: $e');
      return null;
    }
  }

  @override
  Future<List<NotificationModel>> getCachedNotifications() async {
    try {
      final box = await _getBoxSafe();
      dynamic raw;
      if (box != null) {
        raw = box.get(_notificationsKey);
      } else {
        raw = _inMemoryFallback[_notificationsKey];
      }

      if (raw is List) {
        return raw.map((item) {
          if (item is NotificationModel) return item;
          if (item is Map) return NotificationModel.fromJson(Map<String, dynamic>.from(item));
          return NotificationModel.fromJson(item);
        }).toList();
      }
      return const [];
    } catch (e) {
      debugPrint('[NotificationLocalDataSource] Error getting cached notifications: $e');
      return const [];
    }
  }

  @override
  Future<void> cacheNotifications(List<NotificationModel> notifications) async {
    try {
      final serialized = notifications.map((n) => n.toJson()).toList();
      final box = await _getBoxSafe();
      if (box != null) {
        await box.put(_notificationsKey, serialized);
      }
      _inMemoryFallback[_notificationsKey] = serialized;
    } catch (e) {
      debugPrint('[NotificationLocalDataSource] Error caching notifications: $e');
      _inMemoryFallback[_notificationsKey] = notifications.map((n) => n.toJson()).toList();
    }
  }

  @override
  Future<int> getCachedUnreadCount() async {
    try {
      final box = await _getBoxSafe();
      dynamic raw;
      if (box != null) {
        raw = box.get(_unreadCountKey);
      } else {
        raw = _inMemoryFallback[_unreadCountKey];
      }

      if (raw is num) {
        return raw.toInt();
      }
      return 0;
    } catch (e) {
      debugPrint('[NotificationLocalDataSource] Error getting cached unread count: $e');
      return 0;
    }
  }

  @override
  Future<void> cacheUnreadCount(int count) async {
    try {
      final box = await _getBoxSafe();
      if (box != null) {
        await box.put(_unreadCountKey, count);
      }
      _inMemoryFallback[_unreadCountKey] = count;
    } catch (e) {
      debugPrint('[NotificationLocalDataSource] Error caching unread count: $e');
      _inMemoryFallback[_unreadCountKey] = count;
    }
  }

  @override
  Future<void> markLocalAsRead(String id) async {
    final cached = await getCachedNotifications();
    final updated = cached.map((n) {
      if (n.id == id && !n.isRead) {
        return n.copyWith(isRead: true);
      }
      return n;
    }).toList();

    await cacheNotifications(updated);
    final count = updated.where((n) => !n.isRead).length;
    await cacheUnreadCount(count);
  }

  @override
  Future<void> markAllLocalAsRead() async {
    final cached = await getCachedNotifications();
    final updated = cached.map((n) => n.copyWith(isRead: true)).toList();
    await cacheNotifications(updated);
    await cacheUnreadCount(0);
  }

  @override
  Future<void> deleteLocalNotification(String id) async {
    final cached = await getCachedNotifications();
    final updated = cached.where((n) => n.id != id).toList();
    await cacheNotifications(updated);
    final count = updated.where((n) => !n.isRead).length;
    await cacheUnreadCount(count);
  }

  @override
  Future<void> clearCache() async {
    try {
      final box = await _getBoxSafe();
      if (box != null) {
        await box.delete(_notificationsKey);
        await box.delete(_unreadCountKey);
      }
      _inMemoryFallback.clear();
    } catch (e) {
      debugPrint('[NotificationLocalDataSource] Error clearing cache: $e');
      _inMemoryFallback.clear();
    }
  }
}
