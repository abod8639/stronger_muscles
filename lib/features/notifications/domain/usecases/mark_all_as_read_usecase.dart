import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/error/error.dart';
import 'package:stronger_muscles/features/notifications/domain/repositories/notification_repository.dart';

/// Pure domain use case to mark all user notifications as read.
class MarkAllAsReadUseCase {
  final NotificationRepository _repository;

  const MarkAllAsReadUseCase(this._repository);

  Future<Either<Failure, Unit>> call() {
    return _repository.markAllAsRead();
  }
}
