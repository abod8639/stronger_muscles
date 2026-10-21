import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/error/error.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_ticket_entity.dart';
import 'package:stronger_muscles/features/help_support/domain/repositories/help_support_repository.dart';

class SubmitTicketUseCase {
  final HelpSupportRepository _repository;

  const SubmitTicketUseCase(this._repository);

  Future<Either<Failure, SupportTicketEntity>> call(
    SupportTicketEntity ticket, {
    CancelToken? cancelToken,
  }) {
    return _repository.submitTicket(ticket, cancelToken: cancelToken);
  }
}
