import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
@HiveType(typeId: 7, adapterName: 'UserModelAdapter')
class UserModel with _$UserModel {
  const factory UserModel({
    @HiveField(0) required int id,
    @HiveField(1) required String email,
    @HiveField(2) required String name,
    @HiveField(3) @JsonKey(name: 'photo_url') String? photoUrl,
    @HiveField(4) @JsonKey(name: 'phone_number') String? phoneNumber,
    @HiveField(5) @JsonKey(name: 'default_address_id') String? defaultAddressId,
    @HiveField(6) @JsonKey(name: 'preferred_language') @Default('ar') String preferredLanguage,
    @HiveField(7) @JsonKey(name: 'notifications_enabled') @Default(true) bool notificationsEnabled,
    @HiveField(8) @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @HiveField(9) DateTime? createdAt,
    @HiveField(10) DateTime? lastLogin,
    @HiveField(11) String? token,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}
