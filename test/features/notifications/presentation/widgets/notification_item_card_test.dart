import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/features/notifications/domain/entities/notification_entity.dart';
import 'package:stronger_muscles/features/notifications/presentation/controllers/notification_controller.dart';
import 'package:stronger_muscles/features/notifications/presentation/widgets/notification_item_card.dart';
import 'package:stronger_muscles/routes/routes.dart';

class FakeNotificationController extends NotificationController {
  String? markedReadId;

  @override
  FutureOr<NotificationsState> build() {
    return const NotificationsState();
  }

  @override
  Future<void> markAsRead(String id) async {
    markedReadId = id;
  }
}

void main() {
  testWidgets('NotificationItemCard navigates to helpSupport with ticketId on tap', (tester) async {
    final fakeController = FakeNotificationController();
    String? navigatedRoute;
    Object? navigatedExtra;

    final router = GoRouter(
      initialLocation: '/notifications',
      routes: [
        GoRoute(
          path: '/notifications',
          builder: (context, state) => Scaffold(
            body: NotificationItemCard(
              notification: NotificationEntity(
                id: '29',
                title: 'رد جديد على تذكرة الدعم (#SM-VKBVQ9LO)',
                body: 'zz',
                type: 'support',
                data: const {
                  'ticket_id': 6,
                  'ticket_number': 'SM-VKBVQ9LO',
                },
                isRead: false,
              ),
            ),
          ),
        ),
        GoRoute(
          path: AppRoutes.helpSupport,
          builder: (context, state) {
            navigatedRoute = state.matchedLocation;
            navigatedExtra = state.extra;
            return const Scaffold(body: Text('HelpSupportScreen'));
          },
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          notificationControllerProvider.overrideWith(() => fakeController),
        ],
        child: MaterialApp.router(
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('رد جديد على تذكرة الدعم (#SM-VKBVQ9LO)'), findsOneWidget);
    expect(find.byIcon(Icons.support_agent_outlined), findsOneWidget);

    await tester.tap(find.byType(NotificationItemCard));
    await tester.pumpAndSettle();

    expect(fakeController.markedReadId, '29');
    expect(navigatedRoute, AppRoutes.helpSupport);
    expect(navigatedExtra, isA<Map>());
    final extraMap = navigatedExtra as Map;
    expect(extraMap['ticket_id'], '6');
    expect(extraMap['ticket_number'], 'SM-VKBVQ9LO');
    expect(extraMap['open_active_ticket'], isTrue);
  });
}
