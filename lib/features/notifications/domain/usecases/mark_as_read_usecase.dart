import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/error/error.dart';
import 'package:stronger_muscles/features/notifications/domain/repositories/notification_repository.dart';

/// Pure domain use case to mark a specific notification as read.
class MarkAsReadUseCase {
  final NotificationRepository _repository;

  const MarkAsReadUseCase(this._repository);

  Future<Either<Failure, Unit>> call(String id) {
    return _repository.markAsRead(id);
  }
}
