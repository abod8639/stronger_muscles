// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

UserModel _$UserModelFromJson(Map<String, dynamic> json) {
  return _UserModel.fromJson(json);
}

/// @nodoc
mixin _$UserModel {
  @HiveField(0)
  @JsonKey(fromJson: _parseInt)
  int get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get email => throw _privateConstructorUsedError;
  @HiveField(2)
  String get name => throw _privateConstructorUsedError;
  @HiveField(3)
  @JsonKey(name: 'photo_url')
  String? get photoUrl => throw _privateConstructorUsedError;
  @HiveField(4)
  String? get phone => throw _privateConstructorUsedError;
  @HiveField(5)
  @JsonKey(name: 'default_address_id')
  String? get defaultAddressId => throw _privateConstructorUsedError;
  @HiveField(6)
  @JsonKey(name: 'preferred_language')
  String? get preferredLanguage => throw _privateConstructorUsedError;
  @HiveField(7)
  @JsonKey(name: 'notifications_enabled', fromJson: _boolFromInt)
  bool get notificationsEnabled => throw _privateConstructorUsedError;
  @HiveField(8)
  @JsonKey(name: 'is_active', fromJson: _boolFromInt)
  bool get isActive => throw _privateConstructorUsedError;
  @HiveField(9)
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @HiveField(10)
  @JsonKey(name: 'last_login')
  DateTime? get lastLogin => throw _privateConstructorUsedError;
  @HiveField(11)
  String? get token => throw _privateConstructorUsedError;
  @HiveField(12)
  String? get role => throw _privateConstructorUsedError;
  @HiveField(13)
  @JsonKey(name: 'total_spent')
  double? get totalSpent => throw _privateConstructorUsedError;
  @HiveField(14)
  @JsonKey(name: 'orders_count')
  int? get ordersCount => throw _privateConstructorUsedError;
  @HiveField(15)
  List<AddressModel>? get addresses => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserModelCopyWith<UserModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserModelCopyWith<$Res> {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) then) =
      _$UserModelCopyWithImpl<$Res, UserModel>;
  @useResult
  $Res call({
    @HiveField(0) @JsonKey(fromJson: _parseInt) int id,
    @HiveField(1) String email,
    @HiveField(2) String name,
    @HiveField(3) @JsonKey(name: 'photo_url') String? photoUrl,
    @HiveField(4) String? phone,
    @HiveField(5) @JsonKey(name: 'default_address_id') String? defaultAddressId,
    @HiveField(6)
    @JsonKey(name: 'preferred_language')
    String? preferredLanguage,
    @HiveField(7)
    @JsonKey(name: 'notifications_enabled', fromJson: _boolFromInt)
    bool notificationsEnabled,
    @HiveField(8)
    @JsonKey(name: 'is_active', fromJson: _boolFromInt)
    bool isActive,
    @HiveField(9) @JsonKey(name: 'created_at') DateTime? createdAt,
    @HiveField(10) @JsonKey(name: 'last_login') DateTime? lastLogin,
    @HiveField(11) String? token,
    @HiveField(12) String? role,
    @HiveField(13) @JsonKey(name: 'total_spent') double? totalSpent,
    @HiveField(14) @JsonKey(name: 'orders_count') int? ordersCount,
    @HiveField(15) List<AddressModel>? addresses,
  });
}

/// @nodoc
class _$UserModelCopyWithImpl<$Res, $Val extends UserModel>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? name = null,
    Object? photoUrl = freezed,
    Object? phone = freezed,
    Object? defaultAddressId = freezed,
    Object? preferredLanguage = freezed,
    Object? notificationsEnabled = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? lastLogin = freezed,
    Object? token = freezed,
    Object? role = freezed,
    Object? totalSpent = freezed,
    Object? ordersCount = freezed,
    Object? addresses = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as int,
            email: null == email
                ? _value.email
                : email // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            photoUrl: freezed == photoUrl
                ? _value.photoUrl
                : photoUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            defaultAddressId: freezed == defaultAddressId
                ? _value.defaultAddressId
                : defaultAddressId // ignore: cast_nullable_to_non_nullable
                      as String?,
            preferredLanguage: freezed == preferredLanguage
                ? _value.preferredLanguage
                : preferredLanguage // ignore: cast_nullable_to_non_nullable
                      as String?,
            notificationsEnabled: null == notificationsEnabled
                ? _value.notificationsEnabled
                : notificationsEnabled // ignore: cast_nullable_to_non_nullable
                      as bool,
            isActive: null == isActive
                ? _value.isActive
                : isActive // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            lastLogin: freezed == lastLogin
                ? _value.lastLogin
                : lastLogin // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            token: freezed == token
                ? _value.token
                : token // ignore: cast_nullable_to_non_nullable
                      as String?,
            role: freezed == role
                ? _value.role
                : role // ignore: cast_nullable_to_non_nullable
                      as String?,
            totalSpent: freezed == totalSpent
                ? _value.totalSpent
                : totalSpent // ignore: cast_nullable_to_non_nullable
                      as double?,
            ordersCount: freezed == ordersCount
                ? _value.ordersCount
                : ordersCount // ignore: cast_nullable_to_non_nullable
                      as int?,
            addresses: freezed == addresses
                ? _value.addresses
                : addresses // ignore: cast_nullable_to_non_nullable
                      as List<AddressModel>?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$UserModelImplCopyWith<$Res>
    implements $UserModelCopyWith<$Res> {
  factory _$$UserModelImplCopyWith(
    _$UserModelImpl value,
    $Res Function(_$UserModelImpl) then,
  ) = __$$UserModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @HiveField(0) @JsonKey(fromJson: _parseInt) int id,
    @HiveField(1) String email,
    @HiveField(2) String name,
    @HiveField(3) @JsonKey(name: 'photo_url') String? photoUrl,
    @HiveField(4) String? phone,
    @HiveField(5) @JsonKey(name: 'default_address_id') String? defaultAddressId,
    @HiveField(6)
    @JsonKey(name: 'preferred_language')
    String? preferredLanguage,
    @HiveField(7)
    @JsonKey(name: 'notifications_enabled', fromJson: _boolFromInt)
    bool notificationsEnabled,
    @HiveField(8)
    @JsonKey(name: 'is_active', fromJson: _boolFromInt)
    bool isActive,
    @HiveField(9) @JsonKey(name: 'created_at') DateTime? createdAt,
    @HiveField(10) @JsonKey(name: 'last_login') DateTime? lastLogin,
    @HiveField(11) String? token,
    @HiveField(12) String? role,
    @HiveField(13) @JsonKey(name: 'total_spent') double? totalSpent,
    @HiveField(14) @JsonKey(name: 'orders_count') int? ordersCount,
    @HiveField(15) List<AddressModel>? addresses,
  });
}

/// @nodoc
class __$$UserModelImplCopyWithImpl<$Res>
    extends _$UserModelCopyWithImpl<$Res, _$UserModelImpl>
    implements _$$UserModelImplCopyWith<$Res> {
  __$$UserModelImplCopyWithImpl(
    _$UserModelImpl _value,
    $Res Function(_$UserModelImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? name = null,
    Object? photoUrl = freezed,
    Object? phone = freezed,
    Object? defaultAddressId = freezed,
    Object? preferredLanguage = freezed,
    Object? notificationsEnabled = null,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? lastLogin = freezed,
    Object? token = freezed,
    Object? role = freezed,
    Object? totalSpent = freezed,
    Object? ordersCount = freezed,
    Object? addresses = freezed,
  }) {
    return _then(
      _$UserModelImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as int,
        email: null == email
            ? _value.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        photoUrl: freezed == photoUrl
            ? _value.photoUrl
            : photoUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        defaultAddressId: freezed == defaultAddressId
            ? _value.defaultAddressId
            : defaultAddressId // ignore: cast_nullable_to_non_nullable
                  as String?,
        preferredLanguage: freezed == preferredLanguage
            ? _value.preferredLanguage
            : preferredLanguage // ignore: cast_nullable_to_non_nullable
                  as String?,
        notificationsEnabled: null == notificationsEnabled
            ? _value.notificationsEnabled
            : notificationsEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        isActive: null == isActive
            ? _value.isActive
            : isActive // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        lastLogin: freezed == lastLogin
            ? _value.lastLogin
            : lastLogin // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        token: freezed == token
            ? _value.token
            : token // ignore: cast_nullable_to_non_nullable
                  as String?,
        role: freezed == role
            ? _value.role
            : role // ignore: cast_nullable_to_non_nullable
                  as String?,
        totalSpent: freezed == totalSpent
            ? _value.totalSpent
            : totalSpent // ignore: cast_nullable_to_non_nullable
                  as double?,
        ordersCount: freezed == ordersCount
            ? _value.ordersCount
            : ordersCount // ignore: cast_nullable_to_non_nullable
                  as int?,
        addresses: freezed == addresses
            ? _value._addresses
            : addresses // ignore: cast_nullable_to_non_nullable
                  as List<AddressModel>?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$UserModelImpl extends _UserModel {
  const _$UserModelImpl({
    @HiveField(0) @JsonKey(fromJson: _parseInt) required this.id,
    @HiveField(1) required this.email,
    @HiveField(2) required this.name,
    @HiveField(3) @JsonKey(name: 'photo_url') this.photoUrl,
    @HiveField(4) this.phone,
    @HiveField(5) @JsonKey(name: 'default_address_id') this.defaultAddressId,
    @HiveField(6)
    @JsonKey(name: 'preferred_language')
    this.preferredLanguage = 'ar',
    @HiveField(7)
    @JsonKey(name: 'notifications_enabled', fromJson: _boolFromInt)
    this.notificationsEnabled = true,
    @HiveField(8)
    @JsonKey(name: 'is_active', fromJson: _boolFromInt)
    this.isActive = true,
    @HiveField(9) @JsonKey(name: 'created_at') this.createdAt,
    @HiveField(10) @JsonKey(name: 'last_login') this.lastLogin,
    @HiveField(11) this.token,
    @HiveField(12) this.role,
    @HiveField(13) @JsonKey(name: 'total_spent') this.totalSpent,
    @HiveField(14) @JsonKey(name: 'orders_count') this.ordersCount,
    @HiveField(15) final List<AddressModel>? addresses,
  }) : _addresses = addresses,
       super._();

  factory _$UserModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserModelImplFromJson(json);

  @override
  @HiveField(0)
  @JsonKey(fromJson: _parseInt)
  final int id;
  @override
  @HiveField(1)
  final String email;
  @override
  @HiveField(2)
  final String name;
  @override
  @HiveField(3)
  @JsonKey(name: 'photo_url')
  final String? photoUrl;
  @override
  @HiveField(4)
  final String? phone;
  @override
  @HiveField(5)
  @JsonKey(name: 'default_address_id')
  final String? defaultAddressId;
  @override
  @HiveField(6)
  @JsonKey(name: 'preferred_language')
  final String? preferredLanguage;
  @override
  @HiveField(7)
  @JsonKey(name: 'notifications_enabled', fromJson: _boolFromInt)
  final bool notificationsEnabled;
  @override
  @HiveField(8)
  @JsonKey(name: 'is_active', fromJson: _boolFromInt)
  final bool isActive;
  @override
  @HiveField(9)
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @HiveField(10)
  @JsonKey(name: 'last_login')
  final DateTime? lastLogin;
  @override
  @HiveField(11)
  final String? token;
  @override
  @HiveField(12)
  final String? role;
  @override
  @HiveField(13)
  @JsonKey(name: 'total_spent')
  final double? totalSpent;
  @override
  @HiveField(14)
  @JsonKey(name: 'orders_count')
  final int? ordersCount;
  final List<AddressModel>? _addresses;
  @override
  @HiveField(15)
  List<AddressModel>? get addresses {
    final value = _addresses;
    if (value == null) return null;
    if (_addresses is EqualUnmodifiableListView) return _addresses;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, name: $name, photoUrl: $photoUrl, phone: $phone, defaultAddressId: $defaultAddressId, preferredLanguage: $preferredLanguage, notificationsEnabled: $notificationsEnabled, isActive: $isActive, createdAt: $createdAt, lastLogin: $lastLogin, token: $token, role: $role, totalSpent: $totalSpent, ordersCount: $ordersCount, addresses: $addresses)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.defaultAddressId, defaultAddressId) ||
                other.defaultAddressId == defaultAddressId) &&
            (identical(other.preferredLanguage, preferredLanguage) ||
                other.preferredLanguage == preferredLanguage) &&
            (identical(other.notificationsEnabled, notificationsEnabled) ||
                other.notificationsEnabled == notificationsEnabled) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.lastLogin, lastLogin) ||
                other.lastLogin == lastLogin) &&
            (identical(other.token, token) || other.token == token) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.totalSpent, totalSpent) ||
                other.totalSpent == totalSpent) &&
            (identical(other.ordersCount, ordersCount) ||
                other.ordersCount == ordersCount) &&
            const DeepCollectionEquality().equals(
              other._addresses,
              _addresses,
            ));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    email,
    name,
    photoUrl,
    phone,
    defaultAddressId,
    preferredLanguage,
    notificationsEnabled,
    isActive,
    createdAt,
    lastLogin,
    token,
    role,
    totalSpent,
    ordersCount,
    const DeepCollectionEquality().hash(_addresses),
  );

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      __$$UserModelImplCopyWithImpl<_$UserModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserModelImplToJson(this);
  }
}

abstract class _UserModel extends UserModel {
  const factory _UserModel({
    @HiveField(0) @JsonKey(fromJson: _parseInt) required final int id,
    @HiveField(1) required final String email,
    @HiveField(2) required final String name,
    @HiveField(3) @JsonKey(name: 'photo_url') final String? photoUrl,
    @HiveField(4) final String? phone,
    @HiveField(5)
    @JsonKey(name: 'default_address_id')
    final String? defaultAddressId,
    @HiveField(6)
    @JsonKey(name: 'preferred_language')
    final String? preferredLanguage,
    @HiveField(7)
    @JsonKey(name: 'notifications_enabled', fromJson: _boolFromInt)
    final bool notificationsEnabled,
    @HiveField(8)
    @JsonKey(name: 'is_active', fromJson: _boolFromInt)
    final bool isActive,
    @HiveField(9) @JsonKey(name: 'created_at') final DateTime? createdAt,
    @HiveField(10) @JsonKey(name: 'last_login') final DateTime? lastLogin,
    @HiveField(11) final String? token,
    @HiveField(12) final String? role,
    @HiveField(13) @JsonKey(name: 'total_spent') final double? totalSpent,
    @HiveField(14) @JsonKey(name: 'orders_count') final int? ordersCount,
    @HiveField(15) final List<AddressModel>? addresses,
  }) = _$UserModelImpl;
  const _UserModel._() : super._();

  factory _UserModel.fromJson(Map<String, dynamic> json) =
      _$UserModelImpl.fromJson;

  @override
  @HiveField(0)
  @JsonKey(fromJson: _parseInt)
  int get id;
  @override
  @HiveField(1)
  String get email;
  @override
  @HiveField(2)
  String get name;
  @override
  @HiveField(3)
  @JsonKey(name: 'photo_url')
  String? get photoUrl;
  @override
  @HiveField(4)
  String? get phone;
  @override
  @HiveField(5)
  @JsonKey(name: 'default_address_id')
  String? get defaultAddressId;
  @override
  @HiveField(6)
  @JsonKey(name: 'preferred_language')
  String? get preferredLanguage;
  @override
  @HiveField(7)
  @JsonKey(name: 'notifications_enabled', fromJson: _boolFromInt)
  bool get notificationsEnabled;
  @override
  @HiveField(8)
  @JsonKey(name: 'is_active', fromJson: _boolFromInt)
  bool get isActive;
  @override
  @HiveField(9)
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @HiveField(10)
  @JsonKey(name: 'last_login')
  DateTime? get lastLogin;
  @override
  @HiveField(11)
  String? get token;
  @override
  @HiveField(12)
  String? get role;
  @override
  @HiveField(13)
  @JsonKey(name: 'total_spent')
  double? get totalSpent;
  @override
  @HiveField(14)
  @JsonKey(name: 'orders_count')
  int? get ordersCount;
  @override
  @HiveField(15)
  List<AddressModel>? get addresses;
  @override
  @JsonKey(ignore: true)
  _$$UserModelImplCopyWith<_$UserModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
