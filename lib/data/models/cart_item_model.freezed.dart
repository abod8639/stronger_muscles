// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

CartItemModel _$CartItemModelFromJson(Map<String, dynamic> json) {
  return _CartItemModel.fromJson(json);
}

/// @nodoc
mixin _$CartItemModel {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @HiveField(2)
  @JsonKey(name: 'product_id')
  String get productId => throw _privateConstructorUsedError;
  @HiveField(3)
  @JsonKey(name: 'product_name')
  String get productName => throw _privateConstructorUsedError;
  @HiveField(4)
  double get price => throw _privateConstructorUsedError;
  @HiveField(5)
  @JsonKey(name: 'image_urls')
  List<String> get imageUrls => throw _privateConstructorUsedError;
  @HiveField(6)
  int get quantity => throw _privateConstructorUsedError;
  @HiveField(7)
  @JsonKey(name: 'added_at')
  DateTime? get addedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CartItemModelCopyWith<CartItemModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartItemModelCopyWith<$Res> {
  factory $CartItemModelCopyWith(
          CartItemModel value, $Res Function(CartItemModel) then) =
      _$CartItemModelCopyWithImpl<$Res, CartItemModel>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) @JsonKey(name: 'user_id') String userId,
      @HiveField(2) @JsonKey(name: 'product_id') String productId,
      @HiveField(3) @JsonKey(name: 'product_name') String productName,
      @HiveField(4) double price,
      @HiveField(5) @JsonKey(name: 'image_urls') List<String> imageUrls,
      @HiveField(6) int quantity,
      @HiveField(7) @JsonKey(name: 'added_at') DateTime? addedAt});
}

/// @nodoc
class _$CartItemModelCopyWithImpl<$Res, $Val extends CartItemModel>
    implements $CartItemModelCopyWith<$Res> {
  _$CartItemModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? productId = null,
    Object? productName = null,
    Object? price = null,
    Object? imageUrls = null,
    Object? quantity = null,
    Object? addedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      imageUrls: null == imageUrls
          ? _value.imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      addedAt: freezed == addedAt
          ? _value.addedAt
          : addedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CartItemModelImplCopyWith<$Res>
    implements $CartItemModelCopyWith<$Res> {
  factory _$$CartItemModelImplCopyWith(
          _$CartItemModelImpl value, $Res Function(_$CartItemModelImpl) then) =
      __$$CartItemModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) @JsonKey(name: 'user_id') String userId,
      @HiveField(2) @JsonKey(name: 'product_id') String productId,
      @HiveField(3) @JsonKey(name: 'product_name') String productName,
      @HiveField(4) double price,
      @HiveField(5) @JsonKey(name: 'image_urls') List<String> imageUrls,
      @HiveField(6) int quantity,
      @HiveField(7) @JsonKey(name: 'added_at') DateTime? addedAt});
}

/// @nodoc
class __$$CartItemModelImplCopyWithImpl<$Res>
    extends _$CartItemModelCopyWithImpl<$Res, _$CartItemModelImpl>
    implements _$$CartItemModelImplCopyWith<$Res> {
  __$$CartItemModelImplCopyWithImpl(
      _$CartItemModelImpl _value, $Res Function(_$CartItemModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? productId = null,
    Object? productName = null,
    Object? price = null,
    Object? imageUrls = null,
    Object? quantity = null,
    Object? addedAt = freezed,
  }) {
    return _then(_$CartItemModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      productId: null == productId
          ? _value.productId
          : productId // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      imageUrls: null == imageUrls
          ? _value._imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      addedAt: freezed == addedAt
          ? _value.addedAt
          : addedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
@HiveType(typeId: 0, adapterName: 'CartItemModelAdapter')
class _$CartItemModelImpl extends _CartItemModel {
  const _$CartItemModelImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) @JsonKey(name: 'user_id') required this.userId,
      @HiveField(2) @JsonKey(name: 'product_id') required this.productId,
      @HiveField(3) @JsonKey(name: 'product_name') required this.productName,
      @HiveField(4) required this.price,
      @HiveField(5)
      @JsonKey(name: 'image_urls')
      final List<String> imageUrls = const [],
      @HiveField(6) this.quantity = 1,
      @HiveField(7) @JsonKey(name: 'added_at') this.addedAt})
      : _imageUrls = imageUrls,
        super._();

  factory _$CartItemModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$CartItemModelImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @HiveField(2)
  @JsonKey(name: 'product_id')
  final String productId;
  @override
  @HiveField(3)
  @JsonKey(name: 'product_name')
  final String productName;
  @override
  @HiveField(4)
  final double price;
  final List<String> _imageUrls;
  @override
  @HiveField(5)
  @JsonKey(name: 'image_urls')
  List<String> get imageUrls {
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imageUrls);
  }

  @override
  @JsonKey()
  @HiveField(6)
  final int quantity;
  @override
  @HiveField(7)
  @JsonKey(name: 'added_at')
  final DateTime? addedAt;

  @override
  String toString() {
    return 'CartItemModel(id: $id, userId: $userId, productId: $productId, productName: $productName, price: $price, imageUrls: $imageUrls, quantity: $quantity, addedAt: $addedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartItemModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.price, price) || other.price == price) &&
            const DeepCollectionEquality()
                .equals(other._imageUrls, _imageUrls) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.addedAt, addedAt) || other.addedAt == addedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      productId,
      productName,
      price,
      const DeepCollectionEquality().hash(_imageUrls),
      quantity,
      addedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CartItemModelImplCopyWith<_$CartItemModelImpl> get copyWith =>
      __$$CartItemModelImplCopyWithImpl<_$CartItemModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CartItemModelImplToJson(
      this,
    );
  }
}

abstract class _CartItemModel extends CartItemModel {
  const factory _CartItemModel(
      {@HiveField(0) required final String id,
      @HiveField(1) @JsonKey(name: 'user_id') required final String userId,
      @HiveField(2)
      @JsonKey(name: 'product_id')
      required final String productId,
      @HiveField(3)
      @JsonKey(name: 'product_name')
      required final String productName,
      @HiveField(4) required final double price,
      @HiveField(5) @JsonKey(name: 'image_urls') final List<String> imageUrls,
      @HiveField(6) final int quantity,
      @HiveField(7)
      @JsonKey(name: 'added_at')
      final DateTime? addedAt}) = _$CartItemModelImpl;
  const _CartItemModel._() : super._();

  factory _CartItemModel.fromJson(Map<String, dynamic> json) =
      _$CartItemModelImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @HiveField(2)
  @JsonKey(name: 'product_id')
  String get productId;
  @override
  @HiveField(3)
  @JsonKey(name: 'product_name')
  String get productName;
  @override
  @HiveField(4)
  double get price;
  @override
  @HiveField(5)
  @JsonKey(name: 'image_urls')
  List<String> get imageUrls;
  @override
  @HiveField(6)
  int get quantity;
  @override
  @HiveField(7)
  @JsonKey(name: 'added_at')
  DateTime? get addedAt;
  @override
  @JsonKey(ignore: true)
  _$$CartItemModelImplCopyWith<_$CartItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
