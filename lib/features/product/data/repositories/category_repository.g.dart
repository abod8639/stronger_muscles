// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$categoryRemoteDataSourceHash() =>
    r'bdfd45d4befe0d83eb0052ee1e94bb7f9a572467';

/// See also [categoryRemoteDataSource].
@ProviderFor(categoryRemoteDataSource)
final categoryRemoteDataSourceProvider =
    Provider<CategoryRemoteDataSource>.internal(
      categoryRemoteDataSource,
      name: r'categoryRemoteDataSourceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$categoryRemoteDataSourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef CategoryRemoteDataSourceRef = ProviderRef<CategoryRemoteDataSource>;
String _$categoryLocalDataSourceHash() =>
    r'98b6218b7ff4243be5a9de997f4eb82b5936f113';

/// See also [categoryLocalDataSource].
@ProviderFor(categoryLocalDataSource)
final categoryLocalDataSourceProvider =
    Provider<CategoryLocalDataSource>.internal(
      categoryLocalDataSource,
      name: r'categoryLocalDataSourceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$categoryLocalDataSourceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef CategoryLocalDataSourceRef = ProviderRef<CategoryLocalDataSource>;
String _$categoryRepositoryHash() =>
    r'41393b28b85e5532fec72755a4c960424134c189';

/// See also [CategoryRepository].
@ProviderFor(CategoryRepository)
final categoryRepositoryProvider =
    NotifierProvider<CategoryRepository, void>.internal(
      CategoryRepository.new,
      name: r'categoryRepositoryProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$categoryRepositoryHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CategoryRepository = Notifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
