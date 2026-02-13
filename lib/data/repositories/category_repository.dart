import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/core/services/category_service.dart';
import '../../data/models/category_model.dart';

class CategoryRepository {
  final CategoryService _service = Get.put(CategoryService());
  // final CategoryService _service = Get.find<CategoryService>();
  final Box<CategoryModel> _box = Hive.box<CategoryModel>('categories');

  /// جلب البيانات المحلية (Offline-First)
  List<CategoryModel> getCachedCategories() => _box.values.toList();

  /// المزامنة مع السيرفر
  Future<List<CategoryModel>> getAllCategories() async {
    try {
      final categories = await _service.fetchCategoriesFromApi();

      // تحديث الكاش بالكامل
      await _box.clear();
      await _box.addAll(categories);

      return categories;
    } on Failure catch (e) {
      // إذا فشل الاتصال، نرجع ما لدينا في الكاش
      if (e.type == FailureType.network && _box.isNotEmpty) {
        return _box.values.toList();
      }
      rethrow;
    }
  }
}
