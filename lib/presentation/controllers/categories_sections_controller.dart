import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/category_model.dart';
import 'package:stronger_muscles/data/models/selection_model.dart';
import 'package:stronger_muscles/data/repositories/category_repository.dart'; // استخدم الـ Repository
import 'package:stronger_muscles/presentation/controllers/home_controller.dart';

class CategoriesSectionsController extends GetxController {
  final HomeController _homeController = Get.find<HomeController>();
  final CategoryRepository _categoryRepository = Get.find<CategoryRepository>();

  final RxInt selectedIndex = 0.obs;
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxBool isLoading = false.obs;

  // قائمة الاختيارات التي تظهر في الـ UI
  final RxList<SelectionsModel> selections = <SelectionsModel>[
    SelectionsModel(id: "", label: 'categoryHome', icon: Icons.home),
  ].obs;

  @override
  void onInit() {
    super.onInit();
    _initialize();
    
    // مراقبة التغيير في الـ HomeController لمزامنة الـ UI
    ever<int>(_homeController.selectedSectionIndex, (index) {
      if (selectedIndex.value != index) {
        selectedIndex.value = index;
      }
    });
  }

  Future<void> _initialize() async {
    // 1. تحميل الكاش فوراً
    final cached = _categoryRepository.getCachedCategories();
    if (cached.isNotEmpty) {
      categories.assignAll(cached);
      _updateSelections(cached);
    }

    // 2. جلب الجديد من السيرفر
    await fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      // إظهار التحميل فقط إذا كان الكاش فارغاً
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
    // حفظ المعرف المختار حالياً قبل التحديث
    String? currentId;
    if (selectedIndex.value < selections.length) {
      currentId = selections[selectedIndex.value].id;
    }

    // بناء القائمة الجديدة
    final List<SelectionsModel> newList = [
      SelectionsModel(id: "", label: 'categoryHome', icon: Icons.home),
      ...categoryList.map((cat) => SelectionsModel(
            id: cat.id,
            label: cat.name,
            icon: _getIconForCategory(cat.id),
          )),
    ];

    selections.assignAll(newList);

    // إعادة ضبط الـ index بناءً على الـ ID المحفوظ
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
      
      // إرسال الأمر للـ HomeController لجلب المنتجات بناءً على القسم المختار
      _homeController.fetchProductsForSection(
        index, 
        categoryId: selectedId.isEmpty ? null : selectedId,
      );
    }
  }

  IconData _getIconForCategory(String id) {
    // نستخدم الـ Map بدلاً من Switch ليكون الكود أنظف وقابل للتوسع
    final icons = {
      'cat-creatine': Icons.local_fire_department_outlined,
      'cat-protein': Icons.fitness_center,
      'cat-amino': Icons.local_drink,
      'cat-vitamins': Icons.medication,
      'cat-preworkout': Icons.flash_on,
      'cat-recovery': Icons.healing,
      'cat-fatburner': Icons.local_fire_department,
      'cat-health': Icons.favorite,
      'cat-mass-gainer': Icons.monitor_weight_outlined,
      'cat-carb': Icons.bakery_dining_outlined,
    };
    return icons[id] ?? Icons.category;
  }
}