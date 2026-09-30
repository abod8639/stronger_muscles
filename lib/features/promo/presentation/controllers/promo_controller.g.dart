// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promo_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$promosHash() => r'06135c9bc704aa4172951c078dea4b037a1c1d2d';

/// See also [promos].
@ProviderFor(promos)
final promosProvider = AutoDisposeFutureProvider<List<PromoEntity>>.internal(
  promos,
  name: r'promosProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$promosHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PromosRef = AutoDisposeFutureProviderRef<List<PromoEntity>>;
String _$promoControllerHash() => r'6c6be6e5439d5200a38520476a67dba04fcff000';

/// See also [PromoController].
@ProviderFor(PromoController)
final promoControllerProvider =
    AutoDisposeNotifierProvider<PromoController, int>.internal(
  PromoController.new,
  name: r'promoControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$promoControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PromoController = AutoDisposeNotifier<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
