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
  ProductModel get product => throw _privateConstructorUsedError;
  @HiveField(3)
  int get quantity => throw _privateConstructorUsedError;
  @HiveField(4)
  @JsonKey(name: 'added_at')
  DateTime? get addedAt => throw _privateConstructorUsedError;
  @HiveField(5)
  @JsonKey(name: 'selected_flavor')
  String? get selectedFlavor => throw _privateConstructorUsedError;

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
      @HiveField(2) ProductModel product,
      @HiveField(3) int quantity,
      @HiveField(4) @JsonKey(name: 'added_at') DateTime? addedAt,
      @HiveField(5) @JsonKey(name: 'selected_flavor') String? selectedFlavor});

  $ProductModelCopyWith<$Res> get product;
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
    Object? product = null,
    Object? quantity = null,
    Object? addedAt = freezed,
    Object? selectedFlavor = freezed,
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
      product: null == product
          ? _value.product
          : product // ignore: cast_nullable_to_non_nullable
              as ProductModel,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      addedAt: freezed == addedAt
          ? _value.addedAt
          : addedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      selectedFlavor: freezed == selectedFlavor
          ? _value.selectedFlavor
          : selectedFlavor // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ProductModelCopyWith<$Res> get product {
    return $ProductModelCopyWith<$Res>(_value.product, (value) {
      return _then(_value.copyWith(product: value) as $Val);
    });
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
      @HiveField(2) ProductModel product,
      @HiveField(3) int quantity,
      @HiveField(4) @JsonKey(name: 'added_at') DateTime? addedAt,
      @HiveField(5) @JsonKey(name: 'selected_flavor') String? selectedFlavor});

  @override
  $ProductModelCopyWith<$Res> get product;
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
    Object? product = null,
    Object? quantity = null,
    Object? addedAt = freezed,
    Object? selectedFlavor = freezed,
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
      product: null == product
          ? _value.product
          : product // ignore: cast_nullable_to_non_nullable
              as ProductModel,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      addedAt: freezed == addedAt
          ? _value.addedAt
          : addedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      selectedFlavor: freezed == selectedFlavor
          ? _value.selectedFlavor
          : selectedFlavor // ignore: cast_nullable_to_non_nullable
              as String?,
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
      @HiveField(2) required this.product,
      @HiveField(3) this.quantity = 1,
      @HiveField(4) @JsonKey(name: 'added_at') this.addedAt,
      @HiveField(5) @JsonKey(name: 'selected_flavor') this.selectedFlavor})
      : super._();

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
  final ProductModel product;
  @override
  @JsonKey()
  @HiveField(3)
  final int quantity;
  @override
  @HiveField(4)
  @JsonKey(name: 'added_at')
  final DateTime? addedAt;
  @override
  @HiveField(5)
  @JsonKey(name: 'selected_flavor')
  final String? selectedFlavor;

  @override
  String toString() {
    return 'CartItemModel(id: $id, userId: $userId, product: $product, quantity: $quantity, addedAt: $addedAt, selectedFlavor: $selectedFlavor)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartItemModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.product, product) || other.product == product) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.addedAt, addedAt) || other.addedAt == addedAt) &&
            (identical(other.selectedFlavor, selectedFlavor) ||
                other.selectedFlavor == selectedFlavor));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, userId, product, quantity, addedAt, selectedFlavor);

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
      @HiveField(2) required final ProductModel product,
      @HiveField(3) final int quantity,
      @HiveField(4) @JsonKey(name: 'added_at') final DateTime? addedAt,
      @HiveField(5)
      @JsonKey(name: 'selected_flavor')
      final String? selectedFlavor}) = _$CartItemModelImpl;
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
  ProductModel get product;
  @override
  @HiveField(3)
  int get quantity;
  @override
  @HiveField(4)
  @JsonKey(name: 'added_at')
  DateTime? get addedAt;
  @override
  @HiveField(5)
  @JsonKey(name: 'selected_flavor')
  String? get selectedFlavor;
  @override
  @JsonKey(ignore: true)
  _$$CartItemModelImplCopyWith<_$CartItemModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
