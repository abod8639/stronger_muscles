import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/features/help_support/data/datasources/help_support_local_data_source.dart';
import 'package:stronger_muscles/features/help_support/data/models/support_ticket_model.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/faq_entity.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_channel_entity.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_ticket_entity.dart';
import 'package:stronger_muscles/features/help_support/domain/repositories/help_support_repository.dart';
import 'package:stronger_muscles/features/help_support/domain/usecases/get_faqs_usecase.dart';
import 'package:stronger_muscles/features/help_support/domain/usecases/get_support_channels_usecase.dart';
import 'package:stronger_muscles/features/help_support/domain/usecases/submit_ticket_usecase.dart';

class HelpSupportRepositoryImpl implements HelpSupportRepository {
  final HelpSupportLocalDataSource _dataSource;

  HelpSupportRepositoryImpl(this._dataSource);

  @override
  Future<List<FaqEntity>> getFaqs({FaqCategory? category, String? query}) async {
    final models = await _dataSource.getFaqs(category: category, query: query);
    return models;
  }

  @override
  Future<List<SupportChannelEntity>> getSupportChannels() async {
    final channels = await _dataSource.getSupportChannels();
    return channels;
  }

  @override
  Future<SupportTicketEntity> submitTicket(SupportTicketEntity ticket) async {
    final model = SupportTicketModel.fromEntity(ticket);
    final result = await _dataSource.submitTicket(model);
    return result;
  }
}

// ── Riverpod Dependency Injection Providers ──────────────────────────────────

final helpSupportDataSourceProvider = Provider<HelpSupportLocalDataSource>((ref) {
  return HelpSupportLocalDataSourceImpl();
});

final helpSupportRepositoryProvider = Provider<HelpSupportRepository>((ref) {
  final dataSource = ref.watch(helpSupportDataSourceProvider);
  return HelpSupportRepositoryImpl(dataSource);
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
