import 'package:stronger_muscles/features/help_support/domain/entities/support_ticket_entity.dart';
import 'package:stronger_muscles/features/help_support/domain/repositories/help_support_repository.dart';

class SubmitTicketUseCase {
  final HelpSupportRepository _repository;

  const SubmitTicketUseCase(this._repository);

  Future<SupportTicketEntity> call(SupportTicketEntity ticket) {
    return _repository.submitTicket(ticket);
  }
}
