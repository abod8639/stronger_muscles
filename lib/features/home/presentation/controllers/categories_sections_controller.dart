import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/features/home/data/models/selection_model.dart';
import 'package:stronger_muscles/features/product/data/models/category_model.dart';
import 'package:stronger_muscles/features/product/data/repositories/category_repository.dart'; // استخدم الـ Repository
import 'package:stronger_muscles/features/home/presentation/controllers/home_controller.dart';

class CategoriesSectionsController extends GetxController {
  final HomeController _homeController = Get.find<HomeController>();
  final CategoryRepository _categoryRepository = Get.find<CategoryRepository>();

  final RxInt selectedIndex = 0.obs;
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxBool isLoading = false.obs;

  final RxList<SelectionsModel> selections = <SelectionsModel>[
    SelectionsModel(id: "", label: 'categoryHome', icon: Icons.home),
  ].obs;

  @override
  void onInit() {
    super.onInit();
    _initialize();

    ever<int>(_homeController.selectedSectionIndex, (index) {
      if (selectedIndex.value != index) {
        selectedIndex.value = index;
      }
    });
  }

  Future<void> _initialize() async {
    final cached = _categoryRepository.getCachedCategories();
    if (cached.isNotEmpty) {
      categories.assignAll(cached);
      _updateSelections(cached);
    }

    if (categories.isNotEmpty) {
      _fetchCategoriesInBackground();
      return;
    }

    await fetchCategories();
  }

  Future<void> _fetchCategoriesInBackground() async {
    try {
      final fetched = await _categoryRepository.getAllCategories();
      categories.assignAll(fetched);
      _updateSelections(fetched);
    } catch (e) {
      debugPrint('Background categories fetch error: $e');
    }
  }

  Future<void> fetchCategories() async {
    try {
      if (categories.isEmpty) isLoading.value = true;

      final fetched = await _categoryRepository.getAllCategories();
      categories.assignAll(fetched);
      _updateSelections(fetched);
    } catch (e) {
      print('DEBUG: Error in CategoriesSectionsController: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _updateSelections(List<CategoryModel> categoryList) {
    String? currentId;
    if (selectedIndex.value < selections.length) {
      currentId = selections[selectedIndex.value].id;
    }

    final List<SelectionsModel> newList = [
      SelectionsModel(id: "", label: 'categoryHome', icon: Icons.home),
      ...categoryList.map(
        (cat) => SelectionsModel(
          id: cat.id,
          label: cat.getLocalizedName(locale: Get.locale?.languageCode ?? 'en'),
          icon: _getIconForCategory(cat.id),
        ),
      ),
    ];

    selections.assignAll(newList);

    if (currentId != null) {
      final newIndex = selections.indexWhere((s) => s.id == currentId);
      if (newIndex != -1) {
        selectedIndex.value = newIndex;
        _homeController.selectedSectionIndex.value = newIndex;
      }
    }
  }

  void updateIndex(int index) {
    if (index >= 0 && index < selections.length) {
      selectedIndex.value = index;
      final selectedId = selections[index].id;

      _homeController.fetchProductsForSection(
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
