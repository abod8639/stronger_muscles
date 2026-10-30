import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/features/notifications/domain/entities/notification_entity.dart';
import 'package:stronger_muscles/features/notifications/domain/entities/notification_feed_item.dart';
import 'package:stronger_muscles/features/notifications/presentation/widgets/grouped_ticket_notification_card.dart';
import 'package:stronger_muscles/routes/routes.dart';

void main() {
  testWidgets('GroupedTicketNotificationCard displays all ticket summary elements and handles tap',
      (tester) async {
    final now = DateTime(2026, 10, 30, 2, 24);
    final notification = NotificationEntity(
      id: '33',
      title: 'رد جديد على تذكرة الدعم (#SM-VKBVQ9LO)',
      body: 'شحنتك في طريقها إليك',
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

    final item = GroupedTicketNotificationFeedItem(
      ticketId: '6',
      ticketNumber: 'SM-VKBVQ9LO',
      priority: 'normal',
      status: 'waiting_user',
      category: 'الطلبات والشحن',
      senderName: 'Abood',
      totalMessagesCount: 22,
      unreadCount: 1,
      latestCreatedAt: now,
      latestMessage: 'شحنتك في طريقها إليك',
      notifications: [notification],
    );

    String? pushedRoute;
    Object? pushedExtra;

    final router = GoRouter(
      initialLocation: '/notifications',
      routes: [
        GoRoute(
          path: '/notifications',
          builder: (context, state) => Scaffold(
            body: GroupedTicketNotificationCard(item: item),
          ),
        ),
        GoRoute(
          path: AppRoutes.supportChat,
          builder: (context, state) {
            pushedRoute = AppRoutes.supportChat;
            pushedExtra = state.extra;
            return const Scaffold(body: Text('SupportChatPage'));
          },
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          routerConfig: router,
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify UI elements are present
    expect(find.text('SM-VKBVQ9LO'), findsOneWidget);
    expect(find.text('Abood'), findsOneWidget);
    expect(find.text('شحنتك في طريقها إليك'), findsOneWidget);
    expect(find.text('بانتظار العميل'), findsOneWidget);
    expect(find.text('الطلبات والشحن'), findsOneWidget);
    expect(find.text('22'), findsOneWidget);
    expect(find.byIcon(Icons.chat_bubble_outline_rounded), findsOneWidget);

    // Tap the card to navigate
    await tester.tap(find.text('شحنتك في طريقها إليك'));
    await tester.pumpAndSettle();

    expect(pushedRoute, AppRoutes.supportChat);
    expect(pushedExtra, {'ticket_id': '6'});
  });
}

