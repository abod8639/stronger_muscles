import 'package:flutter/foundation.dart';

/// Pure domain entity representing a localized string.
@immutable
class LocalizedStringEntity {
  final String? ar;
  final String? en;

  const LocalizedStringEntity({this.ar, this.en});

  String getValue({String locale = 'en'}) {
    if (locale == 'ar') return ar ?? en ?? '';
    return en ?? ar ?? '';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalizedStringEntity &&
          runtimeType == other.runtimeType &&
          ar == other.ar &&
          en == other.en;

  @override
  int get hashCode => ar.hashCode ^ en.hashCode;

  @override
  String toString() => 'LocalizedStringEntity(ar: $ar, en: $en)';
}
