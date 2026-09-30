import 'package:flutter/material.dart';

/// Pure domain entity representing a promotional banner.
/// Free of external dependencies (Hive, json_serializable, etc.).
class PromoEntity {
  final int id;
  final String? title;
  final String? subtitle;
  final String imageUrl;
  final String buttonText;
  final String hexBackgroundColor;
  final String targetType;
  final String? targetId;

  const PromoEntity({
    required this.id,
    this.title,
    this.subtitle,
    required this.imageUrl,
    this.buttonText = 'عرض الآن',
    this.hexBackgroundColor = '#FFFFFF',
    this.targetType = 'none',
    this.targetId,
  });

  /// Parse the hex background color safely with fallback to white
  Color get backgroundColor {
    try {
      final hex = hexBackgroundColor.replaceAll('#', '');
      return Color(int.parse('FF$hex', radix: 16));
    } catch (_) {
      return const Color(0xFFFFFFFF);
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PromoEntity &&
        other.id == id &&
        other.title == title &&
        other.subtitle == subtitle &&
        other.imageUrl == imageUrl &&
        other.buttonText == buttonText &&
        other.hexBackgroundColor == hexBackgroundColor &&
        other.targetType == targetType &&
        other.targetId == targetId;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      title,
      subtitle,
      imageUrl,
      buttonText,
      hexBackgroundColor,
      targetType,
      targetId,
    );
  }

  @override
  String toString() {
    return 'PromoEntity(id: $id, title: $title, targetType: $targetType, targetId: $targetId)';
  }
}
