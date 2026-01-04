import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'address_model.freezed.dart';
part 'address_model.g.dart';

@freezed
class AddressModel with _$AddressModel {
  @HiveType(typeId: 4, adapterName: 'AddressModelAdapter')
  const factory AddressModel({
    @HiveField(0) required String id,
    @HiveField(1) required String userId,
    @HiveField(2) required String label, // 'Home', 'Work', 'Other'
    @HiveField(3) required String fullName,
    @HiveField(4) required String phoneNumber,
    @HiveField(5) required String street,
    @HiveField(6) required String city,
    @HiveField(7) required String state,
    @HiveField(8) required String postalCode,
    @HiveField(9) required String country,
    @HiveField(10) @Default(false) bool isDefault,
    @HiveField(11) double? latitude,
    @HiveField(12) double? longitude,
    @HiveField(13) DateTime? createdAt,
    @HiveField(14) DateTime? updatedAt,
  }) = _AddressModel;

  const AddressModel._();

  factory AddressModel.fromJson(Map<String, dynamic> json) => _$AddressModelFromJson(json);

  String get fullAddress => '$street, $city, $state $postalCode, $country';
  String get shortAddress => '$city, $country';
  bool get hasCoordinates => latitude != null && longitude != null;
}
