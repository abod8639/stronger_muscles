import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/data/models/localized_string_model.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

@freezed
@HiveType(typeId: 6, adapterName: 'CategoryModelAdapter')
class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    @HiveField(0) required String id,
    @HiveField(1) LocalizedString? name,
    @HiveField(2) LocalizedString? description,
    @HiveField(3) String? imageUrl,
    @HiveField(4) @Default(0) int sortOrder,
    @HiveField(5) @Default(true) bool isActive,
    @HiveField(6) DateTime? createdAt,
    @HiveField(7) String? icon,
    @HiveField(8) String? parentId,
    @HiveField(9) @Default([]) List<CategoryModel> children,
  }) = _CategoryModel;

  const CategoryModel._();

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  /// Get the category name in the specified locale
  String getLocalizedName({String locale = 'en'}) {
    return name?.getValue(locale: locale) ?? '';
  }

  /// Get the category description in the specified locale
  String getLocalizedDescription({String locale = 'en'}) {
    return description?.getValue(locale: locale) ?? '';
  }
}

/// Predefined categories for the supplements store
class PredefinedCategories {
  static final List<CategoryModel> categories = [
    CategoryModel(
      id: 'protein',
      name: const LocalizedString(ar: 'بروتين', en: 'Protein'),
      description: const LocalizedString(
        ar: 'مكملات البروتين',
        en: 'Protein powders and supplements',
      ),
      sortOrder: 1,
    ),
    CategoryModel(
      id: 'creatine',
      name: const LocalizedString(ar: 'كرياتين', en: 'Creatine'),
      description: const LocalizedString(
        ar: 'مكملات الكرياتين',
        en: 'Creatine supplements',
      ),
      sortOrder: 2,
    ),
    CategoryModel(
      id: 'amino',
      name: const LocalizedString(ar: 'أمينو', en: 'Amino Acids'),
      description: const LocalizedString(
        ar: 'مكملات الأحماض الأمينية',
        en: 'Amino acid supplements',
      ),
      sortOrder: 3,
    ),
    CategoryModel(
      id: 'bcaa',
      name: const LocalizedString(ar: 'BCAA', en: 'BCAA'),
      description: const LocalizedString(
        ar: 'أحماض أمينية متشعبة',
        en: 'Branched-chain amino acids',
      ),
      sortOrder: 4,
    ),
    CategoryModel(
      id: 'preworkout',
      name: const LocalizedString(ar: 'قبل التمرين', en: 'Pre-Workout'),
      description: const LocalizedString(
        ar: 'مكملات قبل التمرين',
        en: 'Pre-workout supplements',
      ),
      sortOrder: 5,
    ),
    CategoryModel(
      id: 'massgainer',
      name: const LocalizedString(ar: 'زيادة الوزن', en: 'Mass Gainer'),
      description: const LocalizedString(
        ar: 'مكملات زيادة الوزن',
        en: 'Mass gainer supplements',
      ),
      sortOrder: 6,
    ),
    CategoryModel(
      id: 'accessories',
      name: const LocalizedString(ar: 'إكسسوارات', en: 'Accessories'),
      description: const LocalizedString(
        ar: 'شيكرات وحقائب وإكسسوارات',
        en: 'Shakers, bags, and accessories',
      ),
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
