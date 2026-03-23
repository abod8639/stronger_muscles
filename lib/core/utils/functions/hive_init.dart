import 'package:hive/hive.dart';
import 'package:stronger_muscles/features/profile/data/models/localized_string_model.dart';
import 'package:stronger_muscles/features/product/data/models/category_model.dart';
import 'package:stronger_muscles/features/product/data/models/image_url_model.dart';
import 'package:stronger_muscles/features/product/data/models/product_category_model.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/product/data/models/product_size_model.dart';
import 'package:stronger_muscles/features/cart/data/models/cart_item_model.dart';
import 'package:stronger_muscles/features/order/data/models/order_model.dart';
import 'package:stronger_muscles/features/profile/data/models/address_model.dart';
import 'package:stronger_muscles/features/profile/data/models/user_model.dart';

Future<void> hiveInit() async {
  // Register Adapters
  Hive.registerAdapter(CartItemModelAdapter());
  Hive.registerAdapter(OrderModelAdapter());
  Hive.registerAdapter(OrderItemModelAdapter());
  Hive.registerAdapter(AddressModelAdapter());
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(ProductModelAdapter());
  Hive.registerAdapter(CategoryModelAdapter());

  // Register new adapters for localized data
  Hive.registerAdapter(LocalizedStringAdapter());
  Hive.registerAdapter(ImageUrlAdapter());
  Hive.registerAdapter(ProductCategoryAdapter());
  Hive.registerAdapter(ProductSizeAdapter());

  // Open Boxes
  await Hive.openBox<CartItemModel>('cart');
  await Hive.openBox<String>('wishlist');
  await Hive.openBox<ProductModel>('products');
  await Hive.openBox<CategoryModel>('categories');
  await Hive.openBox<AddressModel>('addresses');
  await Hive.openBox<OrderModel>('orders');
  await Hive.openBox<UserModel>('users');
  await Hive.openBox('settings');
  await Hive.openBox('auth_box');
  await Hive.openBox<String>('search_history');
}
