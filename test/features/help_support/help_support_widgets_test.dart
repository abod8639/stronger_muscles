import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/core/auth/auth_state_provider.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/core/utils/functions/app_guard.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/faq_entity.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_channel_entity.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_message_entity.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_ticket_entity.dart';
import 'package:stronger_muscles/features/help_support/domain/repositories/help_support_repository.dart';
import 'package:stronger_muscles/features/help_support/domain/usecases/get_faqs_usecase.dart';
import 'package:stronger_muscles/features/help_support/domain/usecases/get_support_channels_usecase.dart';
import 'package:stronger_muscles/features/help_support/domain/usecases/get_user_tickets_usecase.dart';
import 'package:stronger_muscles/features/help_support/presentation/controllers/help_support_di.dart';
import 'package:stronger_muscles/features/help_support/presentation/pages/help_support_view.dart';
import 'package:stronger_muscles/features/help_support/presentation/widgets/faq_list_section.dart';
import 'package:stronger_muscles/features/help_support/presentation/widgets/my_tickets_sheet.dart';
import 'package:stronger_muscles/features/help_support/presentation/widgets/still_need_help_card.dart';
import 'package:stronger_muscles/features/help_support/presentation/widgets/submit_ticket_bottom_sheet.dart';
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

  testWidgets('HelpSupportView prevents unauthenticated user from opening a ticket', (tester) async {
    bool unauthTriggered = false;
    registerAuthStateChecker((_) => false);
    registerUnauthenticatedHandler((_) => unauthTriggered = true);

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HelpSupportView(),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authStateProvider.overrideWithValue(false),
          getFaqsUseCaseProvider.overrideWithValue(GetFaqsUseCase(FakeHelpSupportRepository())),
          getSupportChannelsUseCaseProvider.overrideWithValue(GetSupportChannelsUseCase(FakeHelpSupportRepository())),
          getUserTicketsUseCaseProvider.overrideWithValue(GetUserTicketsUseCase(FakeHelpSupportRepository())),
        ],
        child: MaterialApp.router(
          routerConfig: router,
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Tap the Support Ticket channel
    final ticketChannel = find.text('Support Ticket');
    expect(ticketChannel, findsOneWidget);
    await tester.tap(ticketChannel);
    await tester.pump();

    // Verify unauthenticated handler was triggered and bottom sheet was NOT opened
    expect(unauthTriggered, isTrue);
    expect(find.byType(SubmitTicketBottomSheet), findsNothing);

    // Reset flag and test MyTickets button in AppBar
    unauthTriggered = false;
    final myTicketsIcon = find.byTooltip('My Tickets');
    expect(myTicketsIcon, findsOneWidget);
    await tester.tap(myTicketsIcon);
    await tester.pump();

    expect(unauthTriggered, isTrue);
    expect(find.byType(MyTicketsSheet), findsNothing);
  });
}

class FakeHelpSupportRepository implements HelpSupportRepository {
  @override
  Future<Either<Failure, List<FaqEntity>>> getFaqs({FaqCategory? category, String? query}) async =>
      const Right(<FaqEntity>[]);
  @override
  Future<Either<Failure, List<SupportChannelEntity>>> getSupportChannels() async =>
      const Right(<SupportChannelEntity>[
        SupportChannelEntity(
          id: '1',
          type: SupportChannelType.ticket,
          titleAr: 'تذكرة دعم',
          titleEn: 'Support Ticket',
          subtitleAr: 'فريق الدعم الفني',
          subtitleEn: 'Technical Support',
          actionValue: '',
          availabilityAr: 'متاح دائماً',
          availabilityEn: '24/7',
        ),
      ]);
  @override
  Future<Either<Failure, SupportTicketEntity>> submitTicket(SupportTicketEntity ticket) async =>
      Right(ticket);
  @override
  Future<Either<Failure, List<SupportTicketEntity>>> getUserTickets() async =>
      const Right(<SupportTicketEntity>[]);
  @override
  Future<Either<Failure, SupportTicketEntity>> getTicketDetails(String ticketId) async =>
      Right(_ticket);
  @override
  Future<Either<Failure, SupportMessageEntity>> sendTicketMessage({
    required String ticketId,
    required String message,
  }) async =>
      throw UnimplementedError();
  @override
  Future<Either<Failure, SupportTicketEntity>> closeTicket(String ticketId) async =>
      throw UnimplementedError();
}
