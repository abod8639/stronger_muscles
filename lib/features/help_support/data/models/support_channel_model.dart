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

  factory SupportChannelModel.fromJson(Map<String, dynamic> json) {
    return SupportChannelModel(
      id: json['id'] as String,
      type: SupportChannelType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => SupportChannelType.whatsapp,
      ),
      titleEn: json['title_en'] as String,
      titleAr: json['title_ar'] as String,
      subtitleEn: json['subtitle_en'] as String,
      subtitleAr: json['subtitle_ar'] as String,
      actionValue: json['action_value'] as String,
      availabilityEn: json['availability_en'] as String,
      availabilityAr: json['availability_ar'] as String,
      isAvailable: json['is_available'] as bool? ?? true,
    );
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
