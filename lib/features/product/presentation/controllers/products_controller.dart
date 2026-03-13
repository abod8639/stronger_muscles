import 'package:get/get.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/product/data/repositories/product_repository.dart';
import '../../../home/presentation/controllers/base_controller.dart';

class ProductsController extends BaseController {
  final ProductRepository _repository = Get.find<ProductRepository>();
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxString selectedCategoryId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    products.assignAll(_repository.getCachedProducts());
    fetchProducts();
  }

Future<void> fetchProducts({String? categoryId, String? query}) async {
    if (isLoading.value) return;
    try {
      if (products.isEmpty) setLoading(true);

      List<ProductModel> result;

      if (query != null && query.trim().isNotEmpty) {
        result = await _repository.searchProducts(query);
      } else {
        result = await _repository.getProducts(
          categoryId: categoryId ?? (selectedCategoryId.value.isEmpty ? null : selectedCategoryId.value),
        );
      }

      products.assignAll(result);
      resetState();
    } catch (e) {
      handleError(e, message: 'تعذر تحديث المنتجات');
    } finally {
      setLoading(false);
    }
  }

  void filterByCategory(String categoryId) {
    selectedCategoryId.value = (selectedCategoryId.value == categoryId) ? '' : categoryId;
    fetchProducts(categoryId: selectedCategoryId.value.isEmpty ? null : selectedCategoryId.value);
  }
}