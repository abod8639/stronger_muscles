import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/features/product/data/repositories/product_repository.dart';
import 'package:stronger_muscles/features/product/data/repositories/category_repository.dart';

part 'common_providers.g.dart';

@Riverpod(keepAlive: true)
ProductRepository productRepository(ProductRepositoryRef ref) {
  // بما أن ProductRepository هو Provider عادي وليس Notifier، نستخدم watch مباشرة
  return ref.watch(productRepositoryProvider);
}

@Riverpod(keepAlive: true)
CategoryRepository categoryRepository(CategoryRepositoryRef ref) {
  return ref.watch(categoryRepositoryProvider);
}
