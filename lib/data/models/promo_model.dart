import 'dart:ui';

class PromoModel {
  final String? title;
  final String? subtitle;
  final String imageUrl;
  final String buttonText;
  final Color backgroundColor;
  final void Function()? onTap;

  PromoModel({
     this.title,
     this.subtitle,
    required this.imageUrl,
    required this.buttonText,
    required this.backgroundColor, 
    this.onTap,
  });
}