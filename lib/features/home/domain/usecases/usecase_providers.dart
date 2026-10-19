import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/features/home/domain/usecases/get_home_products_usecase.dart';
import 'package:stronger_muscles/features/home/domain/usecases/get_home_shortcuts_usecase.dart';
import 'package:stronger_muscles/features/product/data/repositories/category_repository.dart';
import 'package:stronger_muscles/features/product/data/repositories/product_repository.dart';

final getHomeShortcutsUseCaseProvider = Provider<GetHomeShortcutsUseCase>((ref) {
  final categoryRepository = ref.watch(categoryRepositoryProvider);
  return GetHomeShortcutsUseCase(categoryRepository);
});

final getHomeProductsUseCaseProvider = Provider<GetHomeProductsUseCase>((ref) {
  final productRepository = ref.watch(productRepositoryProvider);
  return GetHomeProductsUseCase(productRepository);
});
