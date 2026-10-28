import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failures.dart';
import '../entities/support_ticket_entity.dart';
import '../repositories/help_support_repository.dart';

class GetTicketDetailsUseCase {
  final HelpSupportRepository _repository;

  const GetTicketDetailsUseCase(this._repository);

  Future<Either<Failure, SupportTicketEntity>> call(String ticketId) {
    return _repository.getTicketDetails(ticketId);
  }
}
