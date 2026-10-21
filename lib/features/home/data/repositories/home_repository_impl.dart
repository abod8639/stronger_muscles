import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/error/error.dart';
import 'package:stronger_muscles/features/home/data/datasources/home_remote_datasource.dart';
import 'package:stronger_muscles/features/home/data/models/selection_model.dart';
import 'package:stronger_muscles/features/home/domain/repositories/home_repository.dart';
import 'package:stronger_muscles/features/product/data/datasources/category_local_datasource.dart';
import 'package:stronger_muscles/features/product/data/datasources/product_local_datasource.dart';
import 'package:stronger_muscles/features/product/data/models/category_model.dart';
import 'package:stronger_muscles/features/product/domain/entities/product_entity.dart';

/// Concrete implementation of domain [HomeRepository].
/// Executes operations wrapped inside [NetworkErrorHandler.execute] returning [Either<Failure, T>].
/// Features offline cache fallback and background isolate processing.
class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource _remoteDataSource;
  final CategoryLocalDataSource? _categoryLocalDataSource;
  final ProductLocalDataSource? _productLocalDataSource;

  HomeRepositoryImpl(
    this._remoteDataSource, [
    this._categoryLocalDataSource,
    this._productLocalDataSource,
  ]);

  @override
  Future<Either<Failure, List<SelectionEntity>>> getHomeShortcuts({
    required String langCode,
    CancelToken? cancelToken,
  }) async {
    return NetworkErrorHandler.execute<List<SelectionEntity>>(() async {
      try {
        final remoteCategories = await _remoteDataSource.getCategories(
          cancelToken: cancelToken,
        );

        if (remoteCategories.isNotEmpty) {
          return [
            const SelectionEntity(
              id: '',
              label: 'categoryHome',
              icon: Icons.home,
            ),
            ...remoteCategories.map((c) => c.toEntity()),
          ];
        }
      } on Failure catch (failure) {
        if (failure is CancelFailure) rethrow;

        final cached = _categoryLocalDataSource?.getCachedCategories();
        if (cached != null && cached.isNotEmpty) {
          return _buildShortcutsFromCategories(cached, langCode);
        }
        rethrow;
      } catch (_) {
        final cached = _categoryLocalDataSource?.getCachedCategories();
        if (cached != null && cached.isNotEmpty) {
          return _buildShortcutsFromCategories(cached, langCode);
        }
        rethrow;
      }

      // Predefined fallbacks if no remote categories and empty cache
      return _buildShortcutsFromCategories(
        PredefinedCategories.categories,
        langCode,
      );
    });
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getHomeProducts({
    String? categoryId,
    int page = 1,
    CancelToken? cancelToken,
  }) async {
    return NetworkErrorHandler.execute<List<ProductEntity>>(() async {
      // Offline-first strategy: Return cache on initial load if available
      if ((categoryId == null || categoryId.isEmpty) && page == 1) {
        final cached = _productLocalDataSource?.getCachedProducts();
        if (cached != null && cached.isNotEmpty) {
          return cached.map((p) => p.toEntity()).toList();
        }
      }

      try {
        final remoteProducts = await _remoteDataSource.getProducts(
          categoryId: categoryId,
          page: page,
          cancelToken: cancelToken,
        );

        if (remoteProducts.isNotEmpty && _productLocalDataSource != null) {
          unawaited(_productLocalDataSource.cacheProducts(remoteProducts));
        }

        return remoteProducts.map((p) => p.toEntity()).toList();
      } on Failure catch (failure) {
        if (failure is CancelFailure) rethrow;

        // On network failure, fallback gracefully to cached products
        final cached = _productLocalDataSource?.getCachedProducts();
        if (cached != null && cached.isNotEmpty) {
          final filtered = (categoryId != null && categoryId.isNotEmpty)
              ? cached.where((p) => p.categoryId == categoryId).toList()
              : cached;
          if (filtered.isNotEmpty) {
            return filtered.map((p) => p.toEntity()).toList();
          }
        }
        rethrow;
      }
    });
  }

  List<SelectionEntity> _buildShortcutsFromCategories(
    List<CategoryModel> categories,
    String langCode,
  ) {
    return [
      const SelectionEntity(
        id: '',
        label: 'categoryHome',
        icon: Icons.home,
      ),
      ...categories.map(
        (cat) => SelectionEntity(
          id: cat.id,
          label: cat.getLocalizedName(locale: langCode),
          icon: SelectionsModel.resolveIcon(cat.id),
        ),
      ),
    ];
  }
}
