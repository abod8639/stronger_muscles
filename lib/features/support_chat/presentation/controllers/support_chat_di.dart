import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/core/services/websocket_service.dart';
import '../../data/datasources/support_chat_remote_data_source.dart';
import '../../data/repositories/support_chat_repository_impl.dart';
import '../../domain/repositories/support_chat_repository.dart';
import '../../domain/usecases/close_ticket_chat_usecase.dart';
import '../../domain/usecases/get_ticket_chat_details_usecase.dart';
import '../../domain/usecases/send_ticket_chat_message_usecase.dart';
import 'support_chat_controller.dart';

// ── Data Layer Providers ─────────────────────────────────────────────────────

final supportChatRemoteDataSourceProvider =
    Provider<SupportChatRemoteDataSource>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return SupportChatRemoteDataSourceImpl(apiService);
});

final supportChatRepositoryProvider = Provider<SupportChatRepository>((ref) {
  final remoteDataSource = ref.watch(supportChatRemoteDataSourceProvider);
  return SupportChatRepositoryImpl(remoteDataSource);
});

// ── Domain UseCase Providers ─────────────────────────────────────────────────

final getTicketChatDetailsUseCaseProvider =
    Provider<GetTicketChatDetailsUseCase>((ref) {
  final repository = ref.watch(supportChatRepositoryProvider);
  return GetTicketChatDetailsUseCase(repository);
});

final sendTicketChatMessageUseCaseProvider =
    Provider<SendTicketChatMessageUseCase>((ref) {
  final repository = ref.watch(supportChatRepositoryProvider);
  return SendTicketChatMessageUseCase(repository);
});

final closeTicketChatUseCaseProvider = Provider<CloseTicketChatUseCase>((ref) {
  final repository = ref.watch(supportChatRepositoryProvider);
  return CloseTicketChatUseCase(repository);
});

// ── Presentation Controller Provider (Family autoDispose) ───────────────────

final supportChatControllerProvider = StateNotifierProvider.autoDispose
    .family<SupportChatNotifier, SupportChatState, String>((ref, ticketId) {
  final getTicketDetailsUseCase =
      ref.watch(getTicketChatDetailsUseCaseProvider);
  final sendMessageUseCase = ref.watch(sendTicketChatMessageUseCaseProvider);
  final closeTicketUseCase = ref.watch(closeTicketChatUseCaseProvider);
  final webSocketService = ref.watch(webSocketServiceProvider);

  return SupportChatNotifier(
    ticketId: ticketId,
    getTicketDetailsUseCase: getTicketDetailsUseCase,
    sendMessageUseCase: sendMessageUseCase,
    closeTicketUseCase: closeTicketUseCase,
    webSocketService: webSocketService,
  );
});

