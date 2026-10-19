enum SupportChannelType {
  whatsapp,
  phone,
  email,
  ticket,
}

class SupportChannelEntity {
  final String id;
  final SupportChannelType type;
  final String titleEn;
  final String titleAr;
  final String subtitleEn;
  final String subtitleAr;
  final String actionValue;
  final String availabilityEn;
  final String availabilityAr;
  final bool isAvailable;

  const SupportChannelEntity({
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

  String getTitle(bool isArabic) => isArabic ? titleAr : titleEn;
  String getSubtitle(bool isArabic) => isArabic ? subtitleAr : subtitleEn;
  String getAvailability(bool isArabic) => isArabic ? availabilityAr : availabilityEn;
}
