// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$orderRepositoryHash() => r'8ce64da2f2285c847db33d0e2b82fece41b13ed8';

/// See also [orderRepository].
@ProviderFor(orderRepository)
final orderRepositoryProvider = Provider<OrderRepository>.internal(
  orderRepository,
  name: r'orderRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$orderRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef OrderRepositoryRef = ProviderRef<OrderRepository>;
String _$ordersControllerHash() => r'd7af20133c1ffec541b5427e78da9b7187006002';

/// See also [OrdersController].
@ProviderFor(OrdersController)
final ordersControllerProvider =
    AsyncNotifierProvider<OrdersController, List<OrderModel>>.internal(
  OrdersController.new,
  name: r'ordersControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$ordersControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$OrdersController = AsyncNotifier<List<OrderModel>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
