import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/core/services/category_service.dart';
import 'package:stronger_muscles/data/models/category_model.dart';
import 'package:stronger_muscles/data/models/selection_model.dart';
import 'package:stronger_muscles/presentation/bindings/home_controller.dart';

class SectionsController extends GetxController {
  final HomeController _homeController = Get.put(HomeController());
  final CategoryService _categoryService = Get.put(CategoryService());

  final RxInt selectedIndex = 0.obs;
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxBool isLoading = false.obs;

  final RxList<SelectionsModel> selections = <SelectionsModel>[
    SelectionsModel(
      id: "",
      label: 'categoryHome',
      icon: Icons.home,
    ),
  ].obs;

  @override
  void onInit() {
    super.onInit();
    _loadCachedData();
    fetchCategories();
    // Listen to changes in homeController's selected index
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
    final List<SelectionsModel> list = [
      SelectionsModel(
        id: "",
        label: 'categoryHome',
        icon: Icons.home,
      ),
    ];

    for (var cat in categoryList) {
      list.add(SelectionsModel(
        id: cat.id,
        label: cat.name,
        icon: _getIconForCategory(cat.id),
      ));
    }
    
    selections.assignAll(list);
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