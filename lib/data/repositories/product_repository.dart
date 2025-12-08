import 'package:stronger_muscles/data/models/product_model.dart';

class ProductRepository {
  // This is a dummy repository to simulate fetching product details.
  // In a real application, this would interact with a backend API or a local database.

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

  Future<List<ProductModel>> getProteinProducts() async {
    await Future.delayed(const Duration(milliseconds: delay));
    return dummyProteinProducts;
  }

  Future<List<ProductModel>> getCreatineProducts() async {
    await Future.delayed(const Duration(milliseconds: delay));
    return dummyCreatineProducts;
  }

  Future<List<ProductModel>> getAminoProducts() async {
    await Future.delayed(const Duration(milliseconds: delay));
    return dummyAminoProducts;
  }

  Future<List<ProductModel>> getBCAAProducts() async {
    await Future.delayed(const Duration(milliseconds: delay));
    return dummyBCAAProducts;
  }

  Future<List<ProductModel>> getPreWorkoutProducts() async {
    await Future.delayed(const Duration(milliseconds: delay));
    return dummyPreWorkoutProducts;
  }

  Future<List<ProductModel>> getMassGainerProducts() async {
    await Future.delayed(const Duration(milliseconds: delay));
    return dummyMassGainerProducts;
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

// Dummy product data
final List<ProductModel> dummyAminoProducts = [];
final List<ProductModel> dummyBCAAProducts = [];
final List<ProductModel> dummyPreWorkoutProducts = [];
final List<ProductModel> dummyMassGainerProducts = [];

final List<ProductModel> dummyProducts = [
// this for home 
  ProductModel(
    id: '1',
    name: 'Whey Protein',
    price: 59.99,
    imageUrl: [
      'https://wayupsports.com/cdn/shop/files/10843.jpg?v=1756650182&width=1000',
      'https://wayupsports.com/cdn/shop/files/10843_1.jpg?v=1756650182&width=1000',
      'https://wayupsports.com/cdn/shop/files/10843_2.jpg?v=1756650182&width=1000',
      'https://wayupsports.com/cdn/shop/files/10843_3.jpg?v=1756650182&width=1000',
    ],
    description: 'High-quality whey protein for muscle growth11.',
    strars: 4.5,
  ),
  ProductModel(
    id: '2',
    name: 'Creatine Monohydrate',
    price: 29.99,
    imageUrl: [
      'https://wayupsports.com/cdn/shop/files/10821_368621d1-1d16-402a-93e0-f1c9f0e146af.jpg?v=1692179491&width=1000',
    ],
    description: 'Pure creatine for increased strength and performance.',
  ),
  ProductModel(
    id: '3',
    name: 'Red Rex Beef Aminos 100Serv 300Coated Tablets',
    price: 1300.00,
    imageUrl: [
      'https://wayupsports.com/cdn/shop/files/6223007823098_max_muscle_5893ce62-7ced-41d1-a63f-368e0689ad66.jpg?v=1702980166&width=1000',
      'https://wayupsports.com/cdn/shop/files/6223007823098_max_muscle_1_13700fb8-56f6-4a0f-baca-6e8576dceef4.jpg?v=1702980196&width=1000',
      'https://wayupsports.com/cdn/shop/files/6223007823098_max_muscle_2_0aca455f-fecd-4d02-9bf8-4a66a8d876f7.jpg?v=1702980196&width=1000',
    ],
    description: 'Boost energy and focus for your workouts.',
  ),
  ProductModel(
    id: '4',
    name: 'Creatine Powder',
    price: 1909,
    imageUrl: [
      'https://wayupsports.com/cdn/shop/files/ON_CREATINE_POWDER_300G_a0debbc6-79be-4e04-916e-6f82b813c4e6.jpg?v=1716891377&width=1000',
    ],
    description: 'Boost energy and focus for your workouts.',
  ),
  ProductModel(
    id: '5',
    name: 'Serious Mass',
    price: 4209.00,
    imageUrl: [
      'https://wayupsports.com/cdn/shop/files/ON_ASPAC_SERIOUS_MASS_STRAW_5.44KG_162fb477-102e-4204-9d69-3c272b80b295.jpg?v=1731850641&width=1000',
    ],
    description: 'Boost energy and focus for your workouts.',
  ),
  ProductModel(
    id: '6',
    name: 'Bubble Gum Black Mirror Pre-Workout',
    price: 1100.00,
    imageUrl: [
      'https://wayupsports.com/cdn/shop/files/6223007821032_max_muscle_5a14b043-b0b7-4b7b-bd1b-72293c2d4c44.jpg?v=1683721697&width=800',
      'https://wayupsports.com/cdn/shop/files/6223007821032_max_muscle1_7551ddcf-61a2-46bd-b1c9-c302c99666b6.jpg?v=1683721704&width=600',
    ],
    description: 'Boost energy and focus for your workouts.',
  ),
  ProductModel(
    id: '7',
    name: 'Coffee Mocha Hazelnut Whey Protein Concentrate 30 Servings',
    price: 3400.00,
    imageUrl: [
      'https://wayupsports.com/cdn/shop/files/WhatsApp_Image_2023-09-07_at_11.01.29_AM_4dd2d908-3072-449c-95fb-ca5bc56d2d5c.jpg?v=1694076843&width=1000',
      'https://wayupsports.com/cdn/shop/files/Alpha_6771fb77-9250-46d4-b1ec-7635e23d06a3.jpg?v=1694077386&width=1000',
    ],
    description: 'Boost energy and focus for your workouts.',
  ),
  ProductModel(
    id: '8',
    name: 'Cera Seeds Creatine Monohydrate 30 Serv 150G',
    price: 400.00,
    imageUrl: [
      'https://wayupsports.com/cdn/shop/files/7898588895560.jpg?v=1750146580&width=1000',
      'https://wayupsports.com/cdn/shop/files/7898588895560_1.jpg?v=1750146580&width=1000'
          'https://wayupsports.com/cdn/shop/files/7898588895560_2.jpg?v=1750146580&width=1000',
    ],
    description: 'Boost energy and focus for your workouts.',
  ),
  ProductModel(
    id: '9',
    name: 'Clear Blue Shaker',
    price: 200,
    imageUrl: [
      'https://wayupsports.com/cdn/shop/files/6224009096169_max_muscle_7f8a569d-bed6-4563-8c06-e4528df1111b.jpg?v=1683722662&width=1000',
    ],
    description: 'Boost energy and focus for your workouts.',
  ),
  // ProductModel(
  //   id: '10',
  //   name: 'سوبيا',
  //   price: 67,
  //   imageUrl: [
  //     'https://mediaaws.almasryalyoum.com/news/large/2015/06/20/341071_0.jpeg',
  //   ],
  //   description: 'Boost energy and focus for your workouts.',
  // ),
  // ProductModel(
  //   id: '11',
  //   name: 'سحلب',
  //   price: 67,
  //   imageUrl: [
  //     'https://upload.wikimedia.org/wikipedia/ar/6/60/%D8%A7%D9%84%D8%B3%D8%AD%D9%84%D8%A8.JPG',
  //     'https://img-global.cpcdn.com/recipes/8d8a0c3084974b5d/680x781cq80/%D8%A7%D9%84%D8%B5%D9%88%D8%B1%D8%A9-%D8%A7%D9%84%D8%B1%D8%A6%D9%8A%D8%B3%D9%8A%D8%A9-%D9%84%D9%88%D8%B5%D9%81%D8%A9%D8%B3%D8%AD%D9%84%D8%A8-%D8%A8%D9%86%D8%B4%D8%A3-%D8%A7%D9%84%D8%B0%D8%B1%D9%87.jpg',
  //   ],
  //   description: 'Boost energy and focus for your workouts.',
  // ),
  // ProductModel(
  //   id: '12',
  //   name: 'اوباما',
  //   price: 6,
  //   imageUrl: [
  //     'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTbbqeHVl5dNrsH_cCVzp6XilhpyQv0oQDKflVfxNbEay47zGmDgJDbkj7nKCITlPRKBdg&usqp=CAU',
  //     'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR30QJ5X8wkjRafP8B00pMksMUN7tXhFVjgtBXeAEaR7xwjJOkw0ReyQLpRf9szQaSZwQw&usqp=CAU',
  //   ],
  //   description: 'Boost energy and focus for your workouts.',
  // ),
];

final List<ProductModel> dummyCreatineProducts = [
  ProductModel(
    id: '1',
    name: 'Cera Seeds Creatine Monohydrate 30 Serv 150G',
    price: 400.00,
    imageUrl: [
      'https://wayupsports.com/cdn/shop/files/7898588895560.jpg?v=1750146580&width=1000',
      'https://wayupsports.com/cdn/shop/files/7898588895560_1.jpg?v=1750146580&width=1000'
          'https://wayupsports.com/cdn/shop/files/7898588895560_2.jpg?v=1750146580&width=1000',
    ],
    description: 'Boost energy and focus for your workouts.',
  ),
  ProductModel(
    id: '2',
    name: 'Red Rex Beef Aminos 100Serv 300Coated Tablets',
    price: 1300.00,
    imageUrl: [
      'https://wayupsports.com/cdn/shop/files/6223007823098_max_muscle_5893ce62-7ced-41d1-a63f-368e0689ad66.jpg?v=1702980166&width=1000',
      'https://wayupsports.com/cdn/shop/files/6223007823098_max_muscle_1_13700fb8-56f6-4a0f-baca-6e8576dceef4.jpg?v=1702980196&width=1000',
      'https://wayupsports.com/cdn/shop/files/6223007823098_max_muscle_2_0aca455f-fecd-4d02-9bf8-4a66a8d876f7.jpg?v=1702980196&width=1000',
    ],
    description: 'Boost energy and focus for your workouts.',
  ),
  ProductModel(
    id: '3',
    name: 'Creatine Powder',
    price: 1909,
    imageUrl: [
      'https://wayupsports.com/cdn/shop/files/ON_CREATINE_POWDER_300G_a0debbc6-79be-4e04-916e-6f82b813c4e6.jpg?v=1716891377&width=1000',
    ],
    description: 'Boost energy and focus for your workouts.',
  ),
];

final List<ProductModel> dummyProteinProducts = [
  ProductModel(
    id: '1',
    name: 'Whey Gold Standard 149 Servings 4.54 KG Double Rich Chocolate',
    price: 9499.00,
    imageUrl: [
      'https://wayupsports.com/cdn/shop/files/115013.jpg?v=1756891715&width=1000',
      'https://wayupsports.com/cdn/shop/files/115013_1.jpg?v=1756891715&width=1000',
    ],
    description: 'Boost energy and focus for your workouts.',
  ),
  ProductModel(
    id: '2',
    name: 'Whey Protein',
    price: 59.99,
    imageUrl: [
      'https://wayupsports.com/cdn/shop/files/10843.jpg?v=1756650182&width=1000',
      'https://wayupsports.com/cdn/shop/files/10843_1.jpg?v=1756650182&width=1000',
      'https://wayupsports.com/cdn/shop/files/10843_2.jpg?v=1756650182&width=1000',
      'https://wayupsports.com/cdn/shop/files/10843_3.jpg?v=1756650182&width=1000',
    ],
    description: 'High-quality whey protein for muscle growth.',
  ),
  ProductModel(
    id: '3',
    name:
        'Nutrex 100% Whey Protein Powder 10lbs – 128 Servings - Muscle Growth - Recovery',
    price: 7700.00,
    imageUrl: [
      'https://wayupsports.com/cdn/shop/files/10849.jpg?v=1756654208&width=1000',
      'https://wayupsports.com/cdn/shop/files/10849_1.jpg?v=1756654208&width=1000',
    ],
    description: 'High-quality whey protein for muscle growth.',
  ),
];
