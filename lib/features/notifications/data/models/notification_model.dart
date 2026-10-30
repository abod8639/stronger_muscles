/// Data model representing a notification DTO.
/// Strictly decoupled from domain Entity and features resilient, defensive JSON parsing.
class NotificationModel {
  final String id;
  final String title;
  final String body;
  final String type;
  final String targetType;
  final String? userId;
  final Map<String, dynamic>? data;
  final String? imageUrl;
  final bool isRead;
  final DateTime? createdAt;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    this.type = 'general',
    this.targetType = 'all',
    this.userId,
    this.data,
    this.imageUrl,
    this.isRead = false,
    this.createdAt,
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

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'body': body,
        'type': type,
        'target_type': targetType,
        'user_id': userId,
        'data': data,
        'image_url': imageUrl,
        'is_read': isRead,
        'created_at': createdAt?.toIso8601String(),
      };

  String? get orderId => data?['order_id']?.toString();
  String? get promoId => data?['promo_id']?.toString();
  String? get productId => data?['product_id']?.toString();
  String? get ticketId =>
      data?['ticket_id']?.toString() ??
      data?['ticketId']?.toString();
  String? get ticketNumber =>
      data?['ticket_number']?.toString() ??
      data?['ticketNumber']?.toString();
  bool get isSupport =>
      type == 'support' ||
      type == 'support_ticket' ||
      (ticketId != null && ticketId!.isNotEmpty);

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

/// Data model representing paginated notifications response payload.
class NotificationsPayloadModel {
  final List<NotificationModel> notifications;
  final int unreadCount;
  final bool hasMore;

  const NotificationsPayloadModel({
    required this.notifications,
    required this.unreadCount,
    this.hasMore = false,
  });

  factory NotificationsPayloadModel.fromJson(dynamic json) {
    if (json is! Map) {
      return const NotificationsPayloadModel(
        notifications: [],
        unreadCount: 0,
        hasMore: false,
      );
    }

    final list = NotificationModel.fromJsonList(json);

    int unread = 0;
    if (json['unread_count'] != null) {
      unread = (json['unread_count'] as num).toInt();
    } else {
      unread = list.where((n) => !n.isRead).length;
    }

    bool hasMore = false;
    if (json['has_more'] != null) {
      hasMore = json['has_more'] == true;
    } else if (json['pagination'] is Map) {
      final p = json['pagination'] as Map;
      final current = (p['current_page'] as num?)?.toInt() ?? 1;
      final totalPages = (p['total_pages'] as num?)?.toInt() ?? 1;
      hasMore = current < totalPages;
    }

    return NotificationsPayloadModel(
      notifications: list,
      unreadCount: unread,
      hasMore: hasMore,
    );
  }
}
