import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/features/search/data/datasources/search_local_datasource.dart';
import 'package:stronger_muscles/features/search/data/datasources/search_remote_datasource.dart';
import 'package:stronger_muscles/features/search/data/repositories/search_repository_impl.dart';
import 'package:stronger_muscles/features/search/domain/repositories/search_repository.dart';
import 'package:stronger_muscles/features/search/domain/usecases/add_search_term_usecase.dart';
import 'package:stronger_muscles/features/search/domain/usecases/calculate_price_bounds_usecase.dart';
import 'package:stronger_muscles/features/search/domain/usecases/clear_search_history_usecase.dart';
import 'package:stronger_muscles/features/search/domain/usecases/filter_by_price_usecase.dart';
import 'package:stronger_muscles/features/search/domain/usecases/get_search_history_usecase.dart';
import 'package:stronger_muscles/features/search/domain/usecases/remove_search_term_usecase.dart';
import 'package:stronger_muscles/features/search/domain/usecases/search_products_usecase.dart';

// --- DataSources ---
final searchLocalDataSourceProvider = Provider<SearchLocalDataSource>((ref) {
  return SearchLocalDataSourceImpl();
});

final searchRemoteDataSourceProvider = Provider<SearchRemoteDataSource>((ref) {
  return SearchRemoteDataSourceImpl(ref.watch(apiServiceProvider));
});

// --- Repository (Single Source of Truth) ---
final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SearchRepositoryImpl(
    ref.watch(searchRemoteDataSourceProvider),
    ref.watch(searchLocalDataSourceProvider),
  );
});

// --- UseCases ---
final searchProductsUseCaseProvider = Provider<SearchProductsUseCase>((ref) {
  return SearchProductsUseCase(ref.watch(searchRepositoryProvider));
});

final filterByPriceUseCaseProvider = Provider<FilterByPriceUseCase>((ref) {
  return FilterByPriceUseCase(ref.watch(searchRepositoryProvider));
});

final calculatePriceBoundsUseCaseProvider =
    Provider<CalculatePriceBoundsUseCase>((ref) {
  return CalculatePriceBoundsUseCase(ref.watch(searchRepositoryProvider));
});

final getSearchHistoryUseCaseProvider =
    Provider<GetSearchHistoryUseCase>((ref) {
  return GetSearchHistoryUseCase(ref.watch(searchRepositoryProvider));
});

final addSearchTermUseCaseProvider = Provider<AddSearchTermUseCase>((ref) {
  return AddSearchTermUseCase(ref.watch(searchRepositoryProvider));
});

final removeSearchTermUseCaseProvider =
    Provider<RemoveSearchTermUseCase>((ref) {
  return RemoveSearchTermUseCase(ref.watch(searchRepositoryProvider));
});

final clearSearchHistoryUseCaseProvider =
    Provider<ClearSearchHistoryUseCase>((ref) {
  return ClearSearchHistoryUseCase(ref.watch(searchRepositoryProvider));
});
