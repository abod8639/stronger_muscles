import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/support_ticket_entity.dart';
import '../repositories/help_support_repository.dart';

class GetUserTicketsUseCase {
  final HelpSupportRepository _repository;

  const GetUserTicketsUseCase(this._repository);

  Future<Either<Failure, List<SupportTicketEntity>>> call() {
    return _repository.getUserTickets();
  }
}
