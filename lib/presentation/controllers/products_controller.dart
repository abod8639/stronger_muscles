import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/data/repositories/product_repository.dart';
import 'base_controller.dart';

class ProductsController extends BaseController {
  final ProductRepository _repository = Get.find<ProductRepository>();

  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxString selectedCategoryId = ''.obs;
  final RxString selectedProductId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeData();
  }

  Future<void> _initializeData() async {
    // تحميل البيانات من الكاش فوراً لتحسين تجربة المستخدم (Zero Wait UI)
    products.assignAll(_repository.getCachedProducts());
    // جلب البيانات من السيرفر في الخلفية لتحديث القائمة
    await fetchProducts();
  }

  Future<void> fetchProducts({String? categoryId, String? query}) async {
    // منع الطلبات المتعددة في نفس الوقت
    if (isLoading.value) return;

    try {
      if (products.isEmpty) setLoading(true);

      List<ProductModel> result;

      if (query != null && query.isNotEmpty) {
        result = await _repository.searchProducts(query);
      } else if (categoryId != null && categoryId.isNotEmpty) {
        // هنا نستخدم repository.getProducts الذي يدعم الفلترة
        result = await _repository.getProducts(categoryId: categoryId);
      } else {
        result = await _repository.getProducts();
      }

      // 3. تحديث الواجهة بالنتائج الجديدة
      products.assignAll(result);
      
      // مسح حالة الخطأ في حال نجاح الطلب
      resetState();
    } catch (e) {
      // الـ handleError في الـ BaseController سيتولى إظهار الـ SnackBar أو الـ Dialog
      handleError(
        e,
        message: 'تعذر تحديث المنتجات حالياً',
        retryAction: () => fetchProducts(categoryId: categoryId, query: query),
      );
    } finally {
      setLoading(false);
    }
  }

  Future<void> refreshProducts() async {
    selectedCategoryId.value = '';
    // مسح الكاش قد يكون مفيداً عند السحب لأسفل (Pull to refresh)
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

  // تحويل الدوال إلى Getters لتحسين الأداء في Widget Tree
  ProductModel? get selectedProduct => 
      products.firstWhereOrNull((p) => p.id == selectedProductId.value);

  String get price {
    return selectedProduct?.formattedEffectivePrice ?? "0.00";
  }

  String get discountPrice {
    return selectedProduct?.formattedPrice ?? "0.00";
  }
}