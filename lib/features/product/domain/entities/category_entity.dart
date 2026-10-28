import 'package:stronger_muscles/features/product/domain/entities/localized_string_entity.dart';

/// Pure domain entity representing a category.
class CategoryEntity {
  final String id;
  final LocalizedStringEntity? name;
  final LocalizedStringEntity? description;
  final String? imageUrl;
  final int sortOrder;
  final bool isActive;
  final DateTime? createdAt;
  final String? icon;
  final String? parentId;
  final List<CategoryEntity> children;

  const CategoryEntity({
    required this.id,
    this.name,
    this.description,
    this.imageUrl,
    this.sortOrder = 0,
    this.isActive = true,
    this.createdAt,
    this.icon,
    this.parentId,
    this.children = const [],
  });

  /// Get the category name in the specified locale
  String getLocalizedName({String locale = 'en'}) {
    return name?.getValue(locale: locale) ?? '';
  }

  /// Get the category description in the specified locale
  String getLocalizedDescription({String locale = 'en'}) {
    return description?.getValue(locale: locale) ?? '';
  }

  CategoryEntity copyWith({
    String? id,
    LocalizedStringEntity? name,
    LocalizedStringEntity? description,
    String? imageUrl,
    int? sortOrder,
    bool? isActive,
    DateTime? createdAt,
    String? icon,
    String? parentId,
    List<CategoryEntity>? children,
  }) {
    return CategoryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      icon: icon ?? this.icon,
      parentId: parentId ?? this.parentId,
      children: children ?? this.children,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryEntity &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          imageUrl == other.imageUrl &&
          sortOrder == other.sortOrder &&
          isActive == other.isActive &&
          createdAt == other.createdAt &&
          icon == other.icon &&
          parentId == other.parentId &&
          _areListsEqual(children, other.children);

  static bool _areListsEqual<T>(List<T> a, List<T> b) {
    if (identical(a, b)) return true;
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        description,
        imageUrl,
        sortOrder,
        isActive,
        createdAt,
        icon,
        parentId,
        Object.hashAll(children),
      );

  @override
  String toString() => 'CategoryEntity(id: $id, name: $name)';
}
