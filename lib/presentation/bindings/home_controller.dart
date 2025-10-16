
import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/product_model.dart';

class HomeController extends GetxController {
  final products = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Fetch products from a repository
    // For now, we'll use dummy data
    products.assignAll([
      ProductModel(
        id: '1',
        name: 'Whey Protein',
        price: 59.99,
        imageUrl: 'https://wayupsports.com/cdn/shop/files/10843.jpg?v=1756650182&width=1000',
        description: 'High-quality whey protein for muscle growth.',
      ),
      ProductModel(
        id: '2',
        name: 'Creatine Monohydrate',
        price: 29.99,
        imageUrl: 'https://wayupsports.com/cdn/shop/files/10821_368621d1-1d16-402a-93e0-f1c9f0e146af.jpg?v=1692179491&width=1000',
        description: 'Pure creatine for increased strength and performance.',
      ),
      ProductModel(
        id: '3',
        name: 'Pre-Workout Formula',
        price: 39.99,
        imageUrl: 'https://wayupsports.com/cdn/shop/files/021A2180.jpg?v=1721199895&width=700',
        description: 'Explosive energy and focus for your workouts.',
      ),
    ]);
  }
}
