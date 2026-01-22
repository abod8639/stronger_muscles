import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'address_model.freezed.dart';
part 'address_model.g.dart';

@freezed
class AddressModel with _$AddressModel {
  @HiveType(typeId: 4, adapterName: 'AddressModelAdapter')
  const factory AddressModel({
    @HiveField(0) required int id,
    @HiveField(1) @JsonKey(name: 'user_id') int? userId,
    @HiveField(2) String? label,
    @HiveField(3) @JsonKey(name: 'full_name') String? fullName,
    @HiveField(4) String? phone,
    @HiveField(5) required String street,
    @HiveField(6) required String city,
    @HiveField(7) String? state,
    @HiveField(8) @JsonKey(name: 'postal_code') String? postalCode,
    @HiveField(9) String? country,
    @HiveField(10) @JsonKey(name: 'is_default') @Default(false) bool isDefault,
    @HiveField(11) double? latitude,
    @HiveField(12) double? longitude,
    @HiveField(13) DateTime? createdAt,
    @HiveField(14) DateTime? updatedAt,
  }) = _AddressModel;

        // 'user_id',
        // 'label',
        // 'full_name',
        // 'phone',
        // 'street',
        // 'city',
        // 'state',
        // 'postal_code',
        // 'country',
        // 'is_default',
        // 'latitude',
        // 'longitude',

  const AddressModel._();

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    if (json['id'] is String) {
      json['id'] = int.tryParse(json['id']) ?? 0;
    }
    if (json['user_id'] is String) {
      json['user_id'] = int.tryParse(json['user_id']);
    }
    return _$AddressModelFromJson(json);
  }

  String get fullAddress => '$street, $city, $state $postalCode, $country';
  String get shortAddress => '$city, $country';
  bool get hasCoordinates => latitude != null && longitude != null;
}
