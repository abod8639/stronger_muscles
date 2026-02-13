import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/data/repositories/product_repository.dart';
import 'base_controller.dart';

class ProductsController extends BaseController {
  final ProductRepository _repository = Get.find<ProductRepository>();

  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxString selectedCategoryId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  Future<void> _initializeData() async {
    products.assignAll(_repository.getCachedProducts());
    await fetchProducts();
  }

  Future<void> fetchProducts({String? categoryId, String? query}) async {
    if (isLoading.value) return;

    try {
      if (query == null && categoryId != null && categoryId.isNotEmpty) {
        final cached = _repository
            .getCachedProducts()
            .where((p) => p.categoryId == categoryId)
            .toList();
        if (cached.isNotEmpty) {
          products.assignAll(cached);
        }
      }

      if (products.isEmpty) setLoading(true);

      List<ProductModel> result;

      if (query != null && query.isNotEmpty) {
        result = await _repository.searchProducts(query);
      } else if (categoryId != null && categoryId.isNotEmpty) {
        result = await _repository.getProductsByCategory(categoryId);
      } else {
        result = await _repository.getProducts();
      }

      products.assignAll(result);
      resetState();
    } catch (e) {
      handleError(
        e,
        message: 'فشل تحديث البيانات، تأكد من اتصالك بالإنترنت',
        retryAction: () => fetchProducts(categoryId: categoryId, query: query),
      );
    } finally {
      setLoading(false);
    }
  }

  Future<void> refreshProducts() async {
    selectedCategoryId.value = '';
    await fetchProducts();
  }

  void filterByCategory(String categoryId) {
    if (selectedCategoryId.value == categoryId) {
      selectedCategoryId.value = '';
      fetchProducts();
    } else {
      selectedCategoryId.value = categoryId;
      fetchProducts(categoryId: categoryId);
    }
  }
}
