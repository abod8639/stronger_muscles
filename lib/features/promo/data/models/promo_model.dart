import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'promo_model.freezed.dart';
part 'promo_model.g.dart';

@freezed
class PromoModel with _$PromoModel {
  // النوع 10 هو مثال، تأكد أنه غير مستخدم في موديلات أخرى لديك
  @HiveType(typeId: 10)
  const factory PromoModel({
    @HiveField(0) required int id,
    @HiveField(1) String? title,
    @HiveField(2) String? subtitle,
    @HiveField(3) @JsonKey(name: 'image_url') required String imageUrl,
    @HiveField(4) @JsonKey(name: 'button_text', defaultValue: 'عرض الآن') required String buttonText,
    @HiveField(5) @JsonKey(name: 'background_color', defaultValue: '#FFFFFF') required String hexBackgroundColor,
    @HiveField(6) @JsonKey(name: 'target_type', defaultValue: 'none') required String targetType,
    @HiveField(7) @JsonKey(name: 'target_id') String? targetId,
  }) = _PromoModel;

  // ضروري للسماح بإضافة Getters داخل الكلاس
  const PromoModel._();

  factory PromoModel.fromJson(Map<String, dynamic> json) => _$PromoModelFromJson(json);

  // تحويل اللون بطريقة آمنة
  Color get backgroundColor {
    try {
      final hex = hexBackgroundColor.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return Colors.white;
    }
  }
}