import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/api_service.dart';
import '../../data/datasources/help_support_local_data_source.dart';
import '../../data/datasources/help_support_remote_data_source.dart';
import '../../data/repositories/help_support_repository_impl.dart';
import '../../domain/repositories/help_support_repository.dart';
import '../../domain/usecases/close_ticket_usecase.dart';
import '../../domain/usecases/get_faqs_usecase.dart';
import '../../domain/usecases/get_support_channels_usecase.dart';
import '../../domain/usecases/get_ticket_details_usecase.dart';
import '../../domain/usecases/get_user_tickets_usecase.dart';
import '../../domain/usecases/send_ticket_message_usecase.dart';
import '../../domain/usecases/submit_ticket_usecase.dart';

// ── Data Layer Providers ─────────────────────────────────────────────────────

final helpSupportLocalDataSourceProvider =
    Provider<HelpSupportLocalDataSource>((ref) {
  return HelpSupportLocalDataSourceImpl();
});

final helpSupportRemoteDataSourceProvider =
    Provider<HelpSupportRemoteDataSource>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return HelpSupportRemoteDataSourceImpl(apiService);
});

final helpSupportRepositoryProvider = Provider<HelpSupportRepository>((ref) {
  final localDataSource = ref.watch(helpSupportLocalDataSourceProvider);
  final remoteDataSource = ref.watch(helpSupportRemoteDataSourceProvider);
  return HelpSupportRepositoryImpl(localDataSource, remoteDataSource);
});

// ── Domain UseCase Providers ─────────────────────────────────────────────────

final getFaqsUseCaseProvider = Provider<GetFaqsUseCase>((ref) {
  final repository = ref.watch(helpSupportRepositoryProvider);
  return GetFaqsUseCase(repository);
});

final getSupportChannelsUseCaseProvider =
    Provider<GetSupportChannelsUseCase>((ref) {
  final repository = ref.watch(helpSupportRepositoryProvider);
  return GetSupportChannelsUseCase(repository);
});

final submitTicketUseCaseProvider = Provider<SubmitTicketUseCase>((ref) {
  final repository = ref.watch(helpSupportRepositoryProvider);
  return SubmitTicketUseCase(repository);
});

final getUserTicketsUseCaseProvider = Provider<GetUserTicketsUseCase>((ref) {
  final repository = ref.watch(helpSupportRepositoryProvider);
  return GetUserTicketsUseCase(repository);
});

final getTicketDetailsUseCaseProvider =
    Provider<GetTicketDetailsUseCase>((ref) {
  final repository = ref.watch(helpSupportRepositoryProvider);
  return GetTicketDetailsUseCase(repository);
});

final sendTicketMessageUseCaseProvider =
    Provider<SendTicketMessageUseCase>((ref) {
  final repository = ref.watch(helpSupportRepositoryProvider);
  return SendTicketMessageUseCase(repository);
});

final closeTicketUseCaseProvider = Provider<CloseTicketUseCase>((ref) {
  final repository = ref.watch(helpSupportRepositoryProvider);
  return CloseTicketUseCase(repository);
});
