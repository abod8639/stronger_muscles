import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'address_model.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
@HiveType(typeId: 7, adapterName: 'UserModelAdapter')
@JsonSerializable()

class UserModel with _$UserModel {
  // Hive dedicated constructor
  const UserModel._();

  const factory UserModel({
    @HiveField(0) @JsonKey(fromJson: _parseInt) required int id,
    @HiveField(1) required String email,
    @HiveField(2) required String name,
    @HiveField(3) @JsonKey(name: 'photo_url') String? photoUrl,
    @HiveField(4) String? phone,
    @HiveField(5) @JsonKey(name: 'default_address_id') String? defaultAddressId,
    @HiveField(6) @JsonKey(name: 'preferred_language') @Default('ar') String? preferredLanguage,
    @HiveField(7) @JsonKey(name: 'notifications_enabled', fromJson: _boolFromInt) @Default(true) bool notificationsEnabled,
    @HiveField(8) @JsonKey(name: 'is_active', fromJson: _boolFromInt) @Default(true) bool isActive,
    @HiveField(9) @JsonKey(name: 'created_at') DateTime? createdAt,
    @HiveField(10) @JsonKey(name: 'last_login') DateTime? lastLogin,
    @HiveField(11) String? token,
    @HiveField(12) String? role,
    @HiveField(13) @JsonKey(name: 'total_spent') double? totalSpent,
    @HiveField(14) @JsonKey(name: 'orders_count') int? ordersCount,
    @HiveField(15) List<AddressModel>? addresses,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  
  @override
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

int _parseInt(dynamic value) {
  if (value is int) return value;
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

// دالة مساعدة لتحويل القيم المنطقية القادمة من SQL (0 أو 1) إلى Boolean
bool _boolFromInt(dynamic value) {
  if (value is bool) return value;
  if (value is int) return value == 1;
  if (value is String) return value == '1' || value.toLowerCase() == 'true';
  return false;
}