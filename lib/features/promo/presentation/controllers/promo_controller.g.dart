// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promo_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$promosHash() => r'228b99e76f5f5d412a04ab8c9b2ced0a46c8f85d';

/// See also [promos].
@ProviderFor(promos)
final promosProvider = AutoDisposeFutureProvider<List<PromoModel>>.internal(
  promos,
  name: r'promosProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$promosHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef PromosRef = AutoDisposeFutureProviderRef<List<PromoModel>>;
String _$promoControllerHash() => r'0a4e4aa6b486b5d027d9e68fcc67a32fc77dce66';

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
