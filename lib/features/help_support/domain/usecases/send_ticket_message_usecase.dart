import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/support_message_entity.dart';
import '../repositories/help_support_repository.dart';

class SendTicketMessageUseCase {
  final HelpSupportRepository _repository;

  const SendTicketMessageUseCase(this._repository);

  Future<Either<Failure, SupportMessageEntity>> call({
    required String ticketId,
    required String message,
  }) {
    return _repository.sendTicketMessage(
      ticketId: ticketId,
      message: message,
    );
  }
}
