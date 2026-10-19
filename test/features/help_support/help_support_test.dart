import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/help_support/data/datasources/help_support_local_data_source.dart';
import 'package:stronger_muscles/features/help_support/data/datasources/help_support_remote_data_source.dart';
import 'package:stronger_muscles/features/help_support/data/models/faq_model.dart';
import 'package:stronger_muscles/features/help_support/data/models/support_message_model.dart';
import 'package:stronger_muscles/features/help_support/data/models/support_ticket_model.dart';
import 'package:stronger_muscles/features/help_support/data/repositories/help_support_repository_impl.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/faq_entity.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_channel_entity.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_ticket_entity.dart';
import 'package:stronger_muscles/features/help_support/domain/usecases/get_faqs_usecase.dart';
import 'package:stronger_muscles/features/help_support/domain/usecases/get_support_channels_usecase.dart';
import 'package:stronger_muscles/features/help_support/domain/usecases/submit_ticket_usecase.dart';
import 'package:stronger_muscles/features/help_support/presentation/controllers/help_support_controller.dart';

class MockHelpSupportRemoteDataSource implements HelpSupportRemoteDataSource {
  @override
  Future<SupportTicketModel> submitTicket(SupportTicketModel ticket) async =>
      SupportTicketModel(
        id: 'SM-123456',
        ticketNumber: 'SM-123456',
        subject: ticket.subject,
        category: ticket.category,
        message: ticket.message,
        createdAt: ticket.createdAt,
      );

  @override
  Future<List<SupportTicketModel>> getUserTickets() async => [];

  @override
  Future<SupportTicketModel> getTicketDetails(String ticketId) async =>
      SupportTicketModel(
        id: ticketId,
        subject: 'Test',
        category: 'Orders',
        message: 'Message',
        createdAt: DateTime.now(),
      );

  @override
  Future<SupportMessageModel> sendTicketMessage(String ticketId, String message) async =>
      SupportMessageModel(
        id: 1,
        ticketId: int.tryParse(ticketId) ?? 1,
        senderType: 'user',
        senderName: 'User',
        message: message,
        createdAt: DateTime.now(),
      );

  @override
  Future<SupportTicketModel> closeTicket(String ticketId) async =>
      SupportTicketModel(
        id: ticketId,
        subject: 'Test',
        category: 'Orders',
        message: 'Message',
        status: 'closed',
        createdAt: DateTime.now(),
      );
}

void main() {
  group('Core Theme Tokens', () {
    test('AppRadius has consistent radii tokens', () {
      expect(AppRadius.xs, 4.0);
      expect(AppRadius.sm, 8.0);
      expect(AppRadius.md, 12.0);
      expect(AppRadius.lg, 16.0);
      expect(AppRadius.xl, 24.0);
      expect(AppRadius.bottomSheet, 28.0);
      expect(AppRadius.pill, 999.0);
      expect(AppRadius.allLg.topLeft.x, 16.0);
    });

    test('AppShadows generates valid box shadows', () {
      final cardShadow = AppShadows.card();
      expect(cardShadow.isNotEmpty, true);
      expect(cardShadow.first.blurRadius, 15.0);

      final subtleShadow = AppShadows.subtle();
      expect(subtleShadow.isNotEmpty, true);
    });
  });

  group('Help & Support Clean Architecture', () {
    late HelpSupportLocalDataSource dataSource;
    late HelpSupportRepositoryImpl repository;
    late HelpSupportRemoteDataSource remoteDataSource;
    late GetFaqsUseCase getFaqsUseCase;
    late GetSupportChannelsUseCase getChannelsUseCase;
    late SubmitTicketUseCase submitTicketUseCase;

    setUp(() {
      dataSource = HelpSupportLocalDataSourceImpl();
      remoteDataSource = MockHelpSupportRemoteDataSource();
      repository = HelpSupportRepositoryImpl(dataSource, remoteDataSource);
      getFaqsUseCase = GetFaqsUseCase(repository);
      getChannelsUseCase = GetSupportChannelsUseCase(repository);
      submitTicketUseCase = SubmitTicketUseCase(repository);
    });

    test('getFaqs returns list of FAQs', () async {
      final faqs = await getFaqsUseCase();
      expect(faqs.isNotEmpty, true);
      expect(faqs.any((f) => f.category == FaqCategory.ordersShipping), true);
    });

    test('getFaqs filters by category correctly', () async {
      final supplementFaqs = await getFaqsUseCase(category: FaqCategory.supplements);
      expect(supplementFaqs.isNotEmpty, true);
      for (final faq in supplementFaqs) {
        expect(faq.category, FaqCategory.supplements);
      }
    });

    test('getFaqs searches by query correctly', () async {
      final results = await getFaqsUseCase(query: 'تتبع');
      expect(results.isNotEmpty, true);
      expect(results.first.questionAr.contains('تتبع'), true);
    });

    test('getSupportChannels returns the 4 standard channels', () async {
      final channels = await getChannelsUseCase();
      expect(channels.length, 4);
      expect(channels.any((c) => c.type == SupportChannelType.whatsapp), true);
      expect(channels.any((c) => c.type == SupportChannelType.phone), true);
      expect(channels.any((c) => c.type == SupportChannelType.email), true);
      expect(channels.any((c) => c.type == SupportChannelType.ticket), true);
    });

    test('submitTicket creates and returns a ticket with valid id', () async {
      final ticket = SupportTicketEntity(
        subject: 'استفسار عن الشحنة',
        category: 'الطلبات',
        message: 'طلبي لم يصل بعد وأريد الاستفسار عن الموعد',
        priority: TicketPriority.urgent,
        createdAt: DateTime.now(),
      );

      final result = await submitTicketUseCase(ticket);
      expect(result.id, isNotNull);
      expect(result.id!.startsWith('SM-'), true);
      expect(result.subject, ticket.subject);
    });

    test('HelpSupportNotifier loads initial data and filters properly', () async {
      final notifier = HelpSupportNotifier(
        getFaqsUseCase: getFaqsUseCase,
        getChannelsUseCase: getChannelsUseCase,
        submitTicketUseCase: submitTicketUseCase,
        repository: repository,
      );

      // Await initial load
      await Future.delayed(const Duration(milliseconds: 300));
      expect(notifier.state.isLoading, false);
      expect(notifier.state.faqs.isNotEmpty, true);
      expect(notifier.state.channels.isNotEmpty, true);

      // Change category
      await notifier.selectCategory(FaqCategory.paymentRefunds);
      expect(notifier.state.selectedCategory, FaqCategory.paymentRefunds);
      for (final f in notifier.state.faqs) {
        expect(f.category, FaqCategory.paymentRefunds);
      }

      // Search
      await notifier.search('policy');
      expect(notifier.state.searchQuery, 'policy');

      // Submit ticket through controller
      final ticket = await notifier.submitTicket(
        subject: 'مشكلة دفع',
        category: 'الدفع والاسترجاع',
        message: 'تم خصم المبلغ مرتين من حسابي',
      );
      expect(ticket, isNotNull);
      expect(notifier.state.lastSubmittedTicketId, ticket!.id);
    });

    test('FaqModel toJson and fromJson match', () {
      const model = FaqModel(
        id: 'faq_test',
        questionEn: 'Is this a test?',
        questionAr: 'هل هذا اختبار؟',
        answerEn: 'Yes, it is.',
        answerAr: 'نعم، هو كذلك.',
        category: FaqCategory.accountGeneral,
        tags: ['test'],
      );

      final json = model.toJson();
      final fromJson = FaqModel.fromJson(json);

      expect(fromJson.id, model.id);
      expect(fromJson.questionEn, model.questionEn);
      expect(fromJson.questionAr, model.questionAr);
      expect(fromJson.category, model.category);
    });
  });
}
