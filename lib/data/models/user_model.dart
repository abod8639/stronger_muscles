import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

import 'address_model.dart';

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
    @HiveField(4) String? phone,
    @HiveField(5) @JsonKey(name: 'default_address_id') String? defaultAddressId,
    @HiveField(6) @JsonKey(name: 'preferred_language') @Default('ar') String preferredLanguage,
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

  factory UserModel.fromJson(Map<String, dynamic> json) {
    if (json['id'] is String) {
      json['id'] = int.tryParse(json['id']) ?? 0;
    }
    return _$UserModelFromJson(json);
  }
}

bool _boolFromInt(dynamic value) {
  if (value is bool) return value;
  if (value is int) return value == 1;
  if (value is String) return value == '1' || value.toLowerCase() == 'true';
  return false;
}
