import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/error/error.dart';
import 'package:stronger_muscles/features/notifications/domain/repositories/notification_repository.dart';

/// Pure domain use case to retrieve total count of unread notifications for badge counters.
class GetUnreadCountUseCase {
  final NotificationRepository _repository;

  const GetUnreadCountUseCase(this._repository);

  Future<Either<Failure, int>> call() {
    return _repository.getUnreadCount();
  }
}
