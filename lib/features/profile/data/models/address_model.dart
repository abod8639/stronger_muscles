import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/features/profile/domain/entities/address_entity.dart';

part 'address_model.freezed.dart';
part 'address_model.g.dart';

@freezed
@HiveType(typeId: 4, adapterName: 'AddressModelAdapter')
class AddressModel with _$AddressModel {
  const factory AddressModel({
    @HiveField(0) @JsonKey(fromJson: _parseInt) required int id,
    @HiveField(1)
    @JsonKey(name: 'user_id', fromJson: _parseIntNullable)
    int? userId,
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

  const AddressModel._();

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);

  AddressEntity toEntity() {
    return AddressEntity(
      id: id,
      userId: userId,
      label: label,
      fullName: fullName,
      phone: phone,
      street: street,
      city: city,
      state: state,
      postalCode: postalCode,
      country: country,
      isDefault: isDefault,
      latitude: latitude,
      longitude: longitude,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  factory AddressModel.fromEntity(AddressEntity entity) {
    return AddressModel(
      id: entity.id,
      userId: entity.userId,
      label: entity.label,
      fullName: entity.fullName,
      phone: entity.phone,
      street: entity.street,
      city: entity.city,
      state: entity.state,
      postalCode: entity.postalCode,
      country: entity.country,
      isDefault: entity.isDefault,
      latitude: entity.latitude,
      longitude: entity.longitude,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  String get fullAddress => [
    street,
    city,
    state,
    postalCode,
    country,
  ].where((e) => e != null && e.isNotEmpty).join(', ');
  String get shortAddress => '$city, $country';
  bool get hasCoordinates => latitude != null && longitude != null;
}

int _parseInt(dynamic value) {
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

int? _parseIntNullable(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is String) return int.tryParse(value);
  return null;
}
