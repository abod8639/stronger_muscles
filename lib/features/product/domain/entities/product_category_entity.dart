import 'package:flutter/foundation.dart';
import 'package:stronger_muscles/features/product/domain/entities/localized_string_entity.dart';

/// Pure domain entity representing a product category association.
@immutable
class ProductCategoryEntity {
  final String id;
  final LocalizedStringEntity? name;

  const ProductCategoryEntity({
    required this.id,
    this.name,
  });

  String getLocalizedName({String locale = 'en'}) {
    return name?.getValue(locale: locale) ?? '';
  }

  ProductCategoryEntity copyWith({
    String? id,
    LocalizedStringEntity? name,
  }) {
    return ProductCategoryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductCategoryEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name;

  @override
  int get hashCode => id.hashCode ^ name.hashCode;

  @override
  String toString() => 'ProductCategoryEntity(id: $id, name: $name)';
}
