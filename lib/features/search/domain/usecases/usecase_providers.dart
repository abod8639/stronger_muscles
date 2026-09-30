import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/features/search/data/repositories/search_repository_impl.dart';
import 'package:stronger_muscles/features/search/domain/repositories/search_repository.dart';
import 'package:stronger_muscles/features/search/domain/usecases/search_products_usecase.dart';
import 'package:stronger_muscles/features/search/domain/usecases/filter_by_price_usecase.dart';
import 'package:stronger_muscles/features/search/domain/usecases/calculate_price_bounds_usecase.dart';

part 'usecase_providers.g.dart';

@riverpod
SearchProductsUseCase searchProductsUseCase(SearchProductsUseCaseRef ref) {
  final SearchRepository repository = ref.watch(searchRepositoryProvider);
  return SearchProductsUseCase(repository);
}

@riverpod
FilterByPriceUseCase filterByPriceUseCase(FilterByPriceUseCaseRef ref) {
  final SearchRepository repository = ref.watch(searchRepositoryProvider);
  return FilterByPriceUseCase(repository);
}

@riverpod
CalculatePriceBoundsUseCase calculatePriceBoundsUseCase(
  CalculatePriceBoundsUseCaseRef ref,
) {
  final SearchRepository repository = ref.watch(searchRepositoryProvider);
  return CalculatePriceBoundsUseCase(repository);
}
