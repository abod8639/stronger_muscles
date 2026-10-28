import 'package:stronger_muscles/features/notifications/data/models/notification_model.dart';
import 'package:stronger_muscles/features/notifications/domain/entities/notification_entity.dart';

/// Extension mapper to convert [NotificationModel] DTO to domain [NotificationEntity].
extension NotificationModelMapper on NotificationModel {
  NotificationEntity toEntity() => NotificationEntity(
        id: id,
        title: title,
        body: body,
        type: type,
        targetType: targetType,
        userId: userId,
        data: data,
        imageUrl: imageUrl,
        isRead: isRead,
        createdAt: createdAt,
      );
}

/// Extension mapper to convert domain [NotificationEntity] to data [NotificationModel] DTO.
extension NotificationEntityMapper on NotificationEntity {
  NotificationModel toModel() => NotificationModel(
        id: id,
        title: title,
        body: body,
        type: type,
        targetType: targetType,
        userId: userId,
        data: data,
        imageUrl: imageUrl,
        isRead: isRead,
        createdAt: createdAt,
      );
}

/// Extension mapper to convert [NotificationsPayloadModel] to domain [NotificationsPayloadEntity].
extension NotificationsPayloadModelMapper on NotificationsPayloadModel {
  NotificationsPayloadEntity toEntity() => NotificationsPayloadEntity(
        notifications: notifications.map((n) => n.toEntity()).toList(),
        unreadCount: unreadCount,
        hasMore: hasMore,
      );
}
