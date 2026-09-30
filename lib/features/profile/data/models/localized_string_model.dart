import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/features/product/domain/entities/localized_string_entity.dart';

part 'localized_string_model.freezed.dart';
part 'localized_string_model.g.dart';

@freezed
@HiveType(typeId: 11, adapterName: 'LocalizedStringAdapter')
class LocalizedString with _$LocalizedString {
  const factory LocalizedString({
    @HiveField(0) @JsonKey(name: 'ar') String? ar,
    @HiveField(1) @JsonKey(name: 'en') String? en,
  }) = _LocalizedString;

  const LocalizedString._();

  factory LocalizedString.fromJson(Map<String, dynamic> json) =>
      _$LocalizedStringFromJson(json);

  /// Get the localized string based on the current locale (default: English)
  String getValue({String locale = 'en'}) {
    if (locale == 'ar') return ar ?? en ?? '';
    return en ?? ar ?? '';
  }

  /// Maps to pure domain entity [LocalizedStringEntity]
  LocalizedStringEntity toEntity() => LocalizedStringEntity(ar: ar, en: en);

  /// Creates model from pure domain entity [LocalizedStringEntity]
  static LocalizedString fromEntity(LocalizedStringEntity entity) =>
      LocalizedString(ar: entity.ar, en: entity.en);
}
