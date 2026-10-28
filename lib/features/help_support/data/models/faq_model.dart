import 'package:flutter/foundation.dart';
import '../../domain/entities/faq_entity.dart';

/// Data Transfer Object for FAQs, strictly decoupled from [FaqEntity].
class FaqModel {
  final String id;
  final String questionEn;
  final String questionAr;
  final String answerEn;
  final String answerAr;
  final String category;
  final List<String> tags;

  const FaqModel({
    required this.id,
    required this.questionEn,
    required this.questionAr,
    required this.answerEn,
    required this.answerAr,
    required this.category,
    this.tags = const [],
  });

  /// Defensive JSON deserializer with safe fallback defaults preventing TypeError and NullPointer.
  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      id: (json['id'] ?? '').toString(),
      questionEn: (json['question_en'] ?? json['questionEn'] ?? '').toString(),
      questionAr: (json['question_ar'] ?? json['questionAr'] ?? '').toString(),
      answerEn: (json['answer_en'] ?? json['answerEn'] ?? '').toString(),
      answerAr: (json['answer_ar'] ?? json['answerAr'] ?? '').toString(),
      category: (json['category'] ?? FaqCategory.ordersShipping.name).toString(),
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
      'category': category,
      'tags': tags,
    };
  }
}

List<FaqModel> _parseFaqListIsolate(List<dynamic> rawList) {
  return rawList
      .whereType<Map>()
      .map((item) => FaqModel.fromJson(Map<String, dynamic>.from(item)))
      .toList();
}
