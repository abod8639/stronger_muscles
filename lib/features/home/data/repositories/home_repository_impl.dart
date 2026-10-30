import 'dart:async';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/error/error.dart';
import 'package:stronger_muscles/features/home/data/datasources/home_local_data_source.dart';
import 'package:stronger_muscles/features/home/data/datasources/home_remote_datasource.dart';
import 'package:stronger_muscles/features/home/data/mappers/home_mapper.dart';
import 'package:stronger_muscles/features/home/domain/entities/selection_entity.dart';
import 'package:stronger_muscles/features/home/domain/repositories/home_repository.dart';
import 'package:stronger_muscles/features/product/product_feature.dart';

/// Concrete implementation of domain [HomeRepository].
/// Acts as the Single Source of Truth orchestrating [HomeRemoteDataSource]
/// and [HomeLocalDataSource] with offline-first caching and functional error handling.
class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;
  final HomeLocalDataSource _localDataSource;

  HomeRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
  );

  @override
  Future<Either<Failure, List<SelectionEntity>>> getHomeShortcuts({
    required String langCode,
  }) async {
    return NetworkErrorHandler.execute<List<SelectionEntity>>(() async {
      try {
        final remoteCategories = await _remoteDataSource.getCategories();

        if (remoteCategories.isNotEmpty) {
          unawaited(_localDataSource.cacheShortcuts(remoteCategories));

          return [
            const SelectionEntity(
              id: '',
              label: 'categoryHome',
              iconKey: 'home',
            ),
            ...remoteCategories.map((c) => c.toEntity()),
          ];
        }
      } on Failure catch (failure) {
        if (failure is CancelFailure) rethrow;

        final cached = await _localDataSource.getCachedShortcuts();
        if (cached.isNotEmpty) {
          return [
            const SelectionEntity(
              id: '',
              label: 'categoryHome',
              iconKey: 'home',
            ),
            ...cached.map((c) => c.toEntity()),
          ];
        }
        // Fallback to default shortcuts if cache is also unavailable
        return _localDataSource
            .getDefaultShortcuts(langCode)
            .map((c) => c.toEntity())
            .toList();
      } catch (_) {
        final cached = await _localDataSource.getCachedShortcuts();
        if (cached.isNotEmpty) {
          return [
            const SelectionEntity(
              id: '',
              label: 'categoryHome',
              iconKey: 'home',
            ),
            ...cached.map((c) => c.toEntity()),
          ];
        }
        return _localDataSource
            .getDefaultShortcuts(langCode)
            .map((c) => c.toEntity())
            .toList();
      }

      // Default predefined fallback if remote returns empty
      return _localDataSource
          .getDefaultShortcuts(langCode)
          .map((c) => c.toEntity())
          .toList();
    });
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getHomeProducts({
    String? categoryId,
    int page = 1,
  }) async {
    return NetworkErrorHandler.execute<List<ProductEntity>>(() async {
      // Offline-first: return cache immediately for page-1 to avoid loading flash
      if (page == 1) {
        final cached = await _localDataSource.getCachedProducts(
          categoryId: categoryId,
        );
        if (cached.isNotEmpty) {
          // Kick off a background refresh so the UI stays fresh without blocking
          Future.microtask(() async {
            try {
              final fresh = await _remoteDataSource.getProducts(
                categoryId: categoryId,
                page: 1,
              );
              if (fresh.isNotEmpty &&
                  (categoryId == null || categoryId.isEmpty)) {
                unawaited(_localDataSource.cacheProducts(fresh));
              }
            } catch (_) {}
          });
          return cached.map((p) => p.toEntity()).toList();
        }
      }

      try {
        final remoteProducts = await _remoteDataSource.getProducts(
          categoryId: categoryId,
          page: page,
        );

        if (remoteProducts.isNotEmpty &&
            (categoryId == null || categoryId.isEmpty) &&
            page == 1) {
          unawaited(_localDataSource.cacheProducts(remoteProducts));
        }

        return remoteProducts.map((p) => p.toEntity()).toList();
      } on Failure catch (failure) {
        if (failure is CancelFailure) rethrow;

        // On network failure, fallback gracefully to cached products
        final cached = await _localDataSource.getCachedProducts(
          categoryId: categoryId,
        );
        if (cached.isNotEmpty) {
          return cached.map((p) => p.toEntity()).toList();
        }
        rethrow;
      }
    });
  }
}
