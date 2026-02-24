import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'localized_string_model.freezed.dart';
part 'localized_string_model.g.dart';

@freezed
@HiveType(typeId: 11, adapterName: 'LocalizedStringAdapter')
class LocalizedString with _$LocalizedString {
  const factory LocalizedString({
    @HiveField(0) @JsonKey(name: 'ar') required String ar,
    @HiveField(1) @JsonKey(name: 'en') required String en,
  }) = _LocalizedString;

  const LocalizedString._();

  factory LocalizedString.fromJson(Map<String, dynamic> json) =>
      _$LocalizedStringFromJson(json);

  /// Get the localized string based on the current locale (default: English)
  String getValue({String locale = 'en'}) {
    if (locale == 'ar') return ar;
    return en;
  }
}
