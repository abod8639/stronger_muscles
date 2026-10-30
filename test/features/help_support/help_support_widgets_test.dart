import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/faq_entity.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_ticket_entity.dart';
import 'package:stronger_muscles/features/help_support/presentation/widgets/faq_list_section.dart';
import 'package:stronger_muscles/features/help_support/presentation/widgets/still_need_help_card.dart';
import 'package:stronger_muscles/features/help_support/presentation/widgets/support_ticket_card.dart';
import 'package:stronger_muscles/features/help_support/presentation/widgets/ticket_success_dialog.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

Widget _wrap(Widget child) => MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );

final _ticket = SupportTicketEntity(
  id: 't1',
  ticketNumber: 'TK-100',
  subject: 'Late order',
  category: 'الطلبات والتوصيل',
  message: 'My order is late',
  status: 'in_progress',
  createdAt: DateTime(2026, 10, 1),
  unreadMessagesCount: 2,
);

void main() {
  testWidgets('FaqListSection shows empty state with reset action', (tester) async {
    var reset = false;
    await tester.pumpWidget(
      _wrap(ListView(children: [FaqListSection(faqs: const [], onResetSearch: () => reset = true)])),
    );

    expect(find.text('No matching questions found'), findsOneWidget);
    await tester.tap(find.text('Reset search'));
    expect(reset, isTrue);
  });

  testWidgets('FaqListSection renders questions with category badge', (tester) async {
    await tester.pumpWidget(
      _wrap(
        ListView(
          children: const [
            FaqListSection(
              faqs: [
                FaqEntity(
                  id: '1',
                  questionEn: 'How long is shipping?',
                  questionAr: 'كم مدة الشحن؟',
                  answerEn: '2 days',
                  answerAr: 'يومان',
                  category: FaqCategory.ordersShipping,
                ),
              ],
            ),
          ],
        ),
      ),
    );

    expect(find.text('How long is shipping?'), findsOneWidget);
  });

  testWidgets('StillNeedHelpCard hides "My tickets" without tickets', (tester) async {
    await tester.pumpWidget(
      _wrap(ListView(children: [StillNeedHelpCard(onSubmitTicket: () {})])),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('My Tickets'), findsNothing);
  });

  testWidgets('SupportTicketCard shows number, status and unread badge', (tester) async {
    await tester.pumpWidget(_wrap(SupportTicketCard(ticket: _ticket, onTap: () {})));

    expect(find.text('TK-100'), findsOneWidget);
    expect(find.text(_ticket.statusArabic), findsOneWidget);
    expect(find.text('New reply'), findsOneWidget);
  });

  testWidgets('TicketSuccessDialog shows the ticket number', (tester) async {
    await tester.pumpWidget(_wrap(TicketSuccessDialog(ticket: _ticket)));

    expect(tester.takeException(), isNull);
    expect(find.text('Ticket #TK-100'), findsOneWidget);
    expect(find.text('Open Ticket'), findsOneWidget);
  });
}
