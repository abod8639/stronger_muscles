// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'address_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AddressModel _$AddressModelFromJson(Map<String, dynamic> json) {
  return _AddressModel.fromJson(json);
}

/// @nodoc
mixin _$AddressModel {
  @HiveField(0)
  @JsonKey(fromJson: _parseInt)
  int get id => throw _privateConstructorUsedError;
  @HiveField(1)
  @JsonKey(name: 'user_id', fromJson: _parseIntNullable)
  int? get userId => throw _privateConstructorUsedError;
  @HiveField(2)
  String? get label => throw _privateConstructorUsedError;
  @HiveField(3)
  @JsonKey(name: 'full_name')
  String? get fullName => throw _privateConstructorUsedError;
  @HiveField(4)
  String? get phone => throw _privateConstructorUsedError;
  @HiveField(5)
  String get street => throw _privateConstructorUsedError;
  @HiveField(6)
  String get city => throw _privateConstructorUsedError;
  @HiveField(7)
  String? get state => throw _privateConstructorUsedError;
  @HiveField(8)
  @JsonKey(name: 'postal_code')
  String? get postalCode => throw _privateConstructorUsedError;
  @HiveField(9)
  String? get country => throw _privateConstructorUsedError;
  @HiveField(10)
  @JsonKey(name: 'is_default')
  bool get isDefault => throw _privateConstructorUsedError;
  @HiveField(11)
  double? get latitude => throw _privateConstructorUsedError;
  @HiveField(12)
  double? get longitude => throw _privateConstructorUsedError;
  @HiveField(13)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @HiveField(14)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $AddressModelCopyWith<AddressModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddressModelCopyWith<$Res> {
  factory $AddressModelCopyWith(
          AddressModel value, $Res Function(AddressModel) then) =
      _$AddressModelCopyWithImpl<$Res, AddressModel>;
  @useResult
  $Res call(
      {@HiveField(0) @JsonKey(fromJson: _parseInt) int id,
      @HiveField(1)
      @JsonKey(name: 'user_id', fromJson: _parseIntNullable)
      int? userId,
      @HiveField(2) String? label,
      @HiveField(3) @JsonKey(name: 'full_name') String? fullName,
      @HiveField(4) String? phone,
      @HiveField(5) String street,
      @HiveField(6) String city,
      @HiveField(7) String? state,
      @HiveField(8) @JsonKey(name: 'postal_code') String? postalCode,
      @HiveField(9) String? country,
      @HiveField(10) @JsonKey(name: 'is_default') bool isDefault,
      @HiveField(11) double? latitude,
      @HiveField(12) double? longitude,
      @HiveField(13) DateTime? createdAt,
      @HiveField(14) DateTime? updatedAt});
}

/// @nodoc
class _$AddressModelCopyWithImpl<$Res, $Val extends AddressModel>
    implements $AddressModelCopyWith<$Res> {
  _$AddressModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = freezed,
    Object? label = freezed,
    Object? fullName = freezed,
    Object? phone = freezed,
    Object? street = null,
    Object? city = null,
    Object? state = freezed,
    Object? postalCode = freezed,
    Object? country = freezed,
    Object? isDefault = null,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      label: freezed == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String?,
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      street: null == street
          ? _value.street
          : street // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      state: freezed == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
      postalCode: freezed == postalCode
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AddressModelImplCopyWith<$Res>
    implements $AddressModelCopyWith<$Res> {
  factory _$$AddressModelImplCopyWith(
          _$AddressModelImpl value, $Res Function(_$AddressModelImpl) then) =
      __$$AddressModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) @JsonKey(fromJson: _parseInt) int id,
      @HiveField(1)
      @JsonKey(name: 'user_id', fromJson: _parseIntNullable)
      int? userId,
      @HiveField(2) String? label,
      @HiveField(3) @JsonKey(name: 'full_name') String? fullName,
      @HiveField(4) String? phone,
      @HiveField(5) String street,
      @HiveField(6) String city,
      @HiveField(7) String? state,
      @HiveField(8) @JsonKey(name: 'postal_code') String? postalCode,
      @HiveField(9) String? country,
      @HiveField(10) @JsonKey(name: 'is_default') bool isDefault,
      @HiveField(11) double? latitude,
      @HiveField(12) double? longitude,
      @HiveField(13) DateTime? createdAt,
      @HiveField(14) DateTime? updatedAt});
}

/// @nodoc
class __$$AddressModelImplCopyWithImpl<$Res>
    extends _$AddressModelCopyWithImpl<$Res, _$AddressModelImpl>
    implements _$$AddressModelImplCopyWith<$Res> {
  __$$AddressModelImplCopyWithImpl(
      _$AddressModelImpl _value, $Res Function(_$AddressModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = freezed,
    Object? label = freezed,
    Object? fullName = freezed,
    Object? phone = freezed,
    Object? street = null,
    Object? city = null,
    Object? state = freezed,
    Object? postalCode = freezed,
    Object? country = freezed,
    Object? isDefault = null,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$AddressModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: freezed == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int?,
      label: freezed == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String?,
      fullName: freezed == fullName
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String?,
      phone: freezed == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String?,
      street: null == street
          ? _value.street
          : street // ignore: cast_nullable_to_non_nullable
              as String,
      city: null == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String,
      state: freezed == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
      postalCode: freezed == postalCode
          ? _value.postalCode
          : postalCode // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      isDefault: null == isDefault
          ? _value.isDefault
          : isDefault // ignore: cast_nullable_to_non_nullable
              as bool,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AddressModelImpl extends _AddressModel {
  const _$AddressModelImpl(
      {@HiveField(0) @JsonKey(fromJson: _parseInt) required this.id,
      @HiveField(1)
      @JsonKey(name: 'user_id', fromJson: _parseIntNullable)
      this.userId,
      @HiveField(2) this.label,
      @HiveField(3) @JsonKey(name: 'full_name') this.fullName,
      @HiveField(4) this.phone,
      @HiveField(5) required this.street,
      @HiveField(6) required this.city,
      @HiveField(7) this.state,
      @HiveField(8) @JsonKey(name: 'postal_code') this.postalCode,
      @HiveField(9) this.country,
      @HiveField(10) @JsonKey(name: 'is_default') this.isDefault = false,
      @HiveField(11) this.latitude,
      @HiveField(12) this.longitude,
      @HiveField(13) this.createdAt,
      @HiveField(14) this.updatedAt})
      : super._();

  factory _$AddressModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$AddressModelImplFromJson(json);

  @override
  @HiveField(0)
  @JsonKey(fromJson: _parseInt)
  final int id;
  @override
  @HiveField(1)
  @JsonKey(name: 'user_id', fromJson: _parseIntNullable)
  final int? userId;
  @override
  @HiveField(2)
  final String? label;
  @override
  @HiveField(3)
  @JsonKey(name: 'full_name')
  final String? fullName;
  @override
  @HiveField(4)
  final String? phone;
  @override
  @HiveField(5)
  final String street;
  @override
  @HiveField(6)
  final String city;
  @override
  @HiveField(7)
  final String? state;
  @override
  @HiveField(8)
  @JsonKey(name: 'postal_code')
  final String? postalCode;
  @override
  @HiveField(9)
  final String? country;
  @override
  @HiveField(10)
  @JsonKey(name: 'is_default')
  final bool isDefault;
  @override
  @HiveField(11)
  final double? latitude;
  @override
  @HiveField(12)
  final double? longitude;
  @override
  @HiveField(13)
  final DateTime? createdAt;
  @override
  @HiveField(14)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'AddressModel(id: $id, userId: $userId, label: $label, fullName: $fullName, phone: $phone, street: $street, city: $city, state: $state, postalCode: $postalCode, country: $country, isDefault: $isDefault, latitude: $latitude, longitude: $longitude, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddressModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.street, street) || other.street == street) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.postalCode, postalCode) ||
                other.postalCode == postalCode) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.isDefault, isDefault) ||
                other.isDefault == isDefault) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      label,
      fullName,
      phone,
      street,
      city,
      state,
      postalCode,
      country,
      isDefault,
      latitude,
      longitude,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AddressModelImplCopyWith<_$AddressModelImpl> get copyWith =>
      __$$AddressModelImplCopyWithImpl<_$AddressModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AddressModelImplToJson(
      this,
    );
  }
}

abstract class _AddressModel extends AddressModel {
  const factory _AddressModel(
      {@HiveField(0) @JsonKey(fromJson: _parseInt) required final int id,
      @HiveField(1)
      @JsonKey(name: 'user_id', fromJson: _parseIntNullable)
      final int? userId,
      @HiveField(2) final String? label,
      @HiveField(3) @JsonKey(name: 'full_name') final String? fullName,
      @HiveField(4) final String? phone,
      @HiveField(5) required final String street,
      @HiveField(6) required final String city,
      @HiveField(7) final String? state,
      @HiveField(8) @JsonKey(name: 'postal_code') final String? postalCode,
      @HiveField(9) final String? country,
      @HiveField(10) @JsonKey(name: 'is_default') final bool isDefault,
      @HiveField(11) final double? latitude,
      @HiveField(12) final double? longitude,
      @HiveField(13) final DateTime? createdAt,
      @HiveField(14) final DateTime? updatedAt}) = _$AddressModelImpl;
  const _AddressModel._() : super._();

  factory _AddressModel.fromJson(Map<String, dynamic> json) =
      _$AddressModelImpl.fromJson;

  @override
  @HiveField(0)
  @JsonKey(fromJson: _parseInt)
  int get id;
  @override
  @HiveField(1)
  @JsonKey(name: 'user_id', fromJson: _parseIntNullable)
  int? get userId;
  @override
  @HiveField(2)
  String? get label;
  @override
  @HiveField(3)
  @JsonKey(name: 'full_name')
  String? get fullName;
  @override
  @HiveField(4)
  String? get phone;
  @override
  @HiveField(5)
  String get street;
  @override
  @HiveField(6)
  String get city;
  @override
  @HiveField(7)
  String? get state;
  @override
  @HiveField(8)
  @JsonKey(name: 'postal_code')
  String? get postalCode;
  @override
  @HiveField(9)
  String? get country;
  @override
  @HiveField(10)
  @JsonKey(name: 'is_default')
  bool get isDefault;
  @override
  @HiveField(11)
  double? get latitude;
  @override
  @HiveField(12)
  double? get longitude;
  @override
  @HiveField(13)
  DateTime? get createdAt;
  @override
  @HiveField(14)
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$AddressModelImplCopyWith<_$AddressModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
