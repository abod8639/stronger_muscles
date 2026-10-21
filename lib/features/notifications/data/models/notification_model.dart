import 'package:stronger_muscles/features/notifications/domain/entities/notification_entity.dart';

export 'package:stronger_muscles/features/notifications/domain/entities/notification_entity.dart';

/// Data model representing a notification, extending domain [NotificationEntity].
/// Features defensive parsing and default values to prevent TypeError and NullPointer crashes.
class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.title,
    required super.body,
    super.type = 'general',
    super.targetType = 'all',
    super.userId,
    super.data,
    super.imageUrl,
    super.isRead = false,
    super.createdAt,
  });

  /// Robust, fault-tolerant JSON parser.
  factory NotificationModel.fromJson(dynamic json) {
    if (json is! Map) {
      return const NotificationModel(
        id: '',
        title: '',
        body: '',
      );
    }

    final id = json['id']?.toString() ?? json['_id']?.toString() ?? '';
    final title = json['title']?.toString() ?? json['name']?.toString() ?? '';
    final body = json['body']?.toString() ?? json['message']?.toString() ?? '';
    final type = json['type']?.toString().toLowerCase() ?? 'general';
    final targetType = json['target_type']?.toString().toLowerCase() ?? 'all';
    final userId = json['user_id']?.toString();

    Map<String, dynamic>? dataMap;
    if (json['data'] is Map) {
      try {
        dataMap = Map<String, dynamic>.from(json['data'] as Map);
      } catch (_) {
        dataMap = null;
      }
    }

    final imageUrl = json['image_url']?.toString() ?? json['image']?.toString();

    final rawRead = json['is_read'] ?? json['read'];
    final isRead = rawRead == true ||
        rawRead == 1 ||
        rawRead == '1' ||
        rawRead == 'true';

    DateTime? createdAt;
    final rawDate = json['created_at'];
    if (rawDate != null) {
      createdAt = DateTime.tryParse(rawDate.toString());
    }

    return NotificationModel(
      id: id,
      title: title,
      body: body,
      type: type,
      targetType: targetType,
      userId: userId,
      data: dataMap,
      imageUrl: imageUrl,
      isRead: isRead,
      createdAt: createdAt,
    );
  }

  factory NotificationModel.fromEntity(NotificationEntity entity) {
    return NotificationModel(
      id: entity.id,
      title: entity.title,
      body: entity.body,
      type: entity.type,
      targetType: entity.targetType,
      userId: entity.userId,
      data: entity.data,
      imageUrl: entity.imageUrl,
      isRead: entity.isRead,
      createdAt: entity.createdAt,
    );
  }

  NotificationEntity toEntity() {
    return NotificationEntity(
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

  @override
  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    String? type,
    String? targetType,
    String? userId,
    Map<String, dynamic>? data,
    String? imageUrl,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      targetType: targetType ?? this.targetType,
      userId: userId ?? this.userId,
      data: data ?? this.data,
      imageUrl: imageUrl ?? this.imageUrl,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Parses a raw response into a list of models safely.
  static List<NotificationModel> fromJsonList(dynamic data) {
    if (data == null) return const [];

    List<dynamic> items = const [];
    if (data is List) {
      items = data;
    } else if (data is Map) {
      final raw = data['data'] ?? data['items'] ?? data['notifications'];
      if (raw is List) {
        items = raw;
      }
    }

    final results = <NotificationModel>[];
    for (final item in items) {
      if (item is Map) {
        try {
          results.add(NotificationModel.fromJson(item));
        } catch (_) {
          // Drop corrupt individual notification safely
        }
      }
    }
    return results;
  }
}
