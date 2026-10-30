import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/core/theme/theme.dart';
import 'package:stronger_muscles/features/help_support/data/datasources/help_support_local_data_source.dart';
import 'package:stronger_muscles/features/help_support/data/datasources/help_support_remote_data_source.dart';
import 'package:stronger_muscles/features/help_support/data/mappers/help_support_mapper.dart';
import 'package:stronger_muscles/features/help_support/data/models/faq_model.dart';
import 'package:stronger_muscles/features/help_support/data/models/support_channel_model.dart';
import 'package:stronger_muscles/features/help_support/data/models/support_message_model.dart';
import 'package:stronger_muscles/features/help_support/data/models/support_ticket_model.dart';
import 'package:stronger_muscles/features/help_support/data/repositories/help_support_repository_impl.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/faq_entity.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_channel_entity.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_ticket_entity.dart';
import 'package:stronger_muscles/features/help_support/domain/usecases/close_ticket_usecase.dart';
import 'package:stronger_muscles/features/help_support/domain/usecases/get_faqs_usecase.dart';
import 'package:stronger_muscles/features/help_support/domain/usecases/get_support_channels_usecase.dart';
import 'package:stronger_muscles/features/help_support/domain/usecases/get_ticket_details_usecase.dart';
import 'package:stronger_muscles/features/help_support/domain/usecases/get_user_tickets_usecase.dart';
import 'package:stronger_muscles/features/help_support/domain/usecases/send_ticket_message_usecase.dart';
import 'package:stronger_muscles/features/help_support/domain/usecases/submit_ticket_usecase.dart';
import 'package:stronger_muscles/features/help_support/presentation/controllers/help_support_controller.dart';

class MockHelpSupportRemoteDataSource implements HelpSupportRemoteDataSource {
  bool shouldThrow = false;

  @override
  Future<SupportTicketModel> submitTicket(SupportTicketModel ticket) async {
    if (shouldThrow) {
      throw Exception('Server error');
    }
    return SupportTicketModel(
      id: 'SM-123456',
      ticketNumber: 'SM-123456',
      subject: ticket.subject,
      category: ticket.category,
      message: ticket.message,
      createdAt: ticket.createdAt,
    );
  }

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
  Future<SupportMessageModel> sendTicketMessage(
    String ticketId,
    String message,
  ) async =>
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
    late Directory tempDir;
    late HelpSupportLocalDataSource dataSource;
    late HelpSupportRepositoryImpl repository;
    late MockHelpSupportRemoteDataSource remoteDataSource;
    late GetFaqsUseCase getFaqsUseCase;
    late GetSupportChannelsUseCase getChannelsUseCase;
    late SubmitTicketUseCase submitTicketUseCase;
    late GetUserTicketsUseCase getUserTicketsUseCase;
    late GetTicketDetailsUseCase getTicketDetailsUseCase;
    late SendTicketMessageUseCase sendTicketMessageUseCase;
    late CloseTicketUseCase closeTicketUseCase;

    setUpAll(() async {
      tempDir = await Directory.systemTemp.createTemp('hive_help_support_test_');
      Hive.init(tempDir.path);
    });

    tearDownAll(() async {
      await Hive.close();
      if (tempDir.existsSync()) {
        await tempDir.delete(recursive: true);
      }
    });

    setUp(() {
      dataSource = HelpSupportLocalDataSourceImpl();
      remoteDataSource = MockHelpSupportRemoteDataSource();
      repository = HelpSupportRepositoryImpl(dataSource, remoteDataSource);
      getFaqsUseCase = GetFaqsUseCase(repository);
      getChannelsUseCase = GetSupportChannelsUseCase(repository);
      submitTicketUseCase = SubmitTicketUseCase(repository);
      getUserTicketsUseCase = GetUserTicketsUseCase(repository);
      getTicketDetailsUseCase = GetTicketDetailsUseCase(repository);
      sendTicketMessageUseCase = SendTicketMessageUseCase(repository);
      closeTicketUseCase = CloseTicketUseCase(repository);
    });

    test('getFaqs returns Either Right with list of FAQs', () async {
      final result = await getFaqsUseCase();
      expect(result.isRight(), true);
      final faqs = result.getOrElse((_) => []);
      expect(faqs.isNotEmpty, true);
      expect(faqs.any((f) => f.category == FaqCategory.ordersShipping), true);
    });

    test('getFaqs filters by category correctly', () async {
      final result = await getFaqsUseCase(category: FaqCategory.supplements);
      expect(result.isRight(), true);
      final supplementFaqs = result.getOrElse((_) => []);
      expect(supplementFaqs.isNotEmpty, true);
      for (final faq in supplementFaqs) {
        expect(faq.category, FaqCategory.supplements);
      }
    });

    test('getFaqs searches by query correctly', () async {
      final result = await getFaqsUseCase(query: 'تتبع');
      expect(result.isRight(), true);
      final results = result.getOrElse((_) => []);
      expect(results.isNotEmpty, true);
      expect(results.first.questionAr.contains('تتبع'), true);
    });

    test('getSupportChannels returns Either Right with the 4 standard channels', () async {
      final result = await getChannelsUseCase();
      expect(result.isRight(), true);
      final channels = result.getOrElse((_) => []);
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
      expect(result.isRight(), true);
      final created = result.getOrElse((_) => ticket);
      expect(created.id, isNotNull);
      expect(created.id!.startsWith('SM-'), true);
      expect(created.subject, ticket.subject);
    });

    test('HelpSupportNotifier loads initial data and filters properly', () async {
      final notifier = HelpSupportNotifier(
        getFaqsUseCase: getFaqsUseCase,
        getChannelsUseCase: getChannelsUseCase,
        submitTicketUseCase: submitTicketUseCase,
        getUserTicketsUseCase: getUserTicketsUseCase,
        getTicketDetailsUseCase: getTicketDetailsUseCase,
        sendTicketMessageUseCase: sendTicketMessageUseCase,
        closeTicketUseCase: closeTicketUseCase,
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

    test('HelpSupportNotifier enforces submission guard clauses', () async {
      final notifier = HelpSupportNotifier(
        getFaqsUseCase: getFaqsUseCase,
        getChannelsUseCase: getChannelsUseCase,
        submitTicketUseCase: submitTicketUseCase,
        getUserTicketsUseCase: getUserTicketsUseCase,
        getTicketDetailsUseCase: getTicketDetailsUseCase,
        sendTicketMessageUseCase: sendTicketMessageUseCase,
        closeTicketUseCase: closeTicketUseCase,
      );

      await Future.delayed(const Duration(milliseconds: 100));

      // Test message sending with empty string returns false
      final sentEmpty = await notifier.sendReplyMessage('SM-123', '   ');
      expect(sentEmpty, false);
    });

    test('HelpSupportNotifier loadTicketDetails with isSilentRefresh preserves UI without flashing AsyncLoading', () async {
      final notifier = HelpSupportNotifier(
        getFaqsUseCase: getFaqsUseCase,
        getChannelsUseCase: getChannelsUseCase,
        submitTicketUseCase: submitTicketUseCase,
        getUserTicketsUseCase: getUserTicketsUseCase,
        getTicketDetailsUseCase: getTicketDetailsUseCase,
        sendTicketMessageUseCase: sendTicketMessageUseCase,
        closeTicketUseCase: closeTicketUseCase,
      );

      await Future.delayed(const Duration(milliseconds: 100));

      // 1. Initial load sets AsyncLoading then AsyncData
      await notifier.loadTicketDetails('SM-100');
      expect(notifier.state.selectedTicket, isNotNull);
      expect(notifier.state.selectedTicket!.messages.length, 0);

      // 2. Silent refresh keeps state as AsyncData without resetting to AsyncLoading
      final future = notifier.loadTicketDetails('SM-100', isSilentRefresh: true);
      // Immediately verify that state is NOT AsyncLoading
      expect(notifier.state.selectedTicketState.isLoading, isFalse);
      await future;
      expect(notifier.state.selectedTicket, isNotNull);
    });

    test('FaqModel and FaqMapper convert bidirectionally', () {
      const model = FaqModel(
        id: 'faq_test',
        questionEn: 'Is this a test?',
        questionAr: 'هل هذا اختبار؟',
        answerEn: 'Yes, it is.',
        answerAr: 'نعم، هو كذلك.',
        category: 'accountGeneral',
        tags: ['test'],
      );

      final json = model.toJson();
      final fromJson = FaqModel.fromJson(json);

      expect(fromJson.id, model.id);
      expect(fromJson.questionEn, model.questionEn);
      expect(fromJson.questionAr, model.questionAr);
      expect(fromJson.category, model.category);

      // Null handling
      final emptyJson = FaqModel.fromJson(const {});
      expect(emptyJson.id, '');
      expect(emptyJson.questionEn, '');
      expect(emptyJson.category, 'ordersShipping');

      // Mapper test
      final entity = model.toEntity();
      expect(entity.id, model.id);
      expect(entity.category, FaqCategory.accountGeneral);

      final backToModel = entity.toModel();
      expect(backToModel.id, model.id);
      expect(backToModel.category, 'accountGeneral');
    });

    test('SupportTicketModel and Mapper handle raw types safely', () {
      final model = SupportTicketModel.fromJson({
        'id': 100,
        'subject': 'Ticket 100',
        'messages': [
          {
            'id': 1,
            'ticket_id': 100,
            'sender_type': 'user',
            'sender_name': 'Tester',
            'message': 'Hello',
            'created_at': DateTime.now().toIso8601String(),
          }
        ],
      });

      expect(model.id, '100');
      expect(model.messages.length, 1);
      expect(model.messages.first.message, 'Hello');

      final entity = model.toEntity();
      expect(entity.id, '100');
      expect(entity.messages.first.message, 'Hello');

      final backModel = entity.toModel();
      expect(backModel.id, '100');
      expect(backModel.messages.first.message, 'Hello');
    });

    test('SupportChannelModel and Mapper convert bidirectionally', () {
      const channelModel = SupportChannelModel(
        id: 'c1',
        type: 'whatsapp',
        titleEn: 'WhatsApp',
        titleAr: 'واتساب',
        subtitleEn: 'Chat',
        subtitleAr: 'دردشة',
        actionValue: 'https://wa.me/123',
        availabilityEn: '24/7',
        availabilityAr: '24/7',
        isAvailable: true,
      );

      final entity = channelModel.toEntity();
      expect(entity.type, SupportChannelType.whatsapp);

      final backModel = entity.toModel();
      expect(backModel.type, 'whatsapp');
    });
  });
}
