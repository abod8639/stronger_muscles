// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 7;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      id: fields[0] as int,
      email: fields[1] as String,
      name: fields[2] as String,
      photoUrl: fields[3] as String?,
      phone: fields[4] as String?,
      defaultAddressId: fields[5] as String?,
      preferredLanguage: fields[6] as String?,
      notificationsEnabled: fields[7] as bool,
      isActive: fields[8] as bool,
      createdAt: fields[9] as DateTime?,
      lastLogin: fields[10] as DateTime?,
      token: fields[11] as String?,
      role: fields[12] as String?,
      totalSpent: fields[13] as double?,
      ordersCount: fields[14] as int?,
      addresses: (fields[15] as List?)?.cast<AddressModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.photoUrl)
      ..writeByte(4)
      ..write(obj.phone)
      ..writeByte(5)
      ..write(obj.defaultAddressId)
      ..writeByte(6)
      ..write(obj.preferredLanguage)
      ..writeByte(7)
      ..write(obj.notificationsEnabled)
      ..writeByte(8)
      ..write(obj.isActive)
      ..writeByte(9)
      ..write(obj.createdAt)
      ..writeByte(10)
      ..write(obj.lastLogin)
      ..writeByte(11)
      ..write(obj.token)
      ..writeByte(12)
      ..write(obj.role)
      ..writeByte(13)
      ..write(obj.totalSpent)
      ..writeByte(14)
      ..write(obj.ordersCount)
      ..writeByte(15)
      ..write(obj.addresses);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: _parseInt(json['id']),
      email: json['email'] as String,
      name: json['name'] as String,
      photoUrl: json['photo_url'] as String?,
      phone: json['phone'] as String?,
      defaultAddressId: json['default_address_id'] as String?,
      preferredLanguage: json['preferred_language'] as String? ?? 'ar',
      notificationsEnabled: json['notifications_enabled'] == null
          ? true
          : _boolFromInt(json['notifications_enabled']),
      isActive: json['is_active'] == null
          ? true
          : _boolFromInt(json['is_active']),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      lastLogin: json['last_login'] == null
          ? null
          : DateTime.parse(json['last_login'] as String),
      token: json['token'] as String?,
      role: json['role'] as String?,
      totalSpent: (json['total_spent'] as num?)?.toDouble(),
      ordersCount: (json['orders_count'] as num?)?.toInt(),
      addresses: (json['addresses'] as List<dynamic>?)
          ?.map((e) => AddressModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'photo_url': instance.photoUrl,
      'phone': instance.phone,
      'default_address_id': instance.defaultAddressId,
      'preferred_language': instance.preferredLanguage,
      'notifications_enabled': instance.notificationsEnabled,
      'is_active': instance.isActive,
      'created_at': instance.createdAt?.toIso8601String(),
      'last_login': instance.lastLogin?.toIso8601String(),
      'token': instance.token,
      'role': instance.role,
      'total_spent': instance.totalSpent,
      'orders_count': instance.ordersCount,
      'addresses': instance.addresses,
    };
