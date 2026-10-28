import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/error/error.dart';
import 'package:stronger_muscles/features/notifications/domain/repositories/notification_repository.dart';

/// Pure domain use case to delete a notification by its id.
class DeleteNotificationUseCase {
  final NotificationRepository _repository;

  const DeleteNotificationUseCase(this._repository);

  Future<Either<Failure, Unit>> call(String id) {
    return _repository.deleteNotification(id);
  }
}
