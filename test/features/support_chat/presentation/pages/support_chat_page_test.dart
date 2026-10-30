import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_message_entity.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_ticket_entity.dart';
import 'package:stronger_muscles/features/support_chat/domain/repositories/support_chat_repository.dart';
import 'package:stronger_muscles/features/support_chat/presentation/controllers/support_chat_di.dart';
import 'package:stronger_muscles/features/support_chat/presentation/pages/support_chat_page.dart';

class FakeSupportChatRepository implements SupportChatRepository {
  String? sentText;

  @override
  Future<Either<Failure, SupportTicketEntity>> getTicketDetails(
      String ticketId) async {
    return Right(
      SupportTicketEntity(
        id: ticketId,
        ticketNumber: 'SM-TICKET-99',
        subject: 'مشكلة تجريبية',
        category: 'الطلبات',
        message: 'رسالة البداية',
        status: 'open',
        createdAt: DateTime.now(),
        messages: [
          SupportMessageEntity(
            id: 1,
            ticketId: 99,
            senderType: 'admin',
            senderName: 'الدعم الفني',
            message: 'مرحباً، كيف نساعدك؟',
            createdAt: DateTime.now(),
          ),
          SupportMessageEntity(
            id: 2,
            ticketId: 99,
            senderType: 'user',
            senderName: 'المستخدم',
            message: 'أريد الاستفسار عن الشحنة',
            createdAt: DateTime.now(),
          ),
        ],
      ),
    );
  }

  @override
  Future<Either<Failure, SupportMessageEntity>> sendMessage({
    required String ticketId,
    required String message,
  }) async {
    sentText = message;
    return Right(
      SupportMessageEntity(
        id: 3,
        ticketId: int.tryParse(ticketId) ?? 99,
        senderType: 'user',
        senderName: 'المستخدم',
        message: message,
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<Either<Failure, SupportTicketEntity>> closeTicket(
      String ticketId) async {
    return Right(
      SupportTicketEntity(
        id: ticketId,
        subject: 'مشكلة تجريبية',
        category: 'الطلبات',
        message: 'رسالة البداية',
        status: 'closed',
        createdAt: DateTime.now(),
      ),
    );
  }
}

void main() {
  testWidgets('SupportChatPage renders ticket details, messages, and allows sending replies', (tester) async {
    final fakeRepo = FakeSupportChatRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          supportChatRepositoryProvider.overrideWithValue(fakeRepo),
        ],
        child: const MaterialApp(
          home: SupportChatPage(ticketId: '99'),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify header and subject
    expect(find.text('SM-TICKET-99'), findsOneWidget);
    expect(find.text('مشكلة تجريبية'), findsOneWidget);

    // Verify messages
    expect(find.text('مرحباً، كيف نساعدك؟'), findsOneWidget);
    expect(find.text('أريد الاستفسار عن الشحنة'), findsOneWidget);

    // Enter message in input bar and submit
    final inputFinder = find.byType(TextField);
    expect(inputFinder, findsOneWidget);
    await tester.enterText(inputFinder, 'رسالة تجربة جديدة');
    await tester.pump();

    final sendFinder = find.byIcon(Icons.send_rounded);
    expect(sendFinder, findsOneWidget);
    await tester.tap(sendFinder);
    await tester.pumpAndSettle();

    expect(fakeRepo.sentText, 'رسالة تجربة جديدة');
  });
}

