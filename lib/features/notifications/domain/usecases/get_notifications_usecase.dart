import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/error/error.dart';
import 'package:stronger_muscles/features/notifications/domain/entities/notification_entity.dart';
import 'package:stronger_muscles/features/notifications/domain/repositories/notification_repository.dart';

/// Pure domain use case to fetch paginated notifications and unread count.
class GetNotificationsUseCase {
  final NotificationRepository _repository;

  const GetNotificationsUseCase(this._repository);

  Future<Either<Failure, NotificationsPayloadEntity>> call({
    int page = 1,
    int perPage = 20,
  }) {
    return _repository.getNotifications(page: page, perPage: perPage);
  }
}
