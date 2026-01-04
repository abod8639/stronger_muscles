import 'package:hive/hive.dart';

part 'category_model.g.dart';

@HiveType(typeId: 6)
class CategoryModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final String? imageUrl;

  @HiveField(4)
  final int sortOrder;

  @HiveField(5)
  final bool isActive;

  @HiveField(6)
  final DateTime createdAt;

  CategoryModel({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    this.sortOrder = 0,
    this.isActive = true,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Factory constructor to create CategoryModel from JSON
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      imageUrl: json['image_url'],
      sortOrder: json['sort_order'] ?? 0,
      isActive: json['is_active'] == 1 || json['is_active'] == true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  /// Convert CategoryModel to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'image_url': imageUrl,
        'sort_order': sortOrder,
        'is_active': isActive,
        'created_at': createdAt.toIso8601String(),
      };

  /// Create a copy with updated fields
  CategoryModel copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    int? sortOrder,
    bool? isActive,
    DateTime? createdAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// Predefined categories for the supplements store
class PredefinedCategories {
  static final List<CategoryModel> categories = [
    CategoryModel(
      id: 'protein',
      name: 'Protein',
      description: 'Protein powders and supplements',
      sortOrder: 1,
    ),
    CategoryModel(
      id: 'creatine',
      name: 'Creatine',
      description: 'Creatine supplements',
      sortOrder: 2,
    ),
    CategoryModel(
      id: 'amino',
      name: 'Amino Acids',
      description: 'Amino acid supplements',
      sortOrder: 3,
    ),
    CategoryModel(
      id: 'bcaa',
      name: 'BCAA',
      description: 'Branched-chain amino acids',
      sortOrder: 4,
    ),
    CategoryModel(
      id: 'preworkout',
      name: 'Pre-Workout',
      description: 'Pre-workout supplements',
      sortOrder: 5,
    ),
    CategoryModel(
      id: 'massgainer',
      name: 'Mass Gainer',
      description: 'Mass gainer supplements',
      sortOrder: 6,
    ),
    CategoryModel(
      id: 'accessories',
      name: 'Accessories',
      description: 'Shakers, bags, and accessories',
      sortOrder: 7,
    ),
  ];

  static CategoryModel? getById(String id) {
    try {
      return categories.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }
}
