enum FaqCategory {
  all,
  ordersShipping,
  supplements,
  paymentRefunds,
  accountGeneral,
}

class FaqEntity {
  final String id;
  final String questionEn;
  final String questionAr;
  final String answerEn;
  final String answerAr;
  final FaqCategory category;
  final List<String> tags;

  const FaqEntity({
    required this.id,
    required this.questionEn,
    required this.questionAr,
    required this.answerEn,
    required this.answerAr,
    required this.category,
    this.tags = const [],
  });

  String getQuestion(bool isArabic) => isArabic ? questionAr : questionEn;
  String getAnswer(bool isArabic) => isArabic ? answerAr : answerEn;
}
