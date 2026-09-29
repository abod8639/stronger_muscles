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

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      type: json['type']?.toString() ?? 'general',
      targetType: json['target_type']?.toString() ?? 'all',
      userId: json['user_id']?.toString(),
      data: json['data'] is Map ? Map<String, dynamic>.from(json['data']) : null,
      imageUrl: json['image_url']?.toString(),
      isRead: json['is_read'] == true || json['is_read'] == 1,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
    );
  }

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

  String? get orderId => data?['order_id']?.toString();
  String? get promoId => data?['promo_id']?.toString();
  String? get productId => data?['product_id']?.toString();
}
