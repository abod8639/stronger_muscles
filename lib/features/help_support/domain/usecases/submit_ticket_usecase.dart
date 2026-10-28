import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/support_ticket_entity.dart';
import '../repositories/help_support_repository.dart';

class SubmitTicketUseCase {
  final HelpSupportRepository _repository;

  const SubmitTicketUseCase(this._repository);

  Future<Either<Failure, SupportTicketEntity>> call(
    SupportTicketEntity ticket,
  ) {
    return _repository.submitTicket(ticket);
  }
}
