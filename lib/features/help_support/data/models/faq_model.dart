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

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      id: json['id'] as String,
      questionEn: json['question_en'] as String,
      questionAr: json['question_ar'] as String,
      answerEn: json['answer_en'] as String,
      answerAr: json['answer_ar'] as String,
      category: FaqCategory.values.firstWhere(
        (c) => c.name == json['category'],
        orElse: () => FaqCategory.ordersShipping,
      ),
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
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
