// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_size_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProductSize _$ProductSizeFromJson(Map<String, dynamic> json) {
  return _ProductSize.fromJson(json);
}

/// @nodoc
mixin _$ProductSize {
  @HiveField(0)
  @JsonKey(name: 'size')
  String get size => throw _privateConstructorUsedError;
  @HiveField(1)
  @JsonKey(name: 'price')
  double get price => throw _privateConstructorUsedError;
  @HiveField(2)
  @JsonKey(name: 'discount_price')
  double? get discountPrice => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProductSizeCopyWith<ProductSize> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductSizeCopyWith<$Res> {
  factory $ProductSizeCopyWith(
    ProductSize value,
    $Res Function(ProductSize) then,
  ) = _$ProductSizeCopyWithImpl<$Res, ProductSize>;
  @useResult
  $Res call({
    @HiveField(0) @JsonKey(name: 'size') String size,
    @HiveField(1) @JsonKey(name: 'price') double price,
    @HiveField(2) @JsonKey(name: 'discount_price') double? discountPrice,
  });
}

/// @nodoc
class _$ProductSizeCopyWithImpl<$Res, $Val extends ProductSize>
    implements $ProductSizeCopyWith<$Res> {
  _$ProductSizeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? size = null,
    Object? price = null,
    Object? discountPrice = freezed,
  }) {
    return _then(
      _value.copyWith(
            size: null == size
                ? _value.size
                : size // ignore: cast_nullable_to_non_nullable
                      as String,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
            discountPrice: freezed == discountPrice
                ? _value.discountPrice
                : discountPrice // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProductSizeImplCopyWith<$Res>
    implements $ProductSizeCopyWith<$Res> {
  factory _$$ProductSizeImplCopyWith(
    _$ProductSizeImpl value,
    $Res Function(_$ProductSizeImpl) then,
  ) = __$$ProductSizeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    @HiveField(0) @JsonKey(name: 'size') String size,
    @HiveField(1) @JsonKey(name: 'price') double price,
    @HiveField(2) @JsonKey(name: 'discount_price') double? discountPrice,
  });
}

/// @nodoc
class __$$ProductSizeImplCopyWithImpl<$Res>
    extends _$ProductSizeCopyWithImpl<$Res, _$ProductSizeImpl>
    implements _$$ProductSizeImplCopyWith<$Res> {
  __$$ProductSizeImplCopyWithImpl(
    _$ProductSizeImpl _value,
    $Res Function(_$ProductSizeImpl) _then,
  ) : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? size = null,
    Object? price = null,
    Object? discountPrice = freezed,
  }) {
    return _then(
      _$ProductSizeImpl(
        size: null == size
            ? _value.size
            : size // ignore: cast_nullable_to_non_nullable
                  as String,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
        discountPrice: freezed == discountPrice
            ? _value.discountPrice
            : discountPrice // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductSizeImpl extends _ProductSize {
  const _$ProductSizeImpl({
    @HiveField(0) @JsonKey(name: 'size') required this.size,
    @HiveField(1) @JsonKey(name: 'price') required this.price,
    @HiveField(2) @JsonKey(name: 'discount_price') this.discountPrice,
  }) : super._();

  factory _$ProductSizeImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductSizeImplFromJson(json);

  @override
  @HiveField(0)
  @JsonKey(name: 'size')
  final String size;
  @override
  @HiveField(1)
  @JsonKey(name: 'price')
  final double price;
  @override
  @HiveField(2)
  @JsonKey(name: 'discount_price')
  final double? discountPrice;

  @override
  String toString() {
    return 'ProductSize(size: $size, price: $price, discountPrice: $discountPrice)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductSizeImpl &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.discountPrice, discountPrice) ||
                other.discountPrice == discountPrice));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, size, price, discountPrice);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductSizeImplCopyWith<_$ProductSizeImpl> get copyWith =>
      __$$ProductSizeImplCopyWithImpl<_$ProductSizeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductSizeImplToJson(this);
  }
}

abstract class _ProductSize extends ProductSize {
  const factory _ProductSize({
    @HiveField(0) @JsonKey(name: 'size') required final String size,
    @HiveField(1) @JsonKey(name: 'price') required final double price,
    @HiveField(2) @JsonKey(name: 'discount_price') final double? discountPrice,
  }) = _$ProductSizeImpl;
  const _ProductSize._() : super._();

  factory _ProductSize.fromJson(Map<String, dynamic> json) =
      _$ProductSizeImpl.fromJson;

  @override
  @HiveField(0)
  @JsonKey(name: 'size')
  String get size;
  @override
  @HiveField(1)
  @JsonKey(name: 'price')
  double get price;
  @override
  @HiveField(2)
  @JsonKey(name: 'discount_price')
  double? get discountPrice;
  @override
  @JsonKey(ignore: true)
  _$$ProductSizeImplCopyWith<_$ProductSizeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
