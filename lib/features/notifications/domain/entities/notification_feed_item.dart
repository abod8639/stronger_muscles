import 'package:flutter/foundation.dart';
import 'package:stronger_muscles/features/notifications/domain/entities/notification_entity.dart';

/// Base class for all notification items rendered in the notification feed.
@immutable
sealed class NotificationFeedItem {
  const NotificationFeedItem();
}

/// A standalone notification item (order updates, promotions, system messages, etc.)
@immutable
class SingleNotificationFeedItem extends NotificationFeedItem {
  final NotificationEntity notification;

  const SingleNotificationFeedItem(this.notification);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SingleNotificationFeedItem &&
          runtimeType == other.runtimeType &&
          notification == other.notification;

  @override
  int get hashCode => notification.hashCode;
}

/// A consolidated support ticket notification grouping all messages/updates for a specific ticket.
@immutable
class GroupedTicketNotificationFeedItem extends NotificationFeedItem {
  final String ticketId;
  final String ticketNumber;
  final String? priority;
  final String? status;
  final String? category;
  final String? senderName;
  final String? senderAvatar;
  final int totalMessagesCount;
  final int unreadCount;
  final DateTime? latestCreatedAt;
  final String latestMessage;
  final List<NotificationEntity> notifications;

  const GroupedTicketNotificationFeedItem({
    required this.ticketId,
    required this.ticketNumber,
    this.priority,
    this.status,
    this.category,
    this.senderName,
    this.senderAvatar,
    required this.totalMessagesCount,
    required this.unreadCount,
    this.latestCreatedAt,
    required this.latestMessage,
    required this.notifications,
  });

  bool get isRead => unreadCount == 0;
  List<String> get allNotificationIds => notifications.map((n) => n.id).toList();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroupedTicketNotificationFeedItem &&
          runtimeType == other.runtimeType &&
          ticketId == other.ticketId &&
          ticketNumber == other.ticketNumber &&
          priority == other.priority &&
          status == other.status &&
          category == other.category &&
          senderName == other.senderName &&
          senderAvatar == other.senderAvatar &&
          totalMessagesCount == other.totalMessagesCount &&
          unreadCount == other.unreadCount &&
          latestMessage == other.latestMessage &&
          listEquals(notifications, other.notifications);

  @override
  int get hashCode => Object.hash(
        ticketId,
        ticketNumber,
        priority,
        status,
        category,
        senderName,
        senderAvatar,
        totalMessagesCount,
        unreadCount,
        latestMessage,
        Object.hashAll(notifications),
      );
}

/// Groups notifications so that multiple messages belonging to the same support ticket
/// are consolidated into a single [GroupedTicketNotificationFeedItem] positioned at the
/// chronologically latest update, while non-ticket notifications remain separate.
List<NotificationFeedItem> groupNotificationsIntoFeedItems(
  List<NotificationEntity> notifications,
) {
  if (notifications.isEmpty) return const [];

  // 1. Index support ticket notifications by their unique ticket identifier
  final Map<String, List<NotificationEntity>> ticketGroups = {};
  for (final notification in notifications) {
    if (notification.isSupport) {
      final key = notification.ticketId ?? notification.ticketNumber;
      if (key != null && key.isNotEmpty) {
        ticketGroups.putIfAbsent(key, () => []).add(notification);
      }
    }
  }

  // 2. Build the feed items preserving chronological order
  final List<NotificationFeedItem> feedItems = [];
  final Set<String> processedTicketKeys = {};

  for (final notification in notifications) {
    if (notification.isSupport) {
      final key = notification.ticketId ?? notification.ticketNumber;
      if (key != null && key.isNotEmpty) {
        if (processedTicketKeys.contains(key)) {
          // Already aggregated in this ticket's single card
          continue;
        }
        processedTicketKeys.add(key);

        final group = ticketGroups[key]!;
        final latest = group.first;

        final ticketId = group
            .map((n) => n.ticketId)
            .firstWhere((id) => id != null && id.isNotEmpty, orElse: () => key)!;

        final ticketNumber = group
            .map((n) => n.ticketNumber)
            .firstWhere((tNum) => tNum != null && tNum.isNotEmpty, orElse: () => key)!;

        final priority = group
            .map((n) => n.ticketPriority)
            .firstWhere((p) => p != null && p.isNotEmpty, orElse: () => null);

        final status = group
            .map((n) => n.ticketStatus)
            .firstWhere((s) => s != null && s.isNotEmpty, orElse: () => null);

        final category = group
            .map((n) => n.ticketCategory)
            .firstWhere((c) => c != null && c.isNotEmpty, orElse: () => null);

        final senderName = group
            .map((n) => n.ticketSenderName)
            .firstWhere((name) => name != null && name.isNotEmpty, orElse: () => null);

        final senderAvatar = group
            .map((n) => n.ticketSenderAvatar)
            .firstWhere((avatar) => avatar != null && avatar.isNotEmpty, orElse: () => null);

        final totalMessages = group
            .map((n) => n.ticketMessagesCount)
            .firstWhere((c) => c != null && c > 0, orElse: () => null) ??
            group.length;

        final unreadCount = group.where((n) => !n.isRead).length;

        feedItems.add(
          GroupedTicketNotificationFeedItem(
            ticketId: ticketId,
            ticketNumber: ticketNumber,
            priority: priority,
            status: status,
            category: category,
            senderName: senderName,
            senderAvatar: senderAvatar,
            totalMessagesCount: totalMessages,
            unreadCount: unreadCount,
            latestCreatedAt: latest.createdAt,
            latestMessage: latest.body,
            notifications: group,
          ),
        );
        continue;
      }
    }

    // Standard non-ticket notification
    feedItems.add(SingleNotificationFeedItem(notification));
  }

  return feedItems;
}
