import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/features/home/data/datasources/home_local_data_source.dart';
import 'package:stronger_muscles/features/home/data/datasources/home_remote_datasource.dart';
import 'package:stronger_muscles/features/home/data/repositories/home_repository_impl.dart';
import 'package:stronger_muscles/features/home/domain/repositories/home_repository.dart';
import 'package:stronger_muscles/features/home/domain/usecases/get_home_products_usecase.dart';
import 'package:stronger_muscles/features/home/domain/usecases/get_home_shortcuts_usecase.dart';

// ── Data Layer Providers ─────────────────────────────────────────────────────

final homeLocalDataSourceProvider = Provider<HomeLocalDataSource>((ref) {
  return HomeLocalDataSourceImpl();
});

final homeRemoteDataSourceProvider = Provider<HomeRemoteDataSource>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return HomeRemoteDataSourceImpl(apiService);
});

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  final remote = ref.watch(homeRemoteDataSourceProvider);
  final local = ref.watch(homeLocalDataSourceProvider);
  return HomeRepositoryImpl(remote, local);
});

// ── Domain UseCase Providers ─────────────────────────────────────────────────

final getHomeShortcutsUseCaseProvider = Provider<GetHomeShortcutsUseCase>((ref) {
  final homeRepository = ref.watch(homeRepositoryProvider);
  return GetHomeShortcutsUseCase(homeRepository);
});

final getHomeProductsUseCaseProvider = Provider<GetHomeProductsUseCase>((ref) {
  final homeRepository = ref.watch(homeRepositoryProvider);
  return GetHomeProductsUseCase(homeRepository);
});
