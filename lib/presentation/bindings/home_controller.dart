import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/product_model.dart';
import 'package:stronger_muscles/data/repositories/product_repository.dart';

class HomeController extends GetxController {
  final products = <ProductModel>[].obs;
  final _allProducts = <ProductModel>[];

  @override
  void onInit() {
    super.onInit();
    // Fetch products from a repository
    // For now, we'll use dummy data
    products.assignAll(dummyProducts);
    // keep a copy for search filtering
    _allProducts.addAll(products);
  }

  /// Simple client-side search that filters products by name.
  void onSearchChanged(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      products.assignAll(_allProducts);
      return;
    }
    products.assignAll(
      _allProducts.where((p) => p.name.toLowerCase().contains(q)).toList(),
    );
  }
}
