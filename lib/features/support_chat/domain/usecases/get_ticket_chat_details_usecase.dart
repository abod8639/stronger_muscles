import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_ticket_entity.dart';
import '../repositories/support_chat_repository.dart';

class GetTicketChatDetailsUseCase {
  final SupportChatRepository _repository;

  const GetTicketChatDetailsUseCase(this._repository);

  Future<Either<Failure, SupportTicketEntity>> call(String ticketId) {
    return _repository.getTicketDetails(ticketId);
  }
}
