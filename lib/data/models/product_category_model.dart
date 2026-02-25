import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/data/models/localized_string_model.dart';

part 'product_category_model.freezed.dart';
part 'product_category_model.g.dart';

@freezed
@HiveType(typeId: 13, adapterName: 'ProductCategoryAdapter')
class ProductCategory with _$ProductCategory {
  const factory ProductCategory({
    @HiveField(0) @JsonKey(name: 'id') required String id,
    @HiveField(1) @JsonKey(name: 'name') LocalizedString? name,
  }) = _ProductCategory;

  const ProductCategory._();

  factory ProductCategory.fromJson(Map<String, dynamic> json) =>
      _$ProductCategoryFromJson(json);

  /// Get the category name in the specified locale
  String getLocalizedName({String locale = 'en'}) {
    return name?.getValue(locale: locale) ?? '';
  }
}
