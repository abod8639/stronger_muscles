import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/features/home/data/models/selection_model.dart';
import 'package:stronger_muscles/features/product/data/models/category_model.dart';
import 'package:stronger_muscles/features/product/data/repositories/category_repository.dart';
import 'package:stronger_muscles/features/profile/presentation/controllers/language_controller.dart';
import 'package:stronger_muscles/features/home/presentation/controllers/home_controller.dart';

part 'categories_sections_controller.g.dart';

@riverpod
class SelectedCategoryIndex extends _$SelectedCategoryIndex {
  @override
  int build() => 0;

  void setIndex(int index) => state = index;
}

@riverpod
class CategoriesSectionsController extends _$CategoriesSectionsController {
  @override
  FutureOr<List<SelectionsModel>> build() async {
    final categoryRepository = ref.watch(categoryRepositoryProvider);
    final locale = ref.watch(languageControllerProvider);
    final langCode = locale.languageCode;

    final cached = categoryRepository.getCachedCategories();
    if (cached.isNotEmpty) {
      _categories = cached;
      return _getSelectionsList(cached, langCode);
    }

    final fetched = await categoryRepository.getAllCategories();
    _categories = fetched;
    return _getSelectionsList(fetched, langCode);
  }

  int get selectedIndex => ref.read(selectedCategoryIndexProvider);

  List<CategoryModel> _categories = [];
  List<CategoryModel> get categories => _categories;

  Future<void> fetchCategories() async {
    state = const AsyncLoading();
    final categoryRepository = ref.read(categoryRepositoryProvider);
    final langCode = ref.read(languageControllerProvider).languageCode;
    try {
      final fetched = await categoryRepository.getAllCategories();
      _categories = fetched;
      state = AsyncData(_getSelectionsList(fetched, langCode));
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  List<SelectionsModel> _getSelectionsList(
      List<CategoryModel> categoryList, String langCode) {
    return [
      SelectionsModel(id: "", label: 'categoryHome', icon: Icons.home),
      ...categoryList.map(
        (cat) => SelectionsModel(
          id: cat.id,
          label: cat.getLocalizedName(locale: langCode),
          icon: _getIconForCategory(cat.id),
        ),
      ),
    ];
  }

  void updateIndex(int index) {
    if (index >= 0 && state.hasValue && index < state.value!.length) {
      ref.read(selectedCategoryIndexProvider.notifier).setIndex(index);
      final selectedId = state.value![index].id;

      ref
          .read(homeControllerProvider.notifier)
          .fetchProductsForSection(
            index,
            categoryId: selectedId.isEmpty ? null : selectedId,
          );
    }
  }

  IconData _getIconForCategory(String id) {
    final icons = {
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
