import 'package:stronger_muscles/data/models/product_model.dart';

class ProductRepository {
  // This is a dummy repository to simulate fetching product details.
  // In a real application, this would interact with a backend API or a local database.
  Future<ProductModel?> getProductById(String id) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Dummy product data
    final List<ProductModel> dummyProducts = [
      ProductModel(
        id: '1',
        name: 'Whey Protein',
        price: 59.99,
        imageUrl:
            [
            'https://wayupsports.com/cdn/shop/files/10843.jpg?v=1756650182&width=1000',
            'https://wayupsports.com/cdn/shop/files/10843_1.jpg?v=1756650182&width=1000',
            'https://wayupsports.com/cdn/shop/files/10843_2.jpg?v=1756650182&width=1000',
            'https://wayupsports.com/cdn/shop/files/10843_3.jpg?v=1756650182&width=1000',
            ],
        description: 'High-quality whey protein for muscle growth.',
      ),
      ProductModel(
        id: '2',
        name: 'Creatine Monohydrate',
        price: 29.99,
        imageUrl:
            ['https://wayupsports.com/cdn/shop/files/10821_368621d1-1d16-402a-93e0-f1c9f0e146af.jpg?v=1692179491&width=1000'],
        description: 'Pure creatine for increased strength and performance.',
      ),
      ProductModel(
        id: '3',
        name: 'Pre-Workout',
        price: 34.99,
        imageUrl:
            ['https://wayupsports.com/cdn/shop/files/10843.jpg?v=1756650182&width=1000'],
        description: 'Boost energy and focus for your workouts.',
      ),
      ProductModel(
        id: '4',
        name: 'Creatine Powder',
        price:  1909,
        imageUrl:
            ['https://wayupsports.com/cdn/shop/files/ON_CREATINE_POWDER_300G_a0debbc6-79be-4e04-916e-6f82b813c4e6.jpg?v=1716891377&width=1000'],
        description: 'Boost energy and focus for your workouts.',
      ),
      ProductModel(
        id: '5',
        name: 'Clear Blue Shaker',
        price:  200,
        imageUrl:
            ['https://wayupsports.com/cdn/shop/files/6224009096169_max_muscle_7f8a569d-bed6-4563-8c06-e4528df1111b.jpg?v=1683722662&width=1000'],
        description: 'Boost energy and focus for your workouts.',
      ),
    ];

    return dummyProducts.firstWhereOrNull((product) => product.id == id);
  }
}

extension ListExtension<T> on List<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
}
