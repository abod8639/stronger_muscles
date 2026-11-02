import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_message_entity.dart';
import '../repositories/support_chat_repository.dart';

class SendTicketChatMessageUseCase {
  final SupportChatRepository _repository;

  const SendTicketChatMessageUseCase(this._repository);

  Future<Either<Failure, SupportMessageEntity>> call({
    required String ticketId,
    required String message,
  }) {
    return _repository.sendMessage(ticketId: ticketId, message: message);
  }
}
