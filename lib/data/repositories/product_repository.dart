import '../../data/models/product_model.dart';
import '../../data/models/category_model.dart';
import 'package:collection/collection.dart';

class ProductRepository {
  // This is a dummy repository to simulate fetching product details.
  // In a real application, this would interact with a backend API or database.

  static const int delay = 100;

  Future<ProductModel?> getProductById(String id) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: delay));

    return dummyProducts.firstWhereOrNull((product) => product.id == id);
  }

  Future<List<ProductModel>> getAllProducts() async {
    await Future.delayed(const Duration(milliseconds: delay));
    return dummyProducts;
  }
  //   Future<List<ProductModel>> getAllProducts() async {
  //   final snapshot = await _firestore.collection('products').get();
  //   return snapshot.docs.map((doc) => ProductModel.fromJson(doc.data())).toList();
  // }

  Future<List<ProductModel>> getProductsByCategory(String categoryId) async {
    await Future.delayed(const Duration(milliseconds: delay));
    return dummyProducts.where((p) => p.categoryId == categoryId).toList();
  }
//   Future<List<ProductModel>> getProducts({int page = 1, int pageSize = 20}) async {
//   final query = _firestore.collection('products')
//     .limit(pageSize)
//     .startAfterDocument(lastDocument);
//   // ...
// }

  Future<List<ProductModel>> getProteinProducts() async {
    return getProductsByCategory('protein');
  }

  Future<List<ProductModel>> getCreatineProducts() async {
    return getProductsByCategory('creatine');
  }

  Future<List<ProductModel>> getAminoProducts() async {
    return getProductsByCategory('amino');
  }

  Future<List<ProductModel>> getBCAAProducts() async {
    return getProductsByCategory('bcaa');
  }

  Future<List<ProductModel>> getPreWorkoutProducts() async {
    return getProductsByCategory('preworkout');
  }

  Future<List<ProductModel>> getMassGainerProducts() async {
    return getProductsByCategory('massgainer');
  }

  Future<List<CategoryModel>> getAllCategories() async {
    await Future.delayed(const Duration(milliseconds: delay));
    return PredefinedCategories.categories;
  }

  Future<List<ProductModel>> searchProducts(String query) async {
    await Future.delayed(const Duration(milliseconds: delay));
    final lowerQuery = query.toLowerCase();
    return dummyProducts.where((p) {
      return p.name.toLowerCase().contains(lowerQuery) ||
          p.description.toLowerCase().contains(lowerQuery) ||
          (p.brand?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }

  Future<List<ProductModel>> getFeaturedProducts() async {
    await Future.delayed(const Duration(milliseconds: delay));
    // Return top rated products
    final sorted = [...dummyProducts];
    sorted.sort((a, b) => b.averageRating.compareTo(a.averageRating));
    return sorted.take(6).toList();
  }
}


// Dummy product data with new structure
final List<ProductModel> dummyProducts = [
  // Protein Products
  ProductModel(
    id: '1',
    name: 'Whey Protein',
    price: 59.99,
    imageUrls: [
      'https://wayupsports.com/cdn/shop/files/10843.jpg?v=1756650182&width=1000',
      'https://wayupsports.com/cdn/shop/files/10843_1.jpg?v=1756650182&width=1000',
      'https://wayupsports.com/cdn/shop/files/10843_2.jpg?v=1756650182&width=1000',
      'https://wayupsports.com/cdn/shop/files/10843_3.jpg?v=1756650182&width=1000',
    ],
    description: 'High-quality whey protein for muscle growth.',
    categoryId: 'protein',
    stockQuantity: 50,
    // averageRating: 4.8,
    reviewCount: 125,
    brand: 'Optimum Nutrition',
    servingSize: '30g',
    servingsPerContainer: 74,
  ),
  ProductModel(
    id: '2',
    name: 'Creatine Monohydrate',
    price: 29.99,
    imageUrls: [
      'https://wayupsports.com/cdn/shop/files/10821_368621d1-1d16-402a-93e0-f1c9f0e146af.jpg?v=1692179491&width=1000',
    ],
    description: 'Pure creatine for increased strength and performance.',
    categoryId: 'creatine',
    stockQuantity: 100,
    averageRating: 4.6,
    reviewCount: 89,
    brand: 'MuscleTech',
    servingSize: '5g',
    servingsPerContainer: 60,
  ),
  ProductModel(
    id: '3',
    name: 'Red Rex Beef Aminos 100Serv 300Coated Tablets',
    price: 1300.00,
    imageUrls: [
      'https://wayupsports.com/cdn/shop/files/6223007823098_max_muscle_5893ce62-7ced-41d1-a63f-368e0689ad66.jpg?v=1702980166&width=1000',
      'https://wayupsports.com/cdn/shop/files/6223007823098_max_muscle_1_13700fb8-56f6-4a0f-baca-6e8576dceef4.jpg?v=1702980196&width=1000',
      'https://wayupsports.com/cdn/shop/files/6223007823098_max_muscle_2_0aca455f-fecd-4d02-9bf8-4a66a8d876f7.jpg?v=1702980196&width=1000',
    ],
    description: 'Boost energy and focus for your workouts.',
    categoryId: 'amino',
    stockQuantity: 30,
    averageRating: 4.5,
    reviewCount: 45,
    brand: 'Max Muscle',
    servingSize: '3 tablets',
    servingsPerContainer: 100,
  ),
  ProductModel(
    id: '4',
    name: 'Creatine Powder',
    price: 1909,
    imageUrls: [
      'https://wayupsports.com/cdn/shop/files/ON_CREATINE_POWDER_300G_a0debbc6-79be-4e04-916e-6f82b813c4e6.jpg?v=1716891377&width=1000',
    ],
    description: 'Boost energy and focus for your workouts.',
    categoryId: 'creatine',
    stockQuantity: 45,
    averageRating: 4.7,
    reviewCount: 156,
    brand: 'Optimum Nutrition',
    servingSize: '5g',
    servingsPerContainer: 60,
  ),
  ProductModel(
    id: '5',
    name: 'Serious Mass',
    price: 4200,
    imageUrls: [
      'https://wayupsports.com/cdn/shop/files/ON_ASPAC_SERIOUS_MASS_STRAW_5.44KG_162fb477-102e-4204-9d69-3c272b80b295.jpg?v=1731850641&width=1000',
    ],
    description: 'Boost energy and focus for your workouts.',
    categoryId: 'massgainer',
    stockQuantity: 20,
    averageRating: 4.4,
    reviewCount: 78,
    brand: 'Optimum Nutrition',
    servingSize: '334g',
    servingsPerContainer: 16,
  ),
  ProductModel(
    id: '6',
    name: 'Bubble Gum Black Mirror Pre-Workout',
    price: 1100.00,
    imageUrls: [
      'https://wayupsports.com/cdn/shop/files/6223007821032_max_muscle_5a14b043-b0b7-4b7b-bd1b-72293c2d4c44.jpg?v=1683721697&width=800',
      'https://wayupsports.com/cdn/shop/files/6223007821032_max_muscle1_7551ddcf-61a2-46bd-b1c9-c302c99666b6.jpg?v=1683721704&width=600',
    ],
    description: 'Boost energy and focus for your workouts.',
    categoryId: 'preworkout',
    stockQuantity: 35,
    averageRating: 4.3,
    reviewCount: 67,
    brand: 'Max Muscle',
    servingSize: '10g',
    servingsPerContainer: 30,
  ),
  ProductModel(
    id: '7',
    name: 'Coffee Mocha Hazelnut Whey Protein Concentrate 30 Servings',
    price: 3400.00,
    imageUrls: [
      'https://wayupsports.com/cdn/shop/files/WhatsApp_Image_2023-09-07_at_11.01.29_AM_4dd2d908-3072-449c-95fb-ca5bc56d2d5c.jpg?v=1694076843&width=1000',
      'https://wayupsports.com/cdn/shop/files/whey_2_dbf46b5e-bcf9-4c67-819d-09768b02486e.jpg?v=1707033419&width=1000',
    ],
    description: 'Boost energy and focus for your workouts.',
    categoryId: 'protein',
    stockQuantity: 25,
    averageRating: 4.6,
    reviewCount: 92,
    brand: 'Local Brand',
    servingSize: '30g',
    servingsPerContainer: 30,
  ),
  ProductModel(
    id: '8',
    name: 'Cera Seeds Creatine Monohydrate 30 Serv 150G',
    price: 400.00,
    imageUrls: [
      'https://wayupsports.com/cdn/shop/files/7898588895560.jpg?v=1750146580&width=1000',
      'https://wayupsports.com/cdn/shop/files/7898588895560_1.jpg?v=1750146580&width=1000',
      'https://wayupsports.com/cdn/shop/files/7898588895560_2.jpg?v=1750146580&width=1000',
    ],
    description: 'Boost energy and focus for your workouts.',
    categoryId: 'creatine',
    stockQuantity: 60,
    averageRating: 4.2,
    reviewCount: 34,
    brand: 'Cera Seeds',
    servingSize: '5g',
    servingsPerContainer: 30,
  ),
  ProductModel(
    id: '9',
    name: 'Clear Blue Shaker',
    price: 200,
    imageUrls: [
      'https://wayupsports.com/cdn/shop/files/6224009096169_max_muscle_7f8a569d-bed6-4563-8c06-e4528df1111b.jpg?v=1683722662&width=1000',
    ],
    description: 'Boost energy and focus for your workouts.',
    categoryId: 'accessories',
    stockQuantity: 150,
    averageRating: 4.0,
    reviewCount: 23,
    brand: 'Max Muscle',
  ),
  ProductModel(
    id: '10',
    name: 'Whey Gold Standard 149 Servings 4.54 KG Double Rich Chocolate',
    price: 9499,
    imageUrls: [
      'https://wayupsports.com/cdn/shop/files/115013.jpg?v=1756891715&width=1000',
      'https://wayupsports.com/cdn/shop/files/115013_1.jpg?v=1756891715&width=1000',
    ],
    description: 'Boost energy and focus for your workouts.',
    categoryId: 'protein',
    stockQuantity: 15,
    averageRating: 4.9,
    reviewCount: 234,
    brand: 'Optimum Nutrition',
    servingSize: '30g',
    servingsPerContainer: 149,
  ),
  ProductModel(
    id: '11',
    name: 'Nutrex 100% Whey Protein Powder 10lbs – 128 Servings',
    price: 7700.00,
    imageUrls: [
      'https://wayupsports.com/cdn/shop/files/10849.jpg?v=1756654208&width=1000',
      'https://wayupsports.com/cdn/shop/files/10849_1.jpg?v=1756654208&width=1000',
    ],
    description: 'High-quality whey protein for muscle growth.',
    categoryId: 'protein',
    stockQuantity: 18,
    averageRating: 4.7,
    reviewCount: 112,
    brand: 'Nutrex',
    servingSize: '33g',
    servingsPerContainer: 128,
  ),
];
