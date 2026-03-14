// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_stats_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserStats _$UserStatsFromJson(Map<String, dynamic> json) {
  return _UserStats.fromJson(json);
}

/// @nodoc
mixin _$UserStats {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  @JsonKey(name: 'photo_url')
  String? get photoUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'has_ordered')
  bool get hasOrdered => throw _privateConstructorUsedError;
  @JsonKey(name: 'orders_count')
  int get ordersCount => throw _privateConstructorUsedError;
  List<OrderModel> get orders => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserStatsCopyWith<UserStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserStatsCopyWith<$Res> {
  factory $UserStatsCopyWith(UserStats value, $Res Function(UserStats) then) =
      _$UserStatsCopyWithImpl<$Res, UserStats>;
  @useResult
  $Res call(
      {int id,
      String name,
      @JsonKey(name: 'photo_url') String? photoUrl,
      @JsonKey(name: 'has_ordered') bool hasOrdered,
      @JsonKey(name: 'orders_count') int ordersCount,
      List<OrderModel> orders});
}

/// @nodoc
class _$UserStatsCopyWithImpl<$Res, $Val extends UserStats>
    implements $UserStatsCopyWith<$Res> {
  _$UserStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? photoUrl = freezed,
    Object? hasOrdered = null,
    Object? ordersCount = null,
    Object? orders = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      hasOrdered: null == hasOrdered
          ? _value.hasOrdered
          : hasOrdered // ignore: cast_nullable_to_non_nullable
              as bool,
      ordersCount: null == ordersCount
          ? _value.ordersCount
          : ordersCount // ignore: cast_nullable_to_non_nullable
              as int,
      orders: null == orders
          ? _value.orders
          : orders // ignore: cast_nullable_to_non_nullable
              as List<OrderModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserStatsImplCopyWith<$Res>
    implements $UserStatsCopyWith<$Res> {
  factory _$$UserStatsImplCopyWith(
          _$UserStatsImpl value, $Res Function(_$UserStatsImpl) then) =
      __$$UserStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      @JsonKey(name: 'photo_url') String? photoUrl,
      @JsonKey(name: 'has_ordered') bool hasOrdered,
      @JsonKey(name: 'orders_count') int ordersCount,
      List<OrderModel> orders});
}

/// @nodoc
class __$$UserStatsImplCopyWithImpl<$Res>
    extends _$UserStatsCopyWithImpl<$Res, _$UserStatsImpl>
    implements _$$UserStatsImplCopyWith<$Res> {
  __$$UserStatsImplCopyWithImpl(
      _$UserStatsImpl _value, $Res Function(_$UserStatsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? photoUrl = freezed,
    Object? hasOrdered = null,
    Object? ordersCount = null,
    Object? orders = null,
  }) {
    return _then(_$UserStatsImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      photoUrl: freezed == photoUrl
          ? _value.photoUrl
          : photoUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      hasOrdered: null == hasOrdered
          ? _value.hasOrdered
          : hasOrdered // ignore: cast_nullable_to_non_nullable
              as bool,
      ordersCount: null == ordersCount
          ? _value.ordersCount
          : ordersCount // ignore: cast_nullable_to_non_nullable
              as int,
      orders: null == orders
          ? _value._orders
          : orders // ignore: cast_nullable_to_non_nullable
              as List<OrderModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserStatsImpl implements _UserStats {
  const _$UserStatsImpl(
      {required this.id,
      required this.name,
      @JsonKey(name: 'photo_url') this.photoUrl,
      @JsonKey(name: 'has_ordered') required this.hasOrdered,
      @JsonKey(name: 'orders_count') required this.ordersCount,
      required final List<OrderModel> orders})
      : _orders = orders;

  factory _$UserStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserStatsImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
  @override
  @JsonKey(name: 'photo_url')
  final String? photoUrl;
  @override
  @JsonKey(name: 'has_ordered')
  final bool hasOrdered;
  @override
  @JsonKey(name: 'orders_count')
  final int ordersCount;
  final List<OrderModel> _orders;
  @override
  List<OrderModel> get orders {
    if (_orders is EqualUnmodifiableListView) return _orders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_orders);
  }

  @override
  String toString() {
    return 'UserStats(id: $id, name: $name, photoUrl: $photoUrl, hasOrdered: $hasOrdered, ordersCount: $ordersCount, orders: $orders)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserStatsImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.photoUrl, photoUrl) ||
                other.photoUrl == photoUrl) &&
            (identical(other.hasOrdered, hasOrdered) ||
                other.hasOrdered == hasOrdered) &&
            (identical(other.ordersCount, ordersCount) ||
                other.ordersCount == ordersCount) &&
            const DeepCollectionEquality().equals(other._orders, _orders));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, photoUrl, hasOrdered,
      ordersCount, const DeepCollectionEquality().hash(_orders));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserStatsImplCopyWith<_$UserStatsImpl> get copyWith =>
      __$$UserStatsImplCopyWithImpl<_$UserStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserStatsImplToJson(
      this,
    );
  }
}

abstract class _UserStats implements UserStats {
  const factory _UserStats(
      {required final int id,
      required final String name,
      @JsonKey(name: 'photo_url') final String? photoUrl,
      @JsonKey(name: 'has_ordered') required final bool hasOrdered,
      @JsonKey(name: 'orders_count') required final int ordersCount,
      required final List<OrderModel> orders}) = _$UserStatsImpl;

  factory _UserStats.fromJson(Map<String, dynamic> json) =
      _$UserStatsImpl.fromJson;

  @override
  int get id;
  @override
  String get name;
  @override
  @JsonKey(name: 'photo_url')
  String? get photoUrl;
  @override
  @JsonKey(name: 'has_ordered')
  bool get hasOrdered;
  @override
  @JsonKey(name: 'orders_count')
  int get ordersCount;
  @override
  List<OrderModel> get orders;
  @override
  @JsonKey(ignore: true)
  _$$UserStatsImplCopyWith<_$UserStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UsersStatsResponse _$UsersStatsResponseFromJson(Map<String, dynamic> json) {
  return _UsersStatsResponse.fromJson(json);
}

/// @nodoc
mixin _$UsersStatsResponse {
  @JsonKey(name: 'total_users')
  int get totalUsers => throw _privateConstructorUsedError;
  List<UserStats> get users => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UsersStatsResponseCopyWith<UsersStatsResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UsersStatsResponseCopyWith<$Res> {
  factory $UsersStatsResponseCopyWith(
          UsersStatsResponse value, $Res Function(UsersStatsResponse) then) =
      _$UsersStatsResponseCopyWithImpl<$Res, UsersStatsResponse>;
  @useResult
  $Res call(
      {@JsonKey(name: 'total_users') int totalUsers, List<UserStats> users});
}

/// @nodoc
class _$UsersStatsResponseCopyWithImpl<$Res, $Val extends UsersStatsResponse>
    implements $UsersStatsResponseCopyWith<$Res> {
  _$UsersStatsResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalUsers = null,
    Object? users = null,
  }) {
    return _then(_value.copyWith(
      totalUsers: null == totalUsers
          ? _value.totalUsers
          : totalUsers // ignore: cast_nullable_to_non_nullable
              as int,
      users: null == users
          ? _value.users
          : users // ignore: cast_nullable_to_non_nullable
              as List<UserStats>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UsersStatsResponseImplCopyWith<$Res>
    implements $UsersStatsResponseCopyWith<$Res> {
  factory _$$UsersStatsResponseImplCopyWith(_$UsersStatsResponseImpl value,
          $Res Function(_$UsersStatsResponseImpl) then) =
      __$$UsersStatsResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'total_users') int totalUsers, List<UserStats> users});
}

/// @nodoc
class __$$UsersStatsResponseImplCopyWithImpl<$Res>
    extends _$UsersStatsResponseCopyWithImpl<$Res, _$UsersStatsResponseImpl>
    implements _$$UsersStatsResponseImplCopyWith<$Res> {
  __$$UsersStatsResponseImplCopyWithImpl(_$UsersStatsResponseImpl _value,
      $Res Function(_$UsersStatsResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalUsers = null,
    Object? users = null,
  }) {
    return _then(_$UsersStatsResponseImpl(
      totalUsers: null == totalUsers
          ? _value.totalUsers
          : totalUsers // ignore: cast_nullable_to_non_nullable
              as int,
      users: null == users
          ? _value._users
          : users // ignore: cast_nullable_to_non_nullable
              as List<UserStats>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UsersStatsResponseImpl implements _UsersStatsResponse {
  const _$UsersStatsResponseImpl(
      {@JsonKey(name: 'total_users') required this.totalUsers,
      required final List<UserStats> users})
      : _users = users;

  factory _$UsersStatsResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$UsersStatsResponseImplFromJson(json);

  @override
  @JsonKey(name: 'total_users')
  final int totalUsers;
  final List<UserStats> _users;
  @override
  List<UserStats> get users {
    if (_users is EqualUnmodifiableListView) return _users;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_users);
  }

  @override
  String toString() {
    return 'UsersStatsResponse(totalUsers: $totalUsers, users: $users)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UsersStatsResponseImpl &&
            (identical(other.totalUsers, totalUsers) ||
                other.totalUsers == totalUsers) &&
            const DeepCollectionEquality().equals(other._users, _users));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, totalUsers, const DeepCollectionEquality().hash(_users));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UsersStatsResponseImplCopyWith<_$UsersStatsResponseImpl> get copyWith =>
      __$$UsersStatsResponseImplCopyWithImpl<_$UsersStatsResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UsersStatsResponseImplToJson(
      this,
    );
  }
}

abstract class _UsersStatsResponse implements UsersStatsResponse {
  const factory _UsersStatsResponse(
      {@JsonKey(name: 'total_users') required final int totalUsers,
      required final List<UserStats> users}) = _$UsersStatsResponseImpl;

  factory _UsersStatsResponse.fromJson(Map<String, dynamic> json) =
      _$UsersStatsResponseImpl.fromJson;

  @override
  @JsonKey(name: 'total_users')
  int get totalUsers;
  @override
  List<UserStats> get users;
  @override
  @JsonKey(ignore: true)
  _$$UsersStatsResponseImplCopyWith<_$UsersStatsResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
