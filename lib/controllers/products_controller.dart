import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/core/services/product_service.dart';
import 'package:stronger_muscles/data/models/product_model.dart';

class ProductsController extends GetxController {
  final ProductService _productService = Get.find<ProductService>();
  final Box<ProductModel> _productBox = Hive.box<ProductModel>('products');

  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadLocalData(); // اعرض البيانات القديمة فوراً
    fetchProducts(); // حاول التحديث من السيرفر
  }

  // تحميل سريع من الذاكرة المحلية
  void _loadLocalData() {
    if (_productBox.isNotEmpty) {
      products.assignAll(_productBox.values.toList());
    }
  }

  Future<void> fetchProducts({
    String? categoryId,
    String? query,
    bool refresh = false,
  }) async {
    try {
      if (products.isEmpty) isLoading.value = true;

      final fetchedProducts = await _productService.getProducts(
        categoryId: categoryId,
        query: query,
      );

      products.assignAll(fetchedProducts);
    } catch (e) {
      // إذا فشل الإنترنت، ستظل البيانات المحلية معروضة
      if (products.isEmpty) {
        Get.snackbar(
          'تنبيه',
          'لا يوجد اتصال بالإنترنت والبيانات المحلية فارغة',
        );
      }
    } finally {
      isLoading.value = false;
    }
  }
}
