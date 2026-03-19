// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$productRemoteDataSourceHash() =>
    r'1b27bdf00236645cf9861dd99b5b284ee1288228';

/// See also [productRemoteDataSource].
@ProviderFor(productRemoteDataSource)
final productRemoteDataSourceProvider =
    Provider<ProductRemoteDataSource>.internal(
  productRemoteDataSource,
  name: r'productRemoteDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$productRemoteDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ProductRemoteDataSourceRef = ProviderRef<ProductRemoteDataSource>;
String _$productLocalDataSourceHash() =>
    r'252e47d16fb4be6e7b76ce33e5dfecbb7a9924ce';

/// See also [productLocalDataSource].
@ProviderFor(productLocalDataSource)
final productLocalDataSourceProvider =
    Provider<ProductLocalDataSource>.internal(
  productLocalDataSource,
  name: r'productLocalDataSourceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$productLocalDataSourceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ProductLocalDataSourceRef = ProviderRef<ProductLocalDataSource>;
String _$productRepositoryHash() => r'2d15acfe0821245a7c477bd4d61a55753747a4a6';

/// See also [ProductRepository].
@ProviderFor(ProductRepository)
final productRepositoryProvider =
    NotifierProvider<ProductRepository, void>.internal(
  ProductRepository.new,
  name: r'productRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$productRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ProductRepository = Notifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
