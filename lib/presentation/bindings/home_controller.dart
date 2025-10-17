
import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/product_model.dart';

class HomeController extends GetxController {

  final products = <ProductModel>[].obs;
  final _allProducts = <ProductModel>[];

  @override
  void onInit() {
    super.onInit();
    // Fetch products from a repository
    // For now, we'll use dummy data
    products.assignAll([
      ProductModel(
        id: '1',
        name: 'Whey Protein',
        price: 5999.00,
        imageUrl: ['https://wayupsports.com/cdn/shop/files/10843.jpg?v=1756650182&width=1000'],
        description: 'High-quality whey protein for muscle growth.',
      ),
      ProductModel(
        id: '2',
        name: 'Creatine Monohydrate',
        price: 2999.00,
        imageUrl: ['https://wayupsports.com/cdn/shop/files/10821_368621d1-1d16-402a-93e0-f1c9f0e146af.jpg?v=1692179491&width=1000'],
        description: 'Pure creatine for increased strength and performance.',
      ),
      ProductModel(
        id: '3',
        name: 'Pre-Workout Formula',
        price: 3999.00,
        imageUrl: ['https://wayupsports.com/cdn/shop/files/021A2180.jpg?v=1721199895&width=700'],
        description: 'Explosive energy and focus for your workouts.',
      ),
      ProductModel(
        id: '4',
        name: 'Creatine Powder',
        price: 1909.00,
        imageUrl: ['https://wayupsports.com/cdn/shop/files/ON_CREATINE_POWDER_300G_a0debbc6-79be-4e04-916e-6f82b813c4e6.jpg?v=1716891377&width=1000'],
        description: 'Boost energy and focus for your workouts.',
      ),
      ProductModel(
        id: '5',
        name: 'Clear Blue Shaker',
        price: 200.00,
        imageUrl: ['https://wayupsports.com/cdn/shop/files/6224009096169_max_muscle_7f8a569d-bed6-4563-8c06-e4528df1111b.jpg?v=1683722662&width=1000'],
        description: 'Boost energy and focus for your workouts.',
      ),
    ]);
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
