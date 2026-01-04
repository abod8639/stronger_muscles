// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) {
  return _ProductModel.fromJson(json);
}

/// @nodoc
mixin _$ProductModel {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  String get name => throw _privateConstructorUsedError;
  @HiveField(2)
  double get price => throw _privateConstructorUsedError;
  @HiveField(3)
  @JsonKey(name: 'discountPrice')
  double? get discountPrice => throw _privateConstructorUsedError;
  @HiveField(4)
  @JsonKey(name: 'imageUrls')
  List<String> get imageUrls => throw _privateConstructorUsedError;
  @HiveField(5)
  String get description => throw _privateConstructorUsedError;
  @HiveField(6)
  @JsonKey(name: 'categoryId')
  String get categoryId => throw _privateConstructorUsedError;
  @HiveField(7)
  @JsonKey(name: 'stockQuantity')
  int get stockQuantity => throw _privateConstructorUsedError;
  @HiveField(8)
  @JsonKey(name: 'averageRating')
  double get averageRating => throw _privateConstructorUsedError;
  @HiveField(9)
  @JsonKey(name: 'reviewCount')
  int get reviewCount => throw _privateConstructorUsedError;
  @HiveField(10)
  String? get brand => throw _privateConstructorUsedError;
  @HiveField(11)
  @JsonKey(name: 'servingSize')
  String? get servingSize => throw _privateConstructorUsedError;
  @HiveField(12)
  @JsonKey(name: 'servingsPerContainer')
  int? get servingsPerContainer => throw _privateConstructorUsedError;
  @HiveField(13)
  @JsonKey(name: 'isActive')
  bool get isActive => throw _privateConstructorUsedError;
  @HiveField(14)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @HiveField(15)
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ProductModelCopyWith<ProductModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductModelCopyWith<$Res> {
  factory $ProductModelCopyWith(
          ProductModel value, $Res Function(ProductModel) then) =
      _$ProductModelCopyWithImpl<$Res, ProductModel>;
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String name,
      @HiveField(2) double price,
      @HiveField(3) @JsonKey(name: 'discountPrice') double? discountPrice,
      @HiveField(4) @JsonKey(name: 'imageUrls') List<String> imageUrls,
      @HiveField(5) String description,
      @HiveField(6) @JsonKey(name: 'categoryId') String categoryId,
      @HiveField(7) @JsonKey(name: 'stockQuantity') int stockQuantity,
      @HiveField(8) @JsonKey(name: 'averageRating') double averageRating,
      @HiveField(9) @JsonKey(name: 'reviewCount') int reviewCount,
      @HiveField(10) String? brand,
      @HiveField(11) @JsonKey(name: 'servingSize') String? servingSize,
      @HiveField(12)
      @JsonKey(name: 'servingsPerContainer')
      int? servingsPerContainer,
      @HiveField(13) @JsonKey(name: 'isActive') bool isActive,
      @HiveField(14) DateTime? createdAt,
      @HiveField(15) DateTime? updatedAt});
}

/// @nodoc
class _$ProductModelCopyWithImpl<$Res, $Val extends ProductModel>
    implements $ProductModelCopyWith<$Res> {
  _$ProductModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? price = null,
    Object? discountPrice = freezed,
    Object? imageUrls = null,
    Object? description = null,
    Object? categoryId = null,
    Object? stockQuantity = null,
    Object? averageRating = null,
    Object? reviewCount = null,
    Object? brand = freezed,
    Object? servingSize = freezed,
    Object? servingsPerContainer = freezed,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      discountPrice: freezed == discountPrice
          ? _value.discountPrice
          : discountPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      imageUrls: null == imageUrls
          ? _value.imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      stockQuantity: null == stockQuantity
          ? _value.stockQuantity
          : stockQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      averageRating: null == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double,
      reviewCount: null == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      servingSize: freezed == servingSize
          ? _value.servingSize
          : servingSize // ignore: cast_nullable_to_non_nullable
              as String?,
      servingsPerContainer: freezed == servingsPerContainer
          ? _value.servingsPerContainer
          : servingsPerContainer // ignore: cast_nullable_to_non_nullable
              as int?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
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
abstract class _$$ProductModelImplCopyWith<$Res>
    implements $ProductModelCopyWith<$Res> {
  factory _$$ProductModelImplCopyWith(
          _$ProductModelImpl value, $Res Function(_$ProductModelImpl) then) =
      __$$ProductModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String id,
      @HiveField(1) String name,
      @HiveField(2) double price,
      @HiveField(3) @JsonKey(name: 'discountPrice') double? discountPrice,
      @HiveField(4) @JsonKey(name: 'imageUrls') List<String> imageUrls,
      @HiveField(5) String description,
      @HiveField(6) @JsonKey(name: 'categoryId') String categoryId,
      @HiveField(7) @JsonKey(name: 'stockQuantity') int stockQuantity,
      @HiveField(8) @JsonKey(name: 'averageRating') double averageRating,
      @HiveField(9) @JsonKey(name: 'reviewCount') int reviewCount,
      @HiveField(10) String? brand,
      @HiveField(11) @JsonKey(name: 'servingSize') String? servingSize,
      @HiveField(12)
      @JsonKey(name: 'servingsPerContainer')
      int? servingsPerContainer,
      @HiveField(13) @JsonKey(name: 'isActive') bool isActive,
      @HiveField(14) DateTime? createdAt,
      @HiveField(15) DateTime? updatedAt});
}

/// @nodoc
class __$$ProductModelImplCopyWithImpl<$Res>
    extends _$ProductModelCopyWithImpl<$Res, _$ProductModelImpl>
    implements _$$ProductModelImplCopyWith<$Res> {
  __$$ProductModelImplCopyWithImpl(
      _$ProductModelImpl _value, $Res Function(_$ProductModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? price = null,
    Object? discountPrice = freezed,
    Object? imageUrls = null,
    Object? description = null,
    Object? categoryId = null,
    Object? stockQuantity = null,
    Object? averageRating = null,
    Object? reviewCount = null,
    Object? brand = freezed,
    Object? servingSize = freezed,
    Object? servingsPerContainer = freezed,
    Object? isActive = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_$ProductModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      discountPrice: freezed == discountPrice
          ? _value.discountPrice
          : discountPrice // ignore: cast_nullable_to_non_nullable
              as double?,
      imageUrls: null == imageUrls
          ? _value._imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<String>,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      categoryId: null == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String,
      stockQuantity: null == stockQuantity
          ? _value.stockQuantity
          : stockQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      averageRating: null == averageRating
          ? _value.averageRating
          : averageRating // ignore: cast_nullable_to_non_nullable
              as double,
      reviewCount: null == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      servingSize: freezed == servingSize
          ? _value.servingSize
          : servingSize // ignore: cast_nullable_to_non_nullable
              as String?,
      servingsPerContainer: freezed == servingsPerContainer
          ? _value.servingsPerContainer
          : servingsPerContainer // ignore: cast_nullable_to_non_nullable
              as int?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
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
class _$ProductModelImpl extends _ProductModel {
  const _$ProductModelImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) required this.name,
      @HiveField(2) required this.price,
      @HiveField(3) @JsonKey(name: 'discountPrice') this.discountPrice,
      @HiveField(4)
      @JsonKey(name: 'imageUrls')
      final List<String> imageUrls = const [],
      @HiveField(5) required this.description,
      @HiveField(6) @JsonKey(name: 'categoryId') required this.categoryId,
      @HiveField(7) @JsonKey(name: 'stockQuantity') this.stockQuantity = 0,
      @HiveField(8) @JsonKey(name: 'averageRating') this.averageRating = 0.0,
      @HiveField(9) @JsonKey(name: 'reviewCount') this.reviewCount = 0,
      @HiveField(10) this.brand,
      @HiveField(11) @JsonKey(name: 'servingSize') this.servingSize,
      @HiveField(12)
      @JsonKey(name: 'servingsPerContainer')
      this.servingsPerContainer,
      @HiveField(13) @JsonKey(name: 'isActive') this.isActive = true,
      @HiveField(14) this.createdAt,
      @HiveField(15) this.updatedAt})
      : _imageUrls = imageUrls,
        super._();

  factory _$ProductModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductModelImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String name;
  @override
  @HiveField(2)
  final double price;
  @override
  @HiveField(3)
  @JsonKey(name: 'discountPrice')
  final double? discountPrice;
  final List<String> _imageUrls;
  @override
  @HiveField(4)
  @JsonKey(name: 'imageUrls')
  List<String> get imageUrls {
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imageUrls);
  }

  @override
  @HiveField(5)
  final String description;
  @override
  @HiveField(6)
  @JsonKey(name: 'categoryId')
  final String categoryId;
  @override
  @HiveField(7)
  @JsonKey(name: 'stockQuantity')
  final int stockQuantity;
  @override
  @HiveField(8)
  @JsonKey(name: 'averageRating')
  final double averageRating;
  @override
  @HiveField(9)
  @JsonKey(name: 'reviewCount')
  final int reviewCount;
  @override
  @HiveField(10)
  final String? brand;
  @override
  @HiveField(11)
  @JsonKey(name: 'servingSize')
  final String? servingSize;
  @override
  @HiveField(12)
  @JsonKey(name: 'servingsPerContainer')
  final int? servingsPerContainer;
  @override
  @HiveField(13)
  @JsonKey(name: 'isActive')
  final bool isActive;
  @override
  @HiveField(14)
  final DateTime? createdAt;
  @override
  @HiveField(15)
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'ProductModel(id: $id, name: $name, price: $price, discountPrice: $discountPrice, imageUrls: $imageUrls, description: $description, categoryId: $categoryId, stockQuantity: $stockQuantity, averageRating: $averageRating, reviewCount: $reviewCount, brand: $brand, servingSize: $servingSize, servingsPerContainer: $servingsPerContainer, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.discountPrice, discountPrice) ||
                other.discountPrice == discountPrice) &&
            const DeepCollectionEquality()
                .equals(other._imageUrls, _imageUrls) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.stockQuantity, stockQuantity) ||
                other.stockQuantity == stockQuantity) &&
            (identical(other.averageRating, averageRating) ||
                other.averageRating == averageRating) &&
            (identical(other.reviewCount, reviewCount) ||
                other.reviewCount == reviewCount) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.servingSize, servingSize) ||
                other.servingSize == servingSize) &&
            (identical(other.servingsPerContainer, servingsPerContainer) ||
                other.servingsPerContainer == servingsPerContainer) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
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
      name,
      price,
      discountPrice,
      const DeepCollectionEquality().hash(_imageUrls),
      description,
      categoryId,
      stockQuantity,
      averageRating,
      reviewCount,
      brand,
      servingSize,
      servingsPerContainer,
      isActive,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductModelImplCopyWith<_$ProductModelImpl> get copyWith =>
      __$$ProductModelImplCopyWithImpl<_$ProductModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductModelImplToJson(
      this,
    );
  }
}

abstract class _ProductModel extends ProductModel {
  const factory _ProductModel(
      {@HiveField(0) required final String id,
      @HiveField(1) required final String name,
      @HiveField(2) required final double price,
      @HiveField(3) @JsonKey(name: 'discountPrice') final double? discountPrice,
      @HiveField(4) @JsonKey(name: 'imageUrls') final List<String> imageUrls,
      @HiveField(5) required final String description,
      @HiveField(6)
      @JsonKey(name: 'categoryId')
      required final String categoryId,
      @HiveField(7) @JsonKey(name: 'stockQuantity') final int stockQuantity,
      @HiveField(8) @JsonKey(name: 'averageRating') final double averageRating,
      @HiveField(9) @JsonKey(name: 'reviewCount') final int reviewCount,
      @HiveField(10) final String? brand,
      @HiveField(11) @JsonKey(name: 'servingSize') final String? servingSize,
      @HiveField(12)
      @JsonKey(name: 'servingsPerContainer')
      final int? servingsPerContainer,
      @HiveField(13) @JsonKey(name: 'isActive') final bool isActive,
      @HiveField(14) final DateTime? createdAt,
      @HiveField(15) final DateTime? updatedAt}) = _$ProductModelImpl;
  const _ProductModel._() : super._();

  factory _ProductModel.fromJson(Map<String, dynamic> json) =
      _$ProductModelImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  String get name;
  @override
  @HiveField(2)
  double get price;
  @override
  @HiveField(3)
  @JsonKey(name: 'discountPrice')
  double? get discountPrice;
  @override
  @HiveField(4)
  @JsonKey(name: 'imageUrls')
  List<String> get imageUrls;
  @override
  @HiveField(5)
  String get description;
  @override
  @HiveField(6)
  @JsonKey(name: 'categoryId')
  String get categoryId;
  @override
  @HiveField(7)
  @JsonKey(name: 'stockQuantity')
  int get stockQuantity;
  @override
  @HiveField(8)
  @JsonKey(name: 'averageRating')
  double get averageRating;
  @override
  @HiveField(9)
  @JsonKey(name: 'reviewCount')
  int get reviewCount;
  @override
  @HiveField(10)
  String? get brand;
  @override
  @HiveField(11)
  @JsonKey(name: 'servingSize')
  String? get servingSize;
  @override
  @HiveField(12)
  @JsonKey(name: 'servingsPerContainer')
  int? get servingsPerContainer;
  @override
  @HiveField(13)
  @JsonKey(name: 'isActive')
  bool get isActive;
  @override
  @HiveField(14)
  DateTime? get createdAt;
  @override
  @HiveField(15)
  DateTime? get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$ProductModelImplCopyWith<_$ProductModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
