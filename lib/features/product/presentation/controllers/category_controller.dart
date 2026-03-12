import 'package:get/get.dart';
import 'package:stronger_muscles/features/product/data/repositories/category_repository.dart';
import 'package:stronger_muscles/features/product/data/models/category_model.dart';
import '../../../home/presentation/controllers/base_controller.dart';

class CategoryController extends BaseController {
  final CategoryRepository _repository = Get.find<CategoryRepository>();
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    categories.assignAll(_repository.getCachedCategories());
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final result = await _repository.getAllCategories();
      categories.assignAll(result);
    } catch (e) {
      handleError(e);
    }
  }
}