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
  String? get categoryId => throw _privateConstructorUsedError;
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
  bool get isActive => throw _privateConstructorUsedError; // Basic Info
  @HiveField(14)
  String? get sku => throw _privateConstructorUsedError;
  @HiveField(15)
  List<String> get tags => throw _privateConstructorUsedError;
  @HiveField(16)
  double? get weight => throw _privateConstructorUsedError;
  @HiveField(17)
  String? get size => throw _privateConstructorUsedError; // Nutrition
  @HiveField(18)
  @JsonKey(name: 'nutrition_facts')
  Map<String, dynamic>? get nutritionFacts =>
      throw _privateConstructorUsedError; // Marketing
  @HiveField(19)
  bool get featured => throw _privateConstructorUsedError;
  @HiveField(20)
  @JsonKey(name: 'new_arrival')
  bool get newArrival => throw _privateConstructorUsedError;
  @HiveField(21)
  @JsonKey(name: 'best_seller')
  bool get bestSeller => throw _privateConstructorUsedError;
  @HiveField(22)
  @JsonKey(name: 'total_sales')
  int get totalSales => throw _privateConstructorUsedError;
  @HiveField(23)
  @JsonKey(name: 'views_count')
  int get viewsCount => throw _privateConstructorUsedError; // Shipping
  @HiveField(24)
  @JsonKey(name: 'shipping_weight')
  double? get shippingWeight => throw _privateConstructorUsedError;
  @HiveField(25)
  Map<String, dynamic>? get dimensions =>
      throw _privateConstructorUsedError; // Additional
  @HiveField(26)
  List<String> get ingredients => throw _privateConstructorUsedError;
  @HiveField(27)
  @JsonKey(name: 'usage_instructions')
  String? get usageInstructions => throw _privateConstructorUsedError;
  @HiveField(28)
  List<String> get warnings => throw _privateConstructorUsedError;
  @HiveField(29)
  @JsonKey(name: 'expiry_date')
  DateTime? get expiryDate => throw _privateConstructorUsedError;
  @HiveField(30)
  String? get manufacturer => throw _privateConstructorUsedError;
  @HiveField(31)
  @JsonKey(name: 'country_of_origin')
  String? get countryOfOrigin => throw _privateConstructorUsedError; // SEO
  @HiveField(32)
  @JsonKey(name: 'meta_title')
  String? get metaTitle => throw _privateConstructorUsedError;
  @HiveField(33)
  @JsonKey(name: 'meta_description')
  String? get metaDescription => throw _privateConstructorUsedError;
  @HiveField(34)
  String? get slug => throw _privateConstructorUsedError; // Timestamps
  @HiveField(35)
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @HiveField(36)
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  @HiveField(37)
  @JsonKey(name: 'flavor')
  List<String>? get flavors => throw _privateConstructorUsedError;

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
      @HiveField(6) @JsonKey(name: 'categoryId') String? categoryId,
      @HiveField(7) @JsonKey(name: 'stockQuantity') int stockQuantity,
      @HiveField(8) @JsonKey(name: 'averageRating') double averageRating,
      @HiveField(9) @JsonKey(name: 'reviewCount') int reviewCount,
      @HiveField(10) String? brand,
      @HiveField(11) @JsonKey(name: 'servingSize') String? servingSize,
      @HiveField(12)
      @JsonKey(name: 'servingsPerContainer')
      int? servingsPerContainer,
      @HiveField(13) @JsonKey(name: 'isActive') bool isActive,
      @HiveField(14) String? sku,
      @HiveField(15) List<String> tags,
      @HiveField(16) double? weight,
      @HiveField(17) String? size,
      @HiveField(18)
      @JsonKey(name: 'nutrition_facts')
      Map<String, dynamic>? nutritionFacts,
      @HiveField(19) bool featured,
      @HiveField(20) @JsonKey(name: 'new_arrival') bool newArrival,
      @HiveField(21) @JsonKey(name: 'best_seller') bool bestSeller,
      @HiveField(22) @JsonKey(name: 'total_sales') int totalSales,
      @HiveField(23) @JsonKey(name: 'views_count') int viewsCount,
      @HiveField(24) @JsonKey(name: 'shipping_weight') double? shippingWeight,
      @HiveField(25) Map<String, dynamic>? dimensions,
      @HiveField(26) List<String> ingredients,
      @HiveField(27)
      @JsonKey(name: 'usage_instructions')
      String? usageInstructions,
      @HiveField(28) List<String> warnings,
      @HiveField(29) @JsonKey(name: 'expiry_date') DateTime? expiryDate,
      @HiveField(30) String? manufacturer,
      @HiveField(31)
      @JsonKey(name: 'country_of_origin')
      String? countryOfOrigin,
      @HiveField(32) @JsonKey(name: 'meta_title') String? metaTitle,
      @HiveField(33) @JsonKey(name: 'meta_description') String? metaDescription,
      @HiveField(34) String? slug,
      @HiveField(35) DateTime? createdAt,
      @HiveField(36) DateTime? updatedAt,
      @HiveField(37) @JsonKey(name: 'flavor') List<String>? flavors});
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
    Object? categoryId = freezed,
    Object? stockQuantity = null,
    Object? averageRating = null,
    Object? reviewCount = null,
    Object? brand = freezed,
    Object? servingSize = freezed,
    Object? servingsPerContainer = freezed,
    Object? isActive = null,
    Object? sku = freezed,
    Object? tags = null,
    Object? weight = freezed,
    Object? size = freezed,
    Object? nutritionFacts = freezed,
    Object? featured = null,
    Object? newArrival = null,
    Object? bestSeller = null,
    Object? totalSales = null,
    Object? viewsCount = null,
    Object? shippingWeight = freezed,
    Object? dimensions = freezed,
    Object? ingredients = null,
    Object? usageInstructions = freezed,
    Object? warnings = null,
    Object? expiryDate = freezed,
    Object? manufacturer = freezed,
    Object? countryOfOrigin = freezed,
    Object? metaTitle = freezed,
    Object? metaDescription = freezed,
    Object? slug = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? flavors = freezed,
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
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
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
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      weight: freezed == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double?,
      size: freezed == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as String?,
      nutritionFacts: freezed == nutritionFacts
          ? _value.nutritionFacts
          : nutritionFacts // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      featured: null == featured
          ? _value.featured
          : featured // ignore: cast_nullable_to_non_nullable
              as bool,
      newArrival: null == newArrival
          ? _value.newArrival
          : newArrival // ignore: cast_nullable_to_non_nullable
              as bool,
      bestSeller: null == bestSeller
          ? _value.bestSeller
          : bestSeller // ignore: cast_nullable_to_non_nullable
              as bool,
      totalSales: null == totalSales
          ? _value.totalSales
          : totalSales // ignore: cast_nullable_to_non_nullable
              as int,
      viewsCount: null == viewsCount
          ? _value.viewsCount
          : viewsCount // ignore: cast_nullable_to_non_nullable
              as int,
      shippingWeight: freezed == shippingWeight
          ? _value.shippingWeight
          : shippingWeight // ignore: cast_nullable_to_non_nullable
              as double?,
      dimensions: freezed == dimensions
          ? _value.dimensions
          : dimensions // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      ingredients: null == ingredients
          ? _value.ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<String>,
      usageInstructions: freezed == usageInstructions
          ? _value.usageInstructions
          : usageInstructions // ignore: cast_nullable_to_non_nullable
              as String?,
      warnings: null == warnings
          ? _value.warnings
          : warnings // ignore: cast_nullable_to_non_nullable
              as List<String>,
      expiryDate: freezed == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      manufacturer: freezed == manufacturer
          ? _value.manufacturer
          : manufacturer // ignore: cast_nullable_to_non_nullable
              as String?,
      countryOfOrigin: freezed == countryOfOrigin
          ? _value.countryOfOrigin
          : countryOfOrigin // ignore: cast_nullable_to_non_nullable
              as String?,
      metaTitle: freezed == metaTitle
          ? _value.metaTitle
          : metaTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      metaDescription: freezed == metaDescription
          ? _value.metaDescription
          : metaDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      slug: freezed == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      flavors: freezed == flavors
          ? _value.flavors
          : flavors // ignore: cast_nullable_to_non_nullable
              as List<String>?,
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
      @HiveField(6) @JsonKey(name: 'categoryId') String? categoryId,
      @HiveField(7) @JsonKey(name: 'stockQuantity') int stockQuantity,
      @HiveField(8) @JsonKey(name: 'averageRating') double averageRating,
      @HiveField(9) @JsonKey(name: 'reviewCount') int reviewCount,
      @HiveField(10) String? brand,
      @HiveField(11) @JsonKey(name: 'servingSize') String? servingSize,
      @HiveField(12)
      @JsonKey(name: 'servingsPerContainer')
      int? servingsPerContainer,
      @HiveField(13) @JsonKey(name: 'isActive') bool isActive,
      @HiveField(14) String? sku,
      @HiveField(15) List<String> tags,
      @HiveField(16) double? weight,
      @HiveField(17) String? size,
      @HiveField(18)
      @JsonKey(name: 'nutrition_facts')
      Map<String, dynamic>? nutritionFacts,
      @HiveField(19) bool featured,
      @HiveField(20) @JsonKey(name: 'new_arrival') bool newArrival,
      @HiveField(21) @JsonKey(name: 'best_seller') bool bestSeller,
      @HiveField(22) @JsonKey(name: 'total_sales') int totalSales,
      @HiveField(23) @JsonKey(name: 'views_count') int viewsCount,
      @HiveField(24) @JsonKey(name: 'shipping_weight') double? shippingWeight,
      @HiveField(25) Map<String, dynamic>? dimensions,
      @HiveField(26) List<String> ingredients,
      @HiveField(27)
      @JsonKey(name: 'usage_instructions')
      String? usageInstructions,
      @HiveField(28) List<String> warnings,
      @HiveField(29) @JsonKey(name: 'expiry_date') DateTime? expiryDate,
      @HiveField(30) String? manufacturer,
      @HiveField(31)
      @JsonKey(name: 'country_of_origin')
      String? countryOfOrigin,
      @HiveField(32) @JsonKey(name: 'meta_title') String? metaTitle,
      @HiveField(33) @JsonKey(name: 'meta_description') String? metaDescription,
      @HiveField(34) String? slug,
      @HiveField(35) DateTime? createdAt,
      @HiveField(36) DateTime? updatedAt,
      @HiveField(37) @JsonKey(name: 'flavor') List<String>? flavors});
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
    Object? categoryId = freezed,
    Object? stockQuantity = null,
    Object? averageRating = null,
    Object? reviewCount = null,
    Object? brand = freezed,
    Object? servingSize = freezed,
    Object? servingsPerContainer = freezed,
    Object? isActive = null,
    Object? sku = freezed,
    Object? tags = null,
    Object? weight = freezed,
    Object? size = freezed,
    Object? nutritionFacts = freezed,
    Object? featured = null,
    Object? newArrival = null,
    Object? bestSeller = null,
    Object? totalSales = null,
    Object? viewsCount = null,
    Object? shippingWeight = freezed,
    Object? dimensions = freezed,
    Object? ingredients = null,
    Object? usageInstructions = freezed,
    Object? warnings = null,
    Object? expiryDate = freezed,
    Object? manufacturer = freezed,
    Object? countryOfOrigin = freezed,
    Object? metaTitle = freezed,
    Object? metaDescription = freezed,
    Object? slug = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? flavors = freezed,
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
      categoryId: freezed == categoryId
          ? _value.categoryId
          : categoryId // ignore: cast_nullable_to_non_nullable
              as String?,
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
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      weight: freezed == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double?,
      size: freezed == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as String?,
      nutritionFacts: freezed == nutritionFacts
          ? _value._nutritionFacts
          : nutritionFacts // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      featured: null == featured
          ? _value.featured
          : featured // ignore: cast_nullable_to_non_nullable
              as bool,
      newArrival: null == newArrival
          ? _value.newArrival
          : newArrival // ignore: cast_nullable_to_non_nullable
              as bool,
      bestSeller: null == bestSeller
          ? _value.bestSeller
          : bestSeller // ignore: cast_nullable_to_non_nullable
              as bool,
      totalSales: null == totalSales
          ? _value.totalSales
          : totalSales // ignore: cast_nullable_to_non_nullable
              as int,
      viewsCount: null == viewsCount
          ? _value.viewsCount
          : viewsCount // ignore: cast_nullable_to_non_nullable
              as int,
      shippingWeight: freezed == shippingWeight
          ? _value.shippingWeight
          : shippingWeight // ignore: cast_nullable_to_non_nullable
              as double?,
      dimensions: freezed == dimensions
          ? _value._dimensions
          : dimensions // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      ingredients: null == ingredients
          ? _value._ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<String>,
      usageInstructions: freezed == usageInstructions
          ? _value.usageInstructions
          : usageInstructions // ignore: cast_nullable_to_non_nullable
              as String?,
      warnings: null == warnings
          ? _value._warnings
          : warnings // ignore: cast_nullable_to_non_nullable
              as List<String>,
      expiryDate: freezed == expiryDate
          ? _value.expiryDate
          : expiryDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      manufacturer: freezed == manufacturer
          ? _value.manufacturer
          : manufacturer // ignore: cast_nullable_to_non_nullable
              as String?,
      countryOfOrigin: freezed == countryOfOrigin
          ? _value.countryOfOrigin
          : countryOfOrigin // ignore: cast_nullable_to_non_nullable
              as String?,
      metaTitle: freezed == metaTitle
          ? _value.metaTitle
          : metaTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      metaDescription: freezed == metaDescription
          ? _value.metaDescription
          : metaDescription // ignore: cast_nullable_to_non_nullable
              as String?,
      slug: freezed == slug
          ? _value.slug
          : slug // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      flavors: freezed == flavors
          ? _value._flavors
          : flavors // ignore: cast_nullable_to_non_nullable
              as List<String>?,
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
      @HiveField(5) this.description = '',
      @HiveField(6) @JsonKey(name: 'categoryId') this.categoryId,
      @HiveField(7) @JsonKey(name: 'stockQuantity') this.stockQuantity = 0,
      @HiveField(8) @JsonKey(name: 'averageRating') this.averageRating = 0.0,
      @HiveField(9) @JsonKey(name: 'reviewCount') this.reviewCount = 0,
      @HiveField(10) this.brand,
      @HiveField(11) @JsonKey(name: 'servingSize') this.servingSize,
      @HiveField(12)
      @JsonKey(name: 'servingsPerContainer')
      this.servingsPerContainer,
      @HiveField(13) @JsonKey(name: 'isActive') this.isActive = true,
      @HiveField(14) this.sku,
      @HiveField(15) final List<String> tags = const [],
      @HiveField(16) this.weight,
      @HiveField(17) this.size,
      @HiveField(18)
      @JsonKey(name: 'nutrition_facts')
      final Map<String, dynamic>? nutritionFacts,
      @HiveField(19) this.featured = false,
      @HiveField(20) @JsonKey(name: 'new_arrival') this.newArrival = false,
      @HiveField(21) @JsonKey(name: 'best_seller') this.bestSeller = false,
      @HiveField(22) @JsonKey(name: 'total_sales') this.totalSales = 0,
      @HiveField(23) @JsonKey(name: 'views_count') this.viewsCount = 0,
      @HiveField(24) @JsonKey(name: 'shipping_weight') this.shippingWeight,
      @HiveField(25) final Map<String, dynamic>? dimensions,
      @HiveField(26) final List<String> ingredients = const [],
      @HiveField(27)
      @JsonKey(name: 'usage_instructions')
      this.usageInstructions,
      @HiveField(28) final List<String> warnings = const [],
      @HiveField(29) @JsonKey(name: 'expiry_date') this.expiryDate,
      @HiveField(30) this.manufacturer,
      @HiveField(31) @JsonKey(name: 'country_of_origin') this.countryOfOrigin,
      @HiveField(32) @JsonKey(name: 'meta_title') this.metaTitle,
      @HiveField(33) @JsonKey(name: 'meta_description') this.metaDescription,
      @HiveField(34) this.slug,
      @HiveField(35) this.createdAt,
      @HiveField(36) this.updatedAt,
      @HiveField(37) @JsonKey(name: 'flavor') final List<String>? flavors})
      : _imageUrls = imageUrls,
        _tags = tags,
        _nutritionFacts = nutritionFacts,
        _dimensions = dimensions,
        _ingredients = ingredients,
        _warnings = warnings,
        _flavors = flavors,
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
  @JsonKey()
  @HiveField(5)
  final String description;
  @override
  @HiveField(6)
  @JsonKey(name: 'categoryId')
  final String? categoryId;
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
// Basic Info
  @override
  @HiveField(14)
  final String? sku;
  final List<String> _tags;
  @override
  @JsonKey()
  @HiveField(15)
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @HiveField(16)
  final double? weight;
  @override
  @HiveField(17)
  final String? size;
// Nutrition
  final Map<String, dynamic>? _nutritionFacts;
// Nutrition
  @override
  @HiveField(18)
  @JsonKey(name: 'nutrition_facts')
  Map<String, dynamic>? get nutritionFacts {
    final value = _nutritionFacts;
    if (value == null) return null;
    if (_nutritionFacts is EqualUnmodifiableMapView) return _nutritionFacts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

// Marketing
  @override
  @JsonKey()
  @HiveField(19)
  final bool featured;
  @override
  @HiveField(20)
  @JsonKey(name: 'new_arrival')
  final bool newArrival;
  @override
  @HiveField(21)
  @JsonKey(name: 'best_seller')
  final bool bestSeller;
  @override
  @HiveField(22)
  @JsonKey(name: 'total_sales')
  final int totalSales;
  @override
  @HiveField(23)
  @JsonKey(name: 'views_count')
  final int viewsCount;
// Shipping
  @override
  @HiveField(24)
  @JsonKey(name: 'shipping_weight')
  final double? shippingWeight;
  final Map<String, dynamic>? _dimensions;
  @override
  @HiveField(25)
  Map<String, dynamic>? get dimensions {
    final value = _dimensions;
    if (value == null) return null;
    if (_dimensions is EqualUnmodifiableMapView) return _dimensions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

// Additional
  final List<String> _ingredients;
// Additional
  @override
  @JsonKey()
  @HiveField(26)
  List<String> get ingredients {
    if (_ingredients is EqualUnmodifiableListView) return _ingredients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ingredients);
  }

  @override
  @HiveField(27)
  @JsonKey(name: 'usage_instructions')
  final String? usageInstructions;
  final List<String> _warnings;
  @override
  @JsonKey()
  @HiveField(28)
  List<String> get warnings {
    if (_warnings is EqualUnmodifiableListView) return _warnings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_warnings);
  }

  @override
  @HiveField(29)
  @JsonKey(name: 'expiry_date')
  final DateTime? expiryDate;
  @override
  @HiveField(30)
  final String? manufacturer;
  @override
  @HiveField(31)
  @JsonKey(name: 'country_of_origin')
  final String? countryOfOrigin;
// SEO
  @override
  @HiveField(32)
  @JsonKey(name: 'meta_title')
  final String? metaTitle;
  @override
  @HiveField(33)
  @JsonKey(name: 'meta_description')
  final String? metaDescription;
  @override
  @HiveField(34)
  final String? slug;
// Timestamps
  @override
  @HiveField(35)
  final DateTime? createdAt;
  @override
  @HiveField(36)
  final DateTime? updatedAt;
  final List<String>? _flavors;
  @override
  @HiveField(37)
  @JsonKey(name: 'flavor')
  List<String>? get flavors {
    final value = _flavors;
    if (value == null) return null;
    if (_flavors is EqualUnmodifiableListView) return _flavors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'ProductModel(id: $id, name: $name, price: $price, discountPrice: $discountPrice, imageUrls: $imageUrls, description: $description, categoryId: $categoryId, stockQuantity: $stockQuantity, averageRating: $averageRating, reviewCount: $reviewCount, brand: $brand, servingSize: $servingSize, servingsPerContainer: $servingsPerContainer, isActive: $isActive, sku: $sku, tags: $tags, weight: $weight, size: $size, nutritionFacts: $nutritionFacts, featured: $featured, newArrival: $newArrival, bestSeller: $bestSeller, totalSales: $totalSales, viewsCount: $viewsCount, shippingWeight: $shippingWeight, dimensions: $dimensions, ingredients: $ingredients, usageInstructions: $usageInstructions, warnings: $warnings, expiryDate: $expiryDate, manufacturer: $manufacturer, countryOfOrigin: $countryOfOrigin, metaTitle: $metaTitle, metaDescription: $metaDescription, slug: $slug, createdAt: $createdAt, updatedAt: $updatedAt, flavors: $flavors)';
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
            (identical(other.sku, sku) || other.sku == sku) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.size, size) || other.size == size) &&
            const DeepCollectionEquality()
                .equals(other._nutritionFacts, _nutritionFacts) &&
            (identical(other.featured, featured) ||
                other.featured == featured) &&
            (identical(other.newArrival, newArrival) ||
                other.newArrival == newArrival) &&
            (identical(other.bestSeller, bestSeller) ||
                other.bestSeller == bestSeller) &&
            (identical(other.totalSales, totalSales) ||
                other.totalSales == totalSales) &&
            (identical(other.viewsCount, viewsCount) ||
                other.viewsCount == viewsCount) &&
            (identical(other.shippingWeight, shippingWeight) ||
                other.shippingWeight == shippingWeight) &&
            const DeepCollectionEquality()
                .equals(other._dimensions, _dimensions) &&
            const DeepCollectionEquality()
                .equals(other._ingredients, _ingredients) &&
            (identical(other.usageInstructions, usageInstructions) ||
                other.usageInstructions == usageInstructions) &&
            const DeepCollectionEquality().equals(other._warnings, _warnings) &&
            (identical(other.expiryDate, expiryDate) ||
                other.expiryDate == expiryDate) &&
            (identical(other.manufacturer, manufacturer) ||
                other.manufacturer == manufacturer) &&
            (identical(other.countryOfOrigin, countryOfOrigin) ||
                other.countryOfOrigin == countryOfOrigin) &&
            (identical(other.metaTitle, metaTitle) ||
                other.metaTitle == metaTitle) &&
            (identical(other.metaDescription, metaDescription) ||
                other.metaDescription == metaDescription) &&
            (identical(other.slug, slug) || other.slug == slug) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._flavors, _flavors));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
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
        sku,
        const DeepCollectionEquality().hash(_tags),
        weight,
        size,
        const DeepCollectionEquality().hash(_nutritionFacts),
        featured,
        newArrival,
        bestSeller,
        totalSales,
        viewsCount,
        shippingWeight,
        const DeepCollectionEquality().hash(_dimensions),
        const DeepCollectionEquality().hash(_ingredients),
        usageInstructions,
        const DeepCollectionEquality().hash(_warnings),
        expiryDate,
        manufacturer,
        countryOfOrigin,
        metaTitle,
        metaDescription,
        slug,
        createdAt,
        updatedAt,
        const DeepCollectionEquality().hash(_flavors)
      ]);

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
      @HiveField(5) final String description,
      @HiveField(6) @JsonKey(name: 'categoryId') final String? categoryId,
      @HiveField(7) @JsonKey(name: 'stockQuantity') final int stockQuantity,
      @HiveField(8) @JsonKey(name: 'averageRating') final double averageRating,
      @HiveField(9) @JsonKey(name: 'reviewCount') final int reviewCount,
      @HiveField(10) final String? brand,
      @HiveField(11) @JsonKey(name: 'servingSize') final String? servingSize,
      @HiveField(12)
      @JsonKey(name: 'servingsPerContainer')
      final int? servingsPerContainer,
      @HiveField(13) @JsonKey(name: 'isActive') final bool isActive,
      @HiveField(14) final String? sku,
      @HiveField(15) final List<String> tags,
      @HiveField(16) final double? weight,
      @HiveField(17) final String? size,
      @HiveField(18)
      @JsonKey(name: 'nutrition_facts')
      final Map<String, dynamic>? nutritionFacts,
      @HiveField(19) final bool featured,
      @HiveField(20) @JsonKey(name: 'new_arrival') final bool newArrival,
      @HiveField(21) @JsonKey(name: 'best_seller') final bool bestSeller,
      @HiveField(22) @JsonKey(name: 'total_sales') final int totalSales,
      @HiveField(23) @JsonKey(name: 'views_count') final int viewsCount,
      @HiveField(24)
      @JsonKey(name: 'shipping_weight')
      final double? shippingWeight,
      @HiveField(25) final Map<String, dynamic>? dimensions,
      @HiveField(26) final List<String> ingredients,
      @HiveField(27)
      @JsonKey(name: 'usage_instructions')
      final String? usageInstructions,
      @HiveField(28) final List<String> warnings,
      @HiveField(29) @JsonKey(name: 'expiry_date') final DateTime? expiryDate,
      @HiveField(30) final String? manufacturer,
      @HiveField(31)
      @JsonKey(name: 'country_of_origin')
      final String? countryOfOrigin,
      @HiveField(32) @JsonKey(name: 'meta_title') final String? metaTitle,
      @HiveField(33)
      @JsonKey(name: 'meta_description')
      final String? metaDescription,
      @HiveField(34) final String? slug,
      @HiveField(35) final DateTime? createdAt,
      @HiveField(36) final DateTime? updatedAt,
      @HiveField(37)
      @JsonKey(name: 'flavor')
      final List<String>? flavors}) = _$ProductModelImpl;
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
  String? get categoryId;
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
  @override // Basic Info
  @HiveField(14)
  String? get sku;
  @override
  @HiveField(15)
  List<String> get tags;
  @override
  @HiveField(16)
  double? get weight;
  @override
  @HiveField(17)
  String? get size;
  @override // Nutrition
  @HiveField(18)
  @JsonKey(name: 'nutrition_facts')
  Map<String, dynamic>? get nutritionFacts;
  @override // Marketing
  @HiveField(19)
  bool get featured;
  @override
  @HiveField(20)
  @JsonKey(name: 'new_arrival')
  bool get newArrival;
  @override
  @HiveField(21)
  @JsonKey(name: 'best_seller')
  bool get bestSeller;
  @override
  @HiveField(22)
  @JsonKey(name: 'total_sales')
  int get totalSales;
  @override
  @HiveField(23)
  @JsonKey(name: 'views_count')
  int get viewsCount;
  @override // Shipping
  @HiveField(24)
  @JsonKey(name: 'shipping_weight')
  double? get shippingWeight;
  @override
  @HiveField(25)
  Map<String, dynamic>? get dimensions;
  @override // Additional
  @HiveField(26)
  List<String> get ingredients;
  @override
  @HiveField(27)
  @JsonKey(name: 'usage_instructions')
  String? get usageInstructions;
  @override
  @HiveField(28)
  List<String> get warnings;
  @override
  @HiveField(29)
  @JsonKey(name: 'expiry_date')
  DateTime? get expiryDate;
  @override
  @HiveField(30)
  String? get manufacturer;
  @override
  @HiveField(31)
  @JsonKey(name: 'country_of_origin')
  String? get countryOfOrigin;
  @override // SEO
  @HiveField(32)
  @JsonKey(name: 'meta_title')
  String? get metaTitle;
  @override
  @HiveField(33)
  @JsonKey(name: 'meta_description')
  String? get metaDescription;
  @override
  @HiveField(34)
  String? get slug;
  @override // Timestamps
  @HiveField(35)
  DateTime? get createdAt;
  @override
  @HiveField(36)
  DateTime? get updatedAt;
  @override
  @HiveField(37)
  @JsonKey(name: 'flavor')
  List<String>? get flavors;
  @override
  @JsonKey(ignore: true)
  _$$ProductModelImplCopyWith<_$ProductModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
