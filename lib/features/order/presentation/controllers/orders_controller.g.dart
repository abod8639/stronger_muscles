// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$orderRepositoryHash() => r'2f6367b235d318e3d201f36fdb406941e2b0053a';

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
String _$ordersControllerHash() => r'62da876220e04d916c8082610645cb249a792702';

/// See also [OrdersController].
@ProviderFor(OrdersController)
final ordersControllerProvider =
    AsyncNotifierProvider<OrdersController, List<OrderEntity>>.internal(
  OrdersController.new,
  name: r'ordersControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$ordersControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$OrdersController = AsyncNotifier<List<OrderEntity>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
