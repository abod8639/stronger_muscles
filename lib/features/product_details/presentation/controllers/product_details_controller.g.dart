// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_details_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$productDetailsControllerHash() =>
    r'dd74347558f082924ce804d190871e8a32a7d67b';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$ProductDetailsController
    extends BuildlessAutoDisposeNotifier<ProductDetailsState> {
  late final ProductModel product;
  late final String? initialFlavor;
  late final String? initialSize;

  ProductDetailsState build(
    ProductModel product, {
    String? initialFlavor,
    String? initialSize,
  });
}

/// See also [ProductDetailsController].
@ProviderFor(ProductDetailsController)
const productDetailsControllerProvider = ProductDetailsControllerFamily();

/// See also [ProductDetailsController].
class ProductDetailsControllerFamily extends Family<ProductDetailsState> {
  /// See also [ProductDetailsController].
  const ProductDetailsControllerFamily();

  /// See also [ProductDetailsController].
  ProductDetailsControllerProvider call(
    ProductModel product, {
    String? initialFlavor,
    String? initialSize,
  }) {
    return ProductDetailsControllerProvider(
      product,
      initialFlavor: initialFlavor,
      initialSize: initialSize,
    );
  }

  @override
  ProductDetailsControllerProvider getProviderOverride(
    covariant ProductDetailsControllerProvider provider,
  ) {
    return call(
      provider.product,
      initialFlavor: provider.initialFlavor,
      initialSize: provider.initialSize,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'productDetailsControllerProvider';
}

/// See also [ProductDetailsController].
class ProductDetailsControllerProvider extends AutoDisposeNotifierProviderImpl<
    ProductDetailsController, ProductDetailsState> {
  /// See also [ProductDetailsController].
  ProductDetailsControllerProvider(
    ProductModel product, {
    String? initialFlavor,
    String? initialSize,
  }) : this._internal(
          () => ProductDetailsController()
            ..product = product
            ..initialFlavor = initialFlavor
            ..initialSize = initialSize,
          from: productDetailsControllerProvider,
          name: r'productDetailsControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$productDetailsControllerHash,
          dependencies: ProductDetailsControllerFamily._dependencies,
          allTransitiveDependencies:
              ProductDetailsControllerFamily._allTransitiveDependencies,
          product: product,
          initialFlavor: initialFlavor,
          initialSize: initialSize,
        );

  ProductDetailsControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.product,
    required this.initialFlavor,
    required this.initialSize,
  }) : super.internal();

  final ProductModel product;
  final String? initialFlavor;
  final String? initialSize;

  @override
  ProductDetailsState runNotifierBuild(
    covariant ProductDetailsController notifier,
  ) {
    return notifier.build(
      product,
      initialFlavor: initialFlavor,
      initialSize: initialSize,
    );
  }

  @override
  Override overrideWith(ProductDetailsController Function() create) {
    return ProviderOverride(
      origin: this,
      override: ProductDetailsControllerProvider._internal(
        () => create()
          ..product = product
          ..initialFlavor = initialFlavor
          ..initialSize = initialSize,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        product: product,
        initialFlavor: initialFlavor,
        initialSize: initialSize,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<ProductDetailsController,
      ProductDetailsState> createElement() {
    return _ProductDetailsControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProductDetailsControllerProvider &&
        other.product == product &&
        other.initialFlavor == initialFlavor &&
        other.initialSize == initialSize;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, product.hashCode);
    hash = _SystemHash.combine(hash, initialFlavor.hashCode);
    hash = _SystemHash.combine(hash, initialSize.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ProductDetailsControllerRef
    on AutoDisposeNotifierProviderRef<ProductDetailsState> {
  /// The parameter `product` of this provider.
  ProductModel get product;

  /// The parameter `initialFlavor` of this provider.
  String? get initialFlavor;

  /// The parameter `initialSize` of this provider.
  String? get initialSize;
}

class _ProductDetailsControllerProviderElement
    extends AutoDisposeNotifierProviderElement<ProductDetailsController,
        ProductDetailsState> with ProductDetailsControllerRef {
  _ProductDetailsControllerProviderElement(super.provider);

  @override
  ProductModel get product =>
      (origin as ProductDetailsControllerProvider).product;
  @override
  String? get initialFlavor =>
      (origin as ProductDetailsControllerProvider).initialFlavor;
  @override
  String? get initialSize =>
      (origin as ProductDetailsControllerProvider).initialSize;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
