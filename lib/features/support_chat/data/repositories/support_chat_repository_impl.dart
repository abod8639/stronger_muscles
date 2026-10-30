import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/core/errors/network_error_handler.dart';
import 'package:stronger_muscles/features/help_support/data/mappers/help_support_mapper.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_message_entity.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_ticket_entity.dart';
import '../../domain/repositories/support_chat_repository.dart';
import '../datasources/support_chat_remote_data_source.dart';

class SupportChatRepositoryImpl implements SupportChatRepository {
  final SupportChatRemoteDataSource _remoteDataSource;

  const SupportChatRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, SupportTicketEntity>> getTicketDetails(
    String ticketId,
  ) {
    return NetworkErrorHandler.execute<SupportTicketEntity>(() async {
      final model = await _remoteDataSource.getTicketDetails(ticketId);
      return model.toEntity();
    });
  }

  @override
  Future<Either<Failure, SupportMessageEntity>> sendMessage({
    required String ticketId,
    required String message,
  }) {
    return NetworkErrorHandler.execute<SupportMessageEntity>(() async {
      final model = await _remoteDataSource.sendTicketMessage(ticketId, message);
      return model.toEntity();
    });
  }

  @override
  Future<Either<Failure, SupportTicketEntity>> closeTicket(String ticketId) {
    return NetworkErrorHandler.execute<SupportTicketEntity>(() async {
      final model = await _remoteDataSource.closeTicket(ticketId);
      return model.toEntity();
    });
  }
}

