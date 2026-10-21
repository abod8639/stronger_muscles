import 'package:flutter/foundation.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/support_channel_entity.dart';

class SupportChannelModel extends SupportChannelEntity {
  const SupportChannelModel({
    required super.id,
    required super.type,
    required super.titleEn,
    required super.titleAr,
    required super.subtitleEn,
    required super.subtitleAr,
    required super.actionValue,
    required super.availabilityEn,
    required super.availabilityAr,
    super.isAvailable,
  });

  /// Defensive JSON deserializer preventing TypeError when fields are null or unexpected types.
  factory SupportChannelModel.fromJson(Map<String, dynamic> json) {
    return SupportChannelModel(
      id: (json['id'] ?? '').toString(),
      type: SupportChannelType.values.firstWhere(
        (t) => t.name == json['type']?.toString(),
        orElse: () => SupportChannelType.whatsapp,
      ),
      titleEn: (json['title_en'] ?? json['titleEn'] ?? '').toString(),
      titleAr: (json['title_ar'] ?? json['titleAr'] ?? '').toString(),
      subtitleEn: (json['subtitle_en'] ?? json['subtitleEn'] ?? '').toString(),
      subtitleAr: (json['subtitle_ar'] ?? json['subtitleAr'] ?? '').toString(),
      actionValue: (json['action_value'] ?? json['actionValue'] ?? '').toString(),
      availabilityEn: (json['availability_en'] ?? json['availabilityEn'] ?? '').toString(),
      availabilityAr: (json['availability_ar'] ?? json['availabilityAr'] ?? '').toString(),
      isAvailable: json['is_available'] as bool? ?? (json['isAvailable'] as bool? ?? true),
    );
  }

  /// Parses a collection of Support Channels on a background isolate.
  static Future<List<SupportChannelModel>> parseListAsync(List<dynamic> list) {
    return compute(_parseSupportChannelListIsolate, list);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'title_en': titleEn,
      'title_ar': titleAr,
      'subtitle_en': subtitleEn,
      'subtitle_ar': subtitleAr,
      'action_value': actionValue,
      'availability_en': availabilityEn,
      'availability_ar': availabilityAr,
      'is_available': isAvailable,
    };
  }

  factory SupportChannelModel.fromEntity(SupportChannelEntity entity) {
    return SupportChannelModel(
      id: entity.id,
      type: entity.type,
      titleEn: entity.titleEn,
      titleAr: entity.titleAr,
      subtitleEn: entity.subtitleEn,
      subtitleAr: entity.subtitleAr,
      actionValue: entity.actionValue,
      availabilityEn: entity.availabilityEn,
      availabilityAr: entity.availabilityAr,
      isAvailable: entity.isAvailable,
    );
  }
}

List<SupportChannelModel> _parseSupportChannelListIsolate(List<dynamic> rawList) {
  return rawList
      .whereType<Map>()
      .map((item) => SupportChannelModel.fromJson(Map<String, dynamic>.from(item)))
      .toList();
}
