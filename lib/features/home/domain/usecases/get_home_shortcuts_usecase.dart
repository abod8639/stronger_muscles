import 'package:flutter/material.dart';
import 'package:stronger_muscles/features/home/domain/entities/selection_entity.dart';
import 'package:stronger_muscles/features/product/domain/repositories/category_repository.dart';

/// Use case to fetch categories and map them to home shortcut items.
class GetHomeShortcutsUseCase {
  final CategoryRepository _categoryRepository;

  const GetHomeShortcutsUseCase(this._categoryRepository);

  Future<List<SelectionEntity>> call({required String langCode}) async {
    final cached = _categoryRepository.getCachedCategories();
    final categories = cached.isNotEmpty
        ? cached
        : await _categoryRepository.getAllCategories();

    return [
      const SelectionEntity(id: '', label: 'categoryHome', icon: Icons.home),
      ...categories.map(
        (cat) => SelectionEntity(
          id: cat.id,
          label: cat.getLocalizedName(locale: langCode),
          icon: getIconForCategory(cat.id),
        ),
      ),
    ];
  }

  static IconData getIconForCategory(String id) {
    const icons = {
      'creatine': Icons.cookie_outlined,
      'protein': Icons.fitness_center,
      'amino-acid': Icons.local_drink,
      'vitamins': Icons.medication,
      'preworkout': Icons.flash_on,
      'recovery': Icons.healing,
      'Fat-Burner': Icons.local_fire_department_outlined,
      'health': Icons.favorite,
      'mass-gainers': Icons.man_3_sharp,
      'carb': Icons.bakery_dining_outlined,
    };
    return icons[id] ?? Icons.category;
  }
}
