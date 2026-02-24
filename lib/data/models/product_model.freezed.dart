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
  LocalizedString? get name => throw _privateConstructorUsedError;
  @HiveField(2)
  LocalizedString? get description => throw _privateConstructorUsedError;
  @HiveField(3)
  String? get brand => throw _privateConstructorUsedError;
  @HiveField(4)
  ProductCategory? get category => throw _privateConstructorUsedError;
  @HiveField(5)
  @JsonKey(name: 'imageUrls')
  List<ImageUrl> get imageUrls => throw _privateConstructorUsedError;
  @HiveField(6)
  @JsonKey(name: 'has_variants')
  bool get hasVariants => throw _privateConstructorUsedError;
  @HiveField(7)
  double get price => throw _privateConstructorUsedError;
  @HiveField(8)
  @JsonKey(name: 'discount_price')
  double? get discountPrice => throw _privateConstructorUsedError;
  @HiveField(9)
  @JsonKey(name: 'stock_quantity')
  int get stockQuantity => throw _privateConstructorUsedError;
  @HiveField(10)
  @JsonKey(name: 'average_rating')
  double get averageRating => throw _privateConstructorUsedError;
  @HiveField(11)
  @JsonKey(name: 'review_count')
  int get reviewCount => throw _privateConstructorUsedError;
  @HiveField(12)
  @JsonKey(name: 'serving_size')
  String? get servingSize => throw _privateConstructorUsedError;
  @HiveField(13)
  @JsonKey(name: 'servings_per_container')
  int get servingsPerContainer => throw _privateConstructorUsedError;
  @HiveField(14)
  @JsonKey(name: 'nutrition_facts')
  Map<String, dynamic>? get nutritionFacts =>
      throw _privateConstructorUsedError;
  @HiveField(15)
  @JsonKey(name: 'flavors')
  List<String> get flavors => throw _privateConstructorUsedError;
  @HiveField(16)
  @JsonKey(name: 'product_sizes')
  List<ProductSize> get productSizes => throw _privateConstructorUsedError;
  @HiveField(17)
  @JsonKey(name: 'size')
  List<String> get size => throw _privateConstructorUsedError;
  @HiveField(18)
  List<String> get tags => throw _privateConstructorUsedError;
  @HiveField(19)
  double? get weight => throw _privateConstructorUsedError;
  @HiveField(20)
  @JsonKey(name: 'is_active')
  bool get isActive => throw _privateConstructorUsedError;
  @HiveField(21)
  @JsonKey(name: 'is_background_white')
  bool get isBackgroundWhite => throw _privateConstructorUsedError;
  @HiveField(22)
  bool get featured => throw _privateConstructorUsedError;
  @HiveField(23)
  @JsonKey(name: 'new_arrival')
  bool get newArrival => throw _privateConstructorUsedError;
  @HiveField(24)
  @JsonKey(name: 'best_seller')
  bool get bestSeller => throw _privateConstructorUsedError;
  @HiveField(25)
  String? get sku => throw _privateConstructorUsedError;
  @HiveField(26)
  @JsonKey(name: 'total_sales')
  int get totalSales => throw _privateConstructorUsedError;
  @HiveField(27)
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @HiveField(28)
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt =>
      throw _privateConstructorUsedError; // Additional fields for product details
  @HiveField(29)
  List<String> get ingredients => throw _privateConstructorUsedError;
  @HiveField(30)
  String? get manufacturer => throw _privateConstructorUsedError;
  @HiveField(31)
  @JsonKey(name: 'country_of_origin')
  String? get countryOfOrigin => throw _privateConstructorUsedError;
  @HiveField(32)
  @JsonKey(name: 'usage_instructions')
  String? get usageInstructions => throw _privateConstructorUsedError;
  @HiveField(33)
  List<String> get warnings => throw _privateConstructorUsedError;

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
      @HiveField(1) LocalizedString? name,
      @HiveField(2) LocalizedString? description,
      @HiveField(3) String? brand,
      @HiveField(4) ProductCategory? category,
      @HiveField(5) @JsonKey(name: 'imageUrls') List<ImageUrl> imageUrls,
      @HiveField(6) @JsonKey(name: 'has_variants') bool hasVariants,
      @HiveField(7) double price,
      @HiveField(8) @JsonKey(name: 'discount_price') double? discountPrice,
      @HiveField(9) @JsonKey(name: 'stock_quantity') int stockQuantity,
      @HiveField(10) @JsonKey(name: 'average_rating') double averageRating,
      @HiveField(11) @JsonKey(name: 'review_count') int reviewCount,
      @HiveField(12) @JsonKey(name: 'serving_size') String? servingSize,
      @HiveField(13)
      @JsonKey(name: 'servings_per_container')
      int servingsPerContainer,
      @HiveField(14)
      @JsonKey(name: 'nutrition_facts')
      Map<String, dynamic>? nutritionFacts,
      @HiveField(15) @JsonKey(name: 'flavors') List<String> flavors,
      @HiveField(16)
      @JsonKey(name: 'product_sizes')
      List<ProductSize> productSizes,
      @HiveField(17) @JsonKey(name: 'size') List<String> size,
      @HiveField(18) List<String> tags,
      @HiveField(19) double? weight,
      @HiveField(20) @JsonKey(name: 'is_active') bool isActive,
      @HiveField(21)
      @JsonKey(name: 'is_background_white')
      bool isBackgroundWhite,
      @HiveField(22) bool featured,
      @HiveField(23) @JsonKey(name: 'new_arrival') bool newArrival,
      @HiveField(24) @JsonKey(name: 'best_seller') bool bestSeller,
      @HiveField(25) String? sku,
      @HiveField(26) @JsonKey(name: 'total_sales') int totalSales,
      @HiveField(27) @JsonKey(name: 'created_at') DateTime? createdAt,
      @HiveField(28) @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @HiveField(29) List<String> ingredients,
      @HiveField(30) String? manufacturer,
      @HiveField(31)
      @JsonKey(name: 'country_of_origin')
      String? countryOfOrigin,
      @HiveField(32)
      @JsonKey(name: 'usage_instructions')
      String? usageInstructions,
      @HiveField(33) List<String> warnings});

  $LocalizedStringCopyWith<$Res>? get name;
  $LocalizedStringCopyWith<$Res>? get description;
  $ProductCategoryCopyWith<$Res>? get category;
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
    Object? name = freezed,
    Object? description = freezed,
    Object? brand = freezed,
    Object? category = freezed,
    Object? imageUrls = null,
    Object? hasVariants = null,
    Object? price = null,
    Object? discountPrice = freezed,
    Object? stockQuantity = null,
    Object? averageRating = null,
    Object? reviewCount = null,
    Object? servingSize = freezed,
    Object? servingsPerContainer = null,
    Object? nutritionFacts = freezed,
    Object? flavors = null,
    Object? productSizes = null,
    Object? size = null,
    Object? tags = null,
    Object? weight = freezed,
    Object? isActive = null,
    Object? isBackgroundWhite = null,
    Object? featured = null,
    Object? newArrival = null,
    Object? bestSeller = null,
    Object? sku = freezed,
    Object? totalSales = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? ingredients = null,
    Object? manufacturer = freezed,
    Object? countryOfOrigin = freezed,
    Object? usageInstructions = freezed,
    Object? warnings = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as LocalizedString?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as LocalizedString?,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as ProductCategory?,
      imageUrls: null == imageUrls
          ? _value.imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<ImageUrl>,
      hasVariants: null == hasVariants
          ? _value.hasVariants
          : hasVariants // ignore: cast_nullable_to_non_nullable
              as bool,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      discountPrice: freezed == discountPrice
          ? _value.discountPrice
          : discountPrice // ignore: cast_nullable_to_non_nullable
              as double?,
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
      servingSize: freezed == servingSize
          ? _value.servingSize
          : servingSize // ignore: cast_nullable_to_non_nullable
              as String?,
      servingsPerContainer: null == servingsPerContainer
          ? _value.servingsPerContainer
          : servingsPerContainer // ignore: cast_nullable_to_non_nullable
              as int,
      nutritionFacts: freezed == nutritionFacts
          ? _value.nutritionFacts
          : nutritionFacts // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      flavors: null == flavors
          ? _value.flavors
          : flavors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      productSizes: null == productSizes
          ? _value.productSizes
          : productSizes // ignore: cast_nullable_to_non_nullable
              as List<ProductSize>,
      size: null == size
          ? _value.size
          : size // ignore: cast_nullable_to_non_nullable
              as List<String>,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      weight: freezed == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isBackgroundWhite: null == isBackgroundWhite
          ? _value.isBackgroundWhite
          : isBackgroundWhite // ignore: cast_nullable_to_non_nullable
              as bool,
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
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      totalSales: null == totalSales
          ? _value.totalSales
          : totalSales // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      ingredients: null == ingredients
          ? _value.ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<String>,
      manufacturer: freezed == manufacturer
          ? _value.manufacturer
          : manufacturer // ignore: cast_nullable_to_non_nullable
              as String?,
      countryOfOrigin: freezed == countryOfOrigin
          ? _value.countryOfOrigin
          : countryOfOrigin // ignore: cast_nullable_to_non_nullable
              as String?,
      usageInstructions: freezed == usageInstructions
          ? _value.usageInstructions
          : usageInstructions // ignore: cast_nullable_to_non_nullable
              as String?,
      warnings: null == warnings
          ? _value.warnings
          : warnings // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $LocalizedStringCopyWith<$Res>? get name {
    if (_value.name == null) {
      return null;
    }

    return $LocalizedStringCopyWith<$Res>(_value.name!, (value) {
      return _then(_value.copyWith(name: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $LocalizedStringCopyWith<$Res>? get description {
    if (_value.description == null) {
      return null;
    }

    return $LocalizedStringCopyWith<$Res>(_value.description!, (value) {
      return _then(_value.copyWith(description: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ProductCategoryCopyWith<$Res>? get category {
    if (_value.category == null) {
      return null;
    }

    return $ProductCategoryCopyWith<$Res>(_value.category!, (value) {
      return _then(_value.copyWith(category: value) as $Val);
    });
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
      @HiveField(1) LocalizedString? name,
      @HiveField(2) LocalizedString? description,
      @HiveField(3) String? brand,
      @HiveField(4) ProductCategory? category,
      @HiveField(5) @JsonKey(name: 'imageUrls') List<ImageUrl> imageUrls,
      @HiveField(6) @JsonKey(name: 'has_variants') bool hasVariants,
      @HiveField(7) double price,
      @HiveField(8) @JsonKey(name: 'discount_price') double? discountPrice,
      @HiveField(9) @JsonKey(name: 'stock_quantity') int stockQuantity,
      @HiveField(10) @JsonKey(name: 'average_rating') double averageRating,
      @HiveField(11) @JsonKey(name: 'review_count') int reviewCount,
      @HiveField(12) @JsonKey(name: 'serving_size') String? servingSize,
      @HiveField(13)
      @JsonKey(name: 'servings_per_container')
      int servingsPerContainer,
      @HiveField(14)
      @JsonKey(name: 'nutrition_facts')
      Map<String, dynamic>? nutritionFacts,
      @HiveField(15) @JsonKey(name: 'flavors') List<String> flavors,
      @HiveField(16)
      @JsonKey(name: 'product_sizes')
      List<ProductSize> productSizes,
      @HiveField(17) @JsonKey(name: 'size') List<String> size,
      @HiveField(18) List<String> tags,
      @HiveField(19) double? weight,
      @HiveField(20) @JsonKey(name: 'is_active') bool isActive,
      @HiveField(21)
      @JsonKey(name: 'is_background_white')
      bool isBackgroundWhite,
      @HiveField(22) bool featured,
      @HiveField(23) @JsonKey(name: 'new_arrival') bool newArrival,
      @HiveField(24) @JsonKey(name: 'best_seller') bool bestSeller,
      @HiveField(25) String? sku,
      @HiveField(26) @JsonKey(name: 'total_sales') int totalSales,
      @HiveField(27) @JsonKey(name: 'created_at') DateTime? createdAt,
      @HiveField(28) @JsonKey(name: 'updated_at') DateTime? updatedAt,
      @HiveField(29) List<String> ingredients,
      @HiveField(30) String? manufacturer,
      @HiveField(31)
      @JsonKey(name: 'country_of_origin')
      String? countryOfOrigin,
      @HiveField(32)
      @JsonKey(name: 'usage_instructions')
      String? usageInstructions,
      @HiveField(33) List<String> warnings});

  @override
  $LocalizedStringCopyWith<$Res>? get name;
  @override
  $LocalizedStringCopyWith<$Res>? get description;
  @override
  $ProductCategoryCopyWith<$Res>? get category;
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
    Object? name = freezed,
    Object? description = freezed,
    Object? brand = freezed,
    Object? category = freezed,
    Object? imageUrls = null,
    Object? hasVariants = null,
    Object? price = null,
    Object? discountPrice = freezed,
    Object? stockQuantity = null,
    Object? averageRating = null,
    Object? reviewCount = null,
    Object? servingSize = freezed,
    Object? servingsPerContainer = null,
    Object? nutritionFacts = freezed,
    Object? flavors = null,
    Object? productSizes = null,
    Object? size = null,
    Object? tags = null,
    Object? weight = freezed,
    Object? isActive = null,
    Object? isBackgroundWhite = null,
    Object? featured = null,
    Object? newArrival = null,
    Object? bestSeller = null,
    Object? sku = freezed,
    Object? totalSales = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? ingredients = null,
    Object? manufacturer = freezed,
    Object? countryOfOrigin = freezed,
    Object? usageInstructions = freezed,
    Object? warnings = null,
  }) {
    return _then(_$ProductModelImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as LocalizedString?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as LocalizedString?,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as ProductCategory?,
      imageUrls: null == imageUrls
          ? _value._imageUrls
          : imageUrls // ignore: cast_nullable_to_non_nullable
              as List<ImageUrl>,
      hasVariants: null == hasVariants
          ? _value.hasVariants
          : hasVariants // ignore: cast_nullable_to_non_nullable
              as bool,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
      discountPrice: freezed == discountPrice
          ? _value.discountPrice
          : discountPrice // ignore: cast_nullable_to_non_nullable
              as double?,
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
      servingSize: freezed == servingSize
          ? _value.servingSize
          : servingSize // ignore: cast_nullable_to_non_nullable
              as String?,
      servingsPerContainer: null == servingsPerContainer
          ? _value.servingsPerContainer
          : servingsPerContainer // ignore: cast_nullable_to_non_nullable
              as int,
      nutritionFacts: freezed == nutritionFacts
          ? _value._nutritionFacts
          : nutritionFacts // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      flavors: null == flavors
          ? _value._flavors
          : flavors // ignore: cast_nullable_to_non_nullable
              as List<String>,
      productSizes: null == productSizes
          ? _value._productSizes
          : productSizes // ignore: cast_nullable_to_non_nullable
              as List<ProductSize>,
      size: null == size
          ? _value._size
          : size // ignore: cast_nullable_to_non_nullable
              as List<String>,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      weight: freezed == weight
          ? _value.weight
          : weight // ignore: cast_nullable_to_non_nullable
              as double?,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      isBackgroundWhite: null == isBackgroundWhite
          ? _value.isBackgroundWhite
          : isBackgroundWhite // ignore: cast_nullable_to_non_nullable
              as bool,
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
      sku: freezed == sku
          ? _value.sku
          : sku // ignore: cast_nullable_to_non_nullable
              as String?,
      totalSales: null == totalSales
          ? _value.totalSales
          : totalSales // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      ingredients: null == ingredients
          ? _value._ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<String>,
      manufacturer: freezed == manufacturer
          ? _value.manufacturer
          : manufacturer // ignore: cast_nullable_to_non_nullable
              as String?,
      countryOfOrigin: freezed == countryOfOrigin
          ? _value.countryOfOrigin
          : countryOfOrigin // ignore: cast_nullable_to_non_nullable
              as String?,
      usageInstructions: freezed == usageInstructions
          ? _value.usageInstructions
          : usageInstructions // ignore: cast_nullable_to_non_nullable
              as String?,
      warnings: null == warnings
          ? _value._warnings
          : warnings // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductModelImpl extends _ProductModel {
  const _$ProductModelImpl(
      {@HiveField(0) required this.id,
      @HiveField(1) this.name,
      @HiveField(2) this.description,
      @HiveField(3) this.brand,
      @HiveField(4) this.category,
      @HiveField(5)
      @JsonKey(name: 'imageUrls')
      final List<ImageUrl> imageUrls = const [],
      @HiveField(6) @JsonKey(name: 'has_variants') this.hasVariants = false,
      @HiveField(7) this.price = 0,
      @HiveField(8) @JsonKey(name: 'discount_price') this.discountPrice,
      @HiveField(9) @JsonKey(name: 'stock_quantity') this.stockQuantity = 0,
      @HiveField(10) @JsonKey(name: 'average_rating') this.averageRating = 0.0,
      @HiveField(11) @JsonKey(name: 'review_count') this.reviewCount = 0,
      @HiveField(12) @JsonKey(name: 'serving_size') this.servingSize,
      @HiveField(13)
      @JsonKey(name: 'servings_per_container')
      this.servingsPerContainer = 0,
      @HiveField(14)
      @JsonKey(name: 'nutrition_facts')
      final Map<String, dynamic>? nutritionFacts,
      @HiveField(15)
      @JsonKey(name: 'flavors')
      final List<String> flavors = const [],
      @HiveField(16)
      @JsonKey(name: 'product_sizes')
      final List<ProductSize> productSizes = const [],
      @HiveField(17) @JsonKey(name: 'size') final List<String> size = const [],
      @HiveField(18) final List<String> tags = const [],
      @HiveField(19) this.weight,
      @HiveField(20) @JsonKey(name: 'is_active') this.isActive = true,
      @HiveField(21)
      @JsonKey(name: 'is_background_white')
      this.isBackgroundWhite = false,
      @HiveField(22) this.featured = false,
      @HiveField(23) @JsonKey(name: 'new_arrival') this.newArrival = false,
      @HiveField(24) @JsonKey(name: 'best_seller') this.bestSeller = false,
      @HiveField(25) this.sku,
      @HiveField(26) @JsonKey(name: 'total_sales') this.totalSales = 0,
      @HiveField(27) @JsonKey(name: 'created_at') this.createdAt,
      @HiveField(28) @JsonKey(name: 'updated_at') this.updatedAt,
      @HiveField(29) final List<String> ingredients = const [],
      @HiveField(30) this.manufacturer,
      @HiveField(31) @JsonKey(name: 'country_of_origin') this.countryOfOrigin,
      @HiveField(32)
      @JsonKey(name: 'usage_instructions')
      this.usageInstructions,
      @HiveField(33) final List<String> warnings = const []})
      : _imageUrls = imageUrls,
        _nutritionFacts = nutritionFacts,
        _flavors = flavors,
        _productSizes = productSizes,
        _size = size,
        _tags = tags,
        _ingredients = ingredients,
        _warnings = warnings,
        super._();

  factory _$ProductModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductModelImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final LocalizedString? name;
  @override
  @HiveField(2)
  final LocalizedString? description;
  @override
  @HiveField(3)
  final String? brand;
  @override
  @HiveField(4)
  final ProductCategory? category;
  final List<ImageUrl> _imageUrls;
  @override
  @HiveField(5)
  @JsonKey(name: 'imageUrls')
  List<ImageUrl> get imageUrls {
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imageUrls);
  }

  @override
  @HiveField(6)
  @JsonKey(name: 'has_variants')
  final bool hasVariants;
  @override
  @JsonKey()
  @HiveField(7)
  final double price;
  @override
  @HiveField(8)
  @JsonKey(name: 'discount_price')
  final double? discountPrice;
  @override
  @HiveField(9)
  @JsonKey(name: 'stock_quantity')
  final int stockQuantity;
  @override
  @HiveField(10)
  @JsonKey(name: 'average_rating')
  final double averageRating;
  @override
  @HiveField(11)
  @JsonKey(name: 'review_count')
  final int reviewCount;
  @override
  @HiveField(12)
  @JsonKey(name: 'serving_size')
  final String? servingSize;
  @override
  @HiveField(13)
  @JsonKey(name: 'servings_per_container')
  final int servingsPerContainer;
  final Map<String, dynamic>? _nutritionFacts;
  @override
  @HiveField(14)
  @JsonKey(name: 'nutrition_facts')
  Map<String, dynamic>? get nutritionFacts {
    final value = _nutritionFacts;
    if (value == null) return null;
    if (_nutritionFacts is EqualUnmodifiableMapView) return _nutritionFacts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  final List<String> _flavors;
  @override
  @HiveField(15)
  @JsonKey(name: 'flavors')
  List<String> get flavors {
    if (_flavors is EqualUnmodifiableListView) return _flavors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_flavors);
  }

  final List<ProductSize> _productSizes;
  @override
  @HiveField(16)
  @JsonKey(name: 'product_sizes')
  List<ProductSize> get productSizes {
    if (_productSizes is EqualUnmodifiableListView) return _productSizes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_productSizes);
  }

  final List<String> _size;
  @override
  @HiveField(17)
  @JsonKey(name: 'size')
  List<String> get size {
    if (_size is EqualUnmodifiableListView) return _size;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_size);
  }

  final List<String> _tags;
  @override
  @JsonKey()
  @HiveField(18)
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  @HiveField(19)
  final double? weight;
  @override
  @HiveField(20)
  @JsonKey(name: 'is_active')
  final bool isActive;
  @override
  @HiveField(21)
  @JsonKey(name: 'is_background_white')
  final bool isBackgroundWhite;
  @override
  @JsonKey()
  @HiveField(22)
  final bool featured;
  @override
  @HiveField(23)
  @JsonKey(name: 'new_arrival')
  final bool newArrival;
  @override
  @HiveField(24)
  @JsonKey(name: 'best_seller')
  final bool bestSeller;
  @override
  @HiveField(25)
  final String? sku;
  @override
  @HiveField(26)
  @JsonKey(name: 'total_sales')
  final int totalSales;
  @override
  @HiveField(27)
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @HiveField(28)
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
// Additional fields for product details
  final List<String> _ingredients;
// Additional fields for product details
  @override
  @JsonKey()
  @HiveField(29)
  List<String> get ingredients {
    if (_ingredients is EqualUnmodifiableListView) return _ingredients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ingredients);
  }

  @override
  @HiveField(30)
  final String? manufacturer;
  @override
  @HiveField(31)
  @JsonKey(name: 'country_of_origin')
  final String? countryOfOrigin;
  @override
  @HiveField(32)
  @JsonKey(name: 'usage_instructions')
  final String? usageInstructions;
  final List<String> _warnings;
  @override
  @JsonKey()
  @HiveField(33)
  List<String> get warnings {
    if (_warnings is EqualUnmodifiableListView) return _warnings;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_warnings);
  }

  @override
  String toString() {
    return 'ProductModel(id: $id, name: $name, description: $description, brand: $brand, category: $category, imageUrls: $imageUrls, hasVariants: $hasVariants, price: $price, discountPrice: $discountPrice, stockQuantity: $stockQuantity, averageRating: $averageRating, reviewCount: $reviewCount, servingSize: $servingSize, servingsPerContainer: $servingsPerContainer, nutritionFacts: $nutritionFacts, flavors: $flavors, productSizes: $productSizes, size: $size, tags: $tags, weight: $weight, isActive: $isActive, isBackgroundWhite: $isBackgroundWhite, featured: $featured, newArrival: $newArrival, bestSeller: $bestSeller, sku: $sku, totalSales: $totalSales, createdAt: $createdAt, updatedAt: $updatedAt, ingredients: $ingredients, manufacturer: $manufacturer, countryOfOrigin: $countryOfOrigin, usageInstructions: $usageInstructions, warnings: $warnings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductModelImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.category, category) ||
                other.category == category) &&
            const DeepCollectionEquality()
                .equals(other._imageUrls, _imageUrls) &&
            (identical(other.hasVariants, hasVariants) ||
                other.hasVariants == hasVariants) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.discountPrice, discountPrice) ||
                other.discountPrice == discountPrice) &&
            (identical(other.stockQuantity, stockQuantity) ||
                other.stockQuantity == stockQuantity) &&
            (identical(other.averageRating, averageRating) ||
                other.averageRating == averageRating) &&
            (identical(other.reviewCount, reviewCount) ||
                other.reviewCount == reviewCount) &&
            (identical(other.servingSize, servingSize) ||
                other.servingSize == servingSize) &&
            (identical(other.servingsPerContainer, servingsPerContainer) ||
                other.servingsPerContainer == servingsPerContainer) &&
            const DeepCollectionEquality()
                .equals(other._nutritionFacts, _nutritionFacts) &&
            const DeepCollectionEquality().equals(other._flavors, _flavors) &&
            const DeepCollectionEquality()
                .equals(other._productSizes, _productSizes) &&
            const DeepCollectionEquality().equals(other._size, _size) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.weight, weight) || other.weight == weight) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.isBackgroundWhite, isBackgroundWhite) ||
                other.isBackgroundWhite == isBackgroundWhite) &&
            (identical(other.featured, featured) ||
                other.featured == featured) &&
            (identical(other.newArrival, newArrival) ||
                other.newArrival == newArrival) &&
            (identical(other.bestSeller, bestSeller) ||
                other.bestSeller == bestSeller) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.totalSales, totalSales) ||
                other.totalSales == totalSales) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality()
                .equals(other._ingredients, _ingredients) &&
            (identical(other.manufacturer, manufacturer) ||
                other.manufacturer == manufacturer) &&
            (identical(other.countryOfOrigin, countryOfOrigin) ||
                other.countryOfOrigin == countryOfOrigin) &&
            (identical(other.usageInstructions, usageInstructions) ||
                other.usageInstructions == usageInstructions) &&
            const DeepCollectionEquality().equals(other._warnings, _warnings));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        description,
        brand,
        category,
        const DeepCollectionEquality().hash(_imageUrls),
        hasVariants,
        price,
        discountPrice,
        stockQuantity,
        averageRating,
        reviewCount,
        servingSize,
        servingsPerContainer,
        const DeepCollectionEquality().hash(_nutritionFacts),
        const DeepCollectionEquality().hash(_flavors),
        const DeepCollectionEquality().hash(_productSizes),
        const DeepCollectionEquality().hash(_size),
        const DeepCollectionEquality().hash(_tags),
        weight,
        isActive,
        isBackgroundWhite,
        featured,
        newArrival,
        bestSeller,
        sku,
        totalSales,
        createdAt,
        updatedAt,
        const DeepCollectionEquality().hash(_ingredients),
        manufacturer,
        countryOfOrigin,
        usageInstructions,
        const DeepCollectionEquality().hash(_warnings)
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
      @HiveField(1) final LocalizedString? name,
      @HiveField(2) final LocalizedString? description,
      @HiveField(3) final String? brand,
      @HiveField(4) final ProductCategory? category,
      @HiveField(5) @JsonKey(name: 'imageUrls') final List<ImageUrl> imageUrls,
      @HiveField(6) @JsonKey(name: 'has_variants') final bool hasVariants,
      @HiveField(7) final double price,
      @HiveField(8)
      @JsonKey(name: 'discount_price')
      final double? discountPrice,
      @HiveField(9) @JsonKey(name: 'stock_quantity') final int stockQuantity,
      @HiveField(10)
      @JsonKey(name: 'average_rating')
      final double averageRating,
      @HiveField(11) @JsonKey(name: 'review_count') final int reviewCount,
      @HiveField(12) @JsonKey(name: 'serving_size') final String? servingSize,
      @HiveField(13)
      @JsonKey(name: 'servings_per_container')
      final int servingsPerContainer,
      @HiveField(14)
      @JsonKey(name: 'nutrition_facts')
      final Map<String, dynamic>? nutritionFacts,
      @HiveField(15) @JsonKey(name: 'flavors') final List<String> flavors,
      @HiveField(16)
      @JsonKey(name: 'product_sizes')
      final List<ProductSize> productSizes,
      @HiveField(17) @JsonKey(name: 'size') final List<String> size,
      @HiveField(18) final List<String> tags,
      @HiveField(19) final double? weight,
      @HiveField(20) @JsonKey(name: 'is_active') final bool isActive,
      @HiveField(21)
      @JsonKey(name: 'is_background_white')
      final bool isBackgroundWhite,
      @HiveField(22) final bool featured,
      @HiveField(23) @JsonKey(name: 'new_arrival') final bool newArrival,
      @HiveField(24) @JsonKey(name: 'best_seller') final bool bestSeller,
      @HiveField(25) final String? sku,
      @HiveField(26) @JsonKey(name: 'total_sales') final int totalSales,
      @HiveField(27) @JsonKey(name: 'created_at') final DateTime? createdAt,
      @HiveField(28) @JsonKey(name: 'updated_at') final DateTime? updatedAt,
      @HiveField(29) final List<String> ingredients,
      @HiveField(30) final String? manufacturer,
      @HiveField(31)
      @JsonKey(name: 'country_of_origin')
      final String? countryOfOrigin,
      @HiveField(32)
      @JsonKey(name: 'usage_instructions')
      final String? usageInstructions,
      @HiveField(33) final List<String> warnings}) = _$ProductModelImpl;
  const _ProductModel._() : super._();

  factory _ProductModel.fromJson(Map<String, dynamic> json) =
      _$ProductModelImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  LocalizedString? get name;
  @override
  @HiveField(2)
  LocalizedString? get description;
  @override
  @HiveField(3)
  String? get brand;
  @override
  @HiveField(4)
  ProductCategory? get category;
  @override
  @HiveField(5)
  @JsonKey(name: 'imageUrls')
  List<ImageUrl> get imageUrls;
  @override
  @HiveField(6)
  @JsonKey(name: 'has_variants')
  bool get hasVariants;
  @override
  @HiveField(7)
  double get price;
  @override
  @HiveField(8)
  @JsonKey(name: 'discount_price')
  double? get discountPrice;
  @override
  @HiveField(9)
  @JsonKey(name: 'stock_quantity')
  int get stockQuantity;
  @override
  @HiveField(10)
  @JsonKey(name: 'average_rating')
  double get averageRating;
  @override
  @HiveField(11)
  @JsonKey(name: 'review_count')
  int get reviewCount;
  @override
  @HiveField(12)
  @JsonKey(name: 'serving_size')
  String? get servingSize;
  @override
  @HiveField(13)
  @JsonKey(name: 'servings_per_container')
  int get servingsPerContainer;
  @override
  @HiveField(14)
  @JsonKey(name: 'nutrition_facts')
  Map<String, dynamic>? get nutritionFacts;
  @override
  @HiveField(15)
  @JsonKey(name: 'flavors')
  List<String> get flavors;
  @override
  @HiveField(16)
  @JsonKey(name: 'product_sizes')
  List<ProductSize> get productSizes;
  @override
  @HiveField(17)
  @JsonKey(name: 'size')
  List<String> get size;
  @override
  @HiveField(18)
  List<String> get tags;
  @override
  @HiveField(19)
  double? get weight;
  @override
  @HiveField(20)
  @JsonKey(name: 'is_active')
  bool get isActive;
  @override
  @HiveField(21)
  @JsonKey(name: 'is_background_white')
  bool get isBackgroundWhite;
  @override
  @HiveField(22)
  bool get featured;
  @override
  @HiveField(23)
  @JsonKey(name: 'new_arrival')
  bool get newArrival;
  @override
  @HiveField(24)
  @JsonKey(name: 'best_seller')
  bool get bestSeller;
  @override
  @HiveField(25)
  String? get sku;
  @override
  @HiveField(26)
  @JsonKey(name: 'total_sales')
  int get totalSales;
  @override
  @HiveField(27)
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @HiveField(28)
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;
  @override // Additional fields for product details
  @HiveField(29)
  List<String> get ingredients;
  @override
  @HiveField(30)
  String? get manufacturer;
  @override
  @HiveField(31)
  @JsonKey(name: 'country_of_origin')
  String? get countryOfOrigin;
  @override
  @HiveField(32)
  @JsonKey(name: 'usage_instructions')
  String? get usageInstructions;
  @override
  @HiveField(33)
  List<String> get warnings;
  @override
  @JsonKey(ignore: true)
  _$$ProductModelImplCopyWith<_$ProductModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
