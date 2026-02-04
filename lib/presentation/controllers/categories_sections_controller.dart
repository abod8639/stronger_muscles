import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/services/category_service.dart';
import 'package:stronger_muscles/data/models/category_model.dart';
import 'package:stronger_muscles/data/models/selection_model.dart';
import 'package:stronger_muscles/presentation/controllers/home_controller.dart';

class CategoriesSectionsController extends GetxController {
  final HomeController _homeController = Get.put(HomeController());
  final CategoryService _categoryService = Get.put(CategoryService());

  final RxInt selectedIndex = 0.obs;
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxBool isLoading = false.obs;

  final RxList<SelectionsModel> selections = <SelectionsModel>[
    SelectionsModel(id: "", label: 'categoryHome', icon: Icons.home),
  ].obs;

  @override
  void onInit() {
    super.onInit();
    _loadCachedData();
    fetchCategories();
    ever<int>(_homeController.selectedSectionIndex, (index) {
      selectedIndex.value = index;
    });
  }

  Future<void> _loadCachedData() async {
    final cachedCategories = await _categoryService.getCachedCategories();
    if (cachedCategories.isNotEmpty) {
      categories.assignAll(cachedCategories);
      _updateSelections(cachedCategories);
    }
  }

  Future<void> fetchCategories() async {
    try {
      isLoading.value = categories.isEmpty;
      final fetchedCategories = await _categoryService.getCategories();
      categories.assignAll(fetchedCategories);
      _updateSelections(fetchedCategories);
    } catch (e) {
      print('Error fetching categories: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _updateSelections(List<CategoryModel> categoryList) {
    String? currentSelectedId;
    if (selectedIndex.value >= 0 && selectedIndex.value < selections.length) {
      currentSelectedId = selections[selectedIndex.value].id;
    }

    final List<SelectionsModel> list = [
      SelectionsModel(id: "", label: 'categoryHome', icon: Icons.home),
    ];

    for (var cat in categoryList) {
      list.add(
        SelectionsModel(
          id: cat.id,
          label: cat.name,
          icon: _getIconForCategory(cat.id),
        ),
      );
    }

    selections.assignAll(list);

    // Restore selection index based on the ID we had
    if (currentSelectedId != null) {
      final newIndex = selections.indexWhere((s) => s.id == currentSelectedId);
      if (newIndex != -1) {
        selectedIndex.value = newIndex;
        _homeController.selectedSectionIndex.value = newIndex;
      } else {
        // Fallback to Home if previously selected category is gone
        selectedIndex.value = 0;
        _homeController.selectedSectionIndex.value = 0;
      }
    }
  }

  IconData _getIconForCategory(String id) {
    switch (id) {
      case 'cat-creatine':
        return Icons.local_fire_department_outlined;
      case 'cat-protein':
        return Icons.fitness_center;
      case 'cat-amino':
        return Icons.local_drink;
      case 'cat-vitamins':
        return Icons.medication;
      case 'cat-preworkout':
        return Icons.flash_on;
      case 'cat-recovery':
        return Icons.healing;
      case 'cat-fatburner':
        return Icons.local_fire_department;
      case 'cat-health':
        return Icons.favorite;
      case 'cat-mass-gainer':
        return Icons.monitor_weight_outlined;
      case 'cat-carb':
        return Icons.bakery_dining_outlined;
      default:
        return Icons.category;
    }
  }

  void updateIndex(int index) {
    if (index >= 0 && index < selections.length) {
      final selectedId = selections[index].id;
      final categoryId = selectedId.isEmpty ? null : selectedId;
      _homeController.fetchProductsForSection(index, categoryId: categoryId);
    }
  }

}
