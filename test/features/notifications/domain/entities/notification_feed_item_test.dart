import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/features/notifications/domain/entities/notification_entity.dart';
import 'package:stronger_muscles/features/notifications/domain/entities/notification_feed_item.dart';

void main() {
  group('groupNotificationsIntoFeedItems', () {
    test('returns empty list when input is empty', () {
      final items = groupNotificationsIntoFeedItems([]);
      expect(items, isEmpty);
    });

    test('keeps non-ticket notifications as SingleNotificationFeedItem in order', () {
      final n1 = NotificationEntity(
        id: '1',
        title: 'Order shipped',
        body: 'Your order is on the way',
        type: 'order',
        createdAt: DateTime(2026, 10, 30, 10, 0),
      );
      final n2 = NotificationEntity(
        id: '2',
        title: 'Promo 50%',
        body: 'Huge discounts available',
        type: 'promo',
        createdAt: DateTime(2026, 10, 30, 9, 0),
      );

      final items = groupNotificationsIntoFeedItems([n1, n2]);
      expect(items.length, 2);
      expect(items[0], isA<SingleNotificationFeedItem>());
      expect((items[0] as SingleNotificationFeedItem).notification.id, '1');
      expect(items[1], isA<SingleNotificationFeedItem>());
      expect((items[1] as SingleNotificationFeedItem).notification.id, '2');
    });

    test('groups multiple notifications belonging to the same ticket into ONE GroupedTicketNotificationFeedItem', () {
      final now = DateTime.now();
      final t1 = NotificationEntity(
        id: '33',
        title: 'رد جديد على تذكرة الدعم (#SM-VKBVQ9LO)',
        body: 'Message 3',
        type: 'support',
        data: {
          'ticket_id': '6',
          'ticket_number': 'SM-VKBVQ9LO',
          'priority': 'normal',
          'status': 'waiting_user',
          'category': 'الطلبات والشحن',
          'user_name': 'Abood',
          'messages_count': 22,
        },
        createdAt: now,
        isRead: false,
      );

      final t2 = NotificationEntity(
        id: '32',
        title: 'رد جديد على تذكرة الدعم (#SM-VKBVQ9LO)',
        body: 'Message 2',
        type: 'support',
        data: {
          'ticket_id': '6',
          'ticket_number': 'SM-VKBVQ9LO',
        },
        createdAt: now.subtract(const Duration(minutes: 5)),
        isRead: false,
      );

      final t3 = NotificationEntity(
        id: '31',
        title: 'رد جديد على تذكرة الدعم (#SM-VKBVQ9LO)',
        body: 'Message 1',
        type: 'support',
        data: {
          'ticket_id': '6',
          'ticket_number': 'SM-VKBVQ9LO',
        },
        createdAt: now.subtract(const Duration(minutes: 10)),
        isRead: true,
      );

      final order = NotificationEntity(
        id: '10',
        title: 'طلبك تم شحنه',
        body: 'تم تسليم الشحنة لشركة الشحن',
        type: 'order',
        createdAt: now.subtract(const Duration(hours: 1)),
      );

      final items = groupNotificationsIntoFeedItems([t1, t2, t3, order]);

      // Expect exactly 2 items in feed: 1 grouped ticket item and 1 order item
      expect(items.length, 2);

      expect(items[0], isA<GroupedTicketNotificationFeedItem>());
      final ticketItem = items[0] as GroupedTicketNotificationFeedItem;
      expect(ticketItem.ticketId, '6');
      expect(ticketItem.ticketNumber, 'SM-VKBVQ9LO');
      expect(ticketItem.priority, 'normal');
      expect(ticketItem.status, 'waiting_user');
      expect(ticketItem.category, 'الطلبات والشحن');
      expect(ticketItem.senderName, 'Abood');
      expect(ticketItem.totalMessagesCount, 22);
      expect(ticketItem.unreadCount, 2); // t1 and t2 are unread, t3 is read
      expect(ticketItem.isRead, isFalse);
      expect(ticketItem.latestMessage, 'Message 3');
      expect(ticketItem.notifications.length, 3);
      expect(ticketItem.allNotificationIds, ['33', '32', '31']);

      // Standalone order item
      expect(items[1], isA<SingleNotificationFeedItem>());
      expect((items[1] as SingleNotificationFeedItem).notification.id, '10');
    });

    test('groups distinct tickets separately while preserving order', () {
      final now = DateTime.now();
      final ticketA1 = NotificationEntity(
        id: '1',
        title: 'رد على تذكرة A',
        body: 'Latest in A',
        type: 'support',
        data: {'ticket_id': '101', 'ticket_number': 'TICK-A'},
        createdAt: now,
      );
      final ticketB1 = NotificationEntity(
        id: '2',
        title: 'رد على تذكرة B',
        body: 'Latest in B',
        type: 'support',
        data: {'ticket_id': '202', 'ticket_number': 'TICK-B'},
        createdAt: now.subtract(const Duration(minutes: 1)),
      );
      final ticketA2 = NotificationEntity(
        id: '3',
        title: 'رد سابق على A',
        body: 'Earlier in A',
        type: 'support',
        data: {'ticket_id': '101', 'ticket_number': 'TICK-A'},
        createdAt: now.subtract(const Duration(minutes: 2)),
      );

      final items = groupNotificationsIntoFeedItems([ticketA1, ticketB1, ticketA2]);

      expect(items.length, 2);
      expect((items[0] as GroupedTicketNotificationFeedItem).ticketId, '101');
      expect((items[0] as GroupedTicketNotificationFeedItem).notifications.length, 2);
      expect((items[1] as GroupedTicketNotificationFeedItem).ticketId, '202');
      expect((items[1] as GroupedTicketNotificationFeedItem).notifications.length, 1);
    });
  });
}

