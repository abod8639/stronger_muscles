import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/features/help_support/data/datasources/help_support_local_data_source.dart';
import 'package:stronger_muscles/features/help_support/data/datasources/help_support_remote_data_source.dart';
import 'package:stronger_muscles/features/help_support/data/models/support_ticket_model.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/faq_entity.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_channel_entity.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_message_entity.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_ticket_entity.dart';
import 'package:stronger_muscles/features/help_support/domain/repositories/help_support_repository.dart';
import 'package:stronger_muscles/features/help_support/domain/usecases/get_faqs_usecase.dart';
import 'package:stronger_muscles/features/help_support/domain/usecases/get_support_channels_usecase.dart';
import 'package:stronger_muscles/features/help_support/domain/usecases/submit_ticket_usecase.dart';

class HelpSupportRepositoryImpl implements HelpSupportRepository {
  final HelpSupportLocalDataSource _localDataSource;
  final HelpSupportRemoteDataSource _remoteDataSource;

  HelpSupportRepositoryImpl(this._localDataSource, this._remoteDataSource);

  @override
  Future<List<FaqEntity>> getFaqs({FaqCategory? category, String? query}) async {
    return await _localDataSource.getFaqs(category: category, query: query);
  }

  @override
  Future<List<SupportChannelEntity>> getSupportChannels() async {
    return await _localDataSource.getSupportChannels();
  }

  @override
  Future<SupportTicketEntity> submitTicket(SupportTicketEntity ticket) async {
    final model = SupportTicketModel.fromEntity(ticket);
    try {
      final remoteTicket = await _remoteDataSource.submitTicket(model);
      return remoteTicket;
    } catch (_) {
      // Fallback to local simulation if offline
      return await _localDataSource.submitTicket(model);
    }
  }

  @override
  Future<List<SupportTicketEntity>> getUserTickets() async {
    return await _remoteDataSource.getUserTickets();
  }

  @override
  Future<SupportTicketEntity> getTicketDetails(String ticketId) async {
    return await _remoteDataSource.getTicketDetails(ticketId);
  }

  @override
  Future<SupportMessageEntity> sendTicketMessage(String ticketId, String message) async {
    return await _remoteDataSource.sendTicketMessage(ticketId, message);
  }

  @override
  Future<SupportTicketEntity> closeTicket(String ticketId) async {
    return await _remoteDataSource.closeTicket(ticketId);
  }
}

// ── Riverpod Dependency Injection Providers ──────────────────────────────────

final helpSupportLocalDataSourceProvider = Provider<HelpSupportLocalDataSource>((ref) {
  return HelpSupportLocalDataSourceImpl();
});

final helpSupportRemoteDataSourceProvider = Provider<HelpSupportRemoteDataSource>((ref) {
  final api = ref.watch(apiServiceProvider);
  return HelpSupportRemoteDataSourceImpl(api);
});

final helpSupportRepositoryProvider = Provider<HelpSupportRepository>((ref) {
  final localDataSource = ref.watch(helpSupportLocalDataSourceProvider);
  final remoteDataSource = ref.watch(helpSupportRemoteDataSourceProvider);
  return HelpSupportRepositoryImpl(localDataSource, remoteDataSource);
});

final getFaqsUseCaseProvider = Provider<GetFaqsUseCase>((ref) {
  final repo = ref.watch(helpSupportRepositoryProvider);
  return GetFaqsUseCase(repo);
});

final getSupportChannelsUseCaseProvider = Provider<GetSupportChannelsUseCase>((ref) {
  final repo = ref.watch(helpSupportRepositoryProvider);
  return GetSupportChannelsUseCase(repo);
});

final submitTicketUseCaseProvider = Provider<SubmitTicketUseCase>((ref) {
  final repo = ref.watch(helpSupportRepositoryProvider);
  return SubmitTicketUseCase(repo);
});
