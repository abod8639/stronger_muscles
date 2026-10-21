import 'package:flutter/foundation.dart';
import 'package:stronger_muscles/features/help_support/domain/entities/faq_entity.dart';

class FaqModel extends FaqEntity {
  const FaqModel({
    required super.id,
    required super.questionEn,
    required super.questionAr,
    required super.answerEn,
    required super.answerAr,
    required super.category,
    super.tags,
  });

  /// Defensive JSON deserializer with safe fallback defaults preventing TypeError and NullPointer.
  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      id: (json['id'] ?? '').toString(),
      questionEn: (json['question_en'] ?? json['questionEn'] ?? '').toString(),
      questionAr: (json['question_ar'] ?? json['questionAr'] ?? '').toString(),
      answerEn: (json['answer_en'] ?? json['answerEn'] ?? '').toString(),
      answerAr: (json['answer_ar'] ?? json['answerAr'] ?? '').toString(),
      category: FaqCategory.values.firstWhere(
        (c) => c.name == json['category']?.toString(),
        orElse: () => FaqCategory.ordersShipping,
      ),
      tags: (json['tags'] is List)
          ? (json['tags'] as List)
              .map((e) => e?.toString() ?? '')
              .where((s) => s.isNotEmpty)
              .toList()
          : const [],
    );
  }

  /// Parses a collection of FAQs on a background isolate to prevent UI thread freezing.
  static Future<List<FaqModel>> parseListAsync(List<dynamic> list) {
    return compute(_parseFaqListIsolate, list);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question_en': questionEn,
      'question_ar': questionAr,
      'answer_en': answerEn,
      'answer_ar': answerAr,
      'category': category.name,
      'tags': tags,
    };
  }

  factory FaqModel.fromEntity(FaqEntity entity) {
    return FaqModel(
      id: entity.id,
      questionEn: entity.questionEn,
      questionAr: entity.questionAr,
      answerEn: entity.answerEn,
      answerAr: entity.answerAr,
      category: entity.category,
      tags: entity.tags,
    );
  }
}

List<FaqModel> _parseFaqListIsolate(List<dynamic> rawList) {
  return rawList
      .whereType<Map>()
      .map((item) => FaqModel.fromJson(Map<String, dynamic>.from(item)))
      .toList();
}
