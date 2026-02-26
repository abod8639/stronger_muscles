import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/core/services/product_service.dart';
import 'package:stronger_muscles/data/models/product_model.dart';

class ProductRepository {
  final ProductService _service = Get.find<ProductService>();

  // تأكد من أن Box المنتجات مفتوح بالفعل في الـ main أو الـ Service
  final Box<ProductModel> _box = Hive.box<ProductModel>('products');

  /// Get cached products
  List<ProductModel> getCachedProducts() => _box.values.toList();

  /// Fetch and cache products
  Future<List<ProductModel>> getProducts({
    String? categoryId,
    int page = 1,
  }) async {
    try {
      final products = await _service.getProducts(
        categoryId: categoryId,
        page: page,
      );

      // تحديث الـ Cache
      // ملاحظة: إذا كانت الصفحة 1، قد ترغب في مسح الكاش القديم أو تحديثه فقط
      for (var product in products) {
        await _box.put(product.id, product);
      }

      return products;
    } on Failure catch (e) {
      // إرجاع البيانات المخزنة فقط في حال وجود مشكلة بالشبكة
      if (e.type == FailureType.network && _box.isNotEmpty) {
        if (categoryId != null) {
          return _box.values.where((p) => p.categoryId == categoryId).toList();
        }
        return _box.values.toList();
      }
      rethrow;
    }
  }

  Future<ProductModel> getProductDetails(String id) async {
    try {
      final product = await _service.getProductDetails(id);
      await _box.put(product.id, product);
      return product;
    } on Failure {
      if (_box.containsKey(id)) {
        return _box.get(id)!;
      }
      rethrow;
    }
  }

  Future<List<ProductModel>> searchProducts(String query) async {
    try {
      // البحث دائماً يفضل أن يكون من السيرفر للحصول على نتائج أدق
      return await _service.getProducts(query: query);
    } on Failure catch (e) {
      if (e.type == FailureType.network) {
        final currentLocale = Get.locale?.languageCode ?? 'ar';
        return _box.values
            .where(
              (p) => p
                  .getLocalizedName(locale: currentLocale)
                  .toLowerCase()
                  .contains(query.toLowerCase()),
            )
            .toList();
      }
      rethrow;
    }
  }

  /// مسح الكاش (مثلاً عند عمل Logout أو Refresh يدوي)
  Future<void> clearCache() async {
    await _box.clear();
  }
}
