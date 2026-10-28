import 'package:flutter/foundation.dart';
import '../../domain/entities/support_channel_entity.dart';

/// Data Transfer Object for support contact channels, strictly decoupled from [SupportChannelEntity].
class SupportChannelModel {
  final String id;
  final String type;
  final String titleEn;
  final String titleAr;
  final String subtitleEn;
  final String subtitleAr;
  final String actionValue;
  final String availabilityEn;
  final String availabilityAr;
  final bool isAvailable;

  const SupportChannelModel({
    required this.id,
    required this.type,
    required this.titleEn,
    required this.titleAr,
    required this.subtitleEn,
    required this.subtitleAr,
    required this.actionValue,
    required this.availabilityEn,
    required this.availabilityAr,
    this.isAvailable = true,
  });

  /// Defensive JSON deserializer preventing TypeError when fields are null or unexpected types.
  factory SupportChannelModel.fromJson(Map<String, dynamic> json) {
    return SupportChannelModel(
      id: (json['id'] ?? '').toString(),
      type: (json['type'] ?? SupportChannelType.whatsapp.name).toString(),
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
      'type': type,
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
}

List<SupportChannelModel> _parseSupportChannelListIsolate(List<dynamic> rawList) {
  return rawList
      .whereType<Map>()
      .map((item) => SupportChannelModel.fromJson(Map<String, dynamic>.from(item)))
      .toList();
}
