import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/features/order/data/datasources/order_local_datasource.dart';
import 'package:stronger_muscles/features/order/data/datasources/order_remote_datasource.dart';
import 'package:stronger_muscles/features/order/data/repositories/order_repository_impl.dart';
import 'package:stronger_muscles/features/order/domain/repositories/order_repository.dart';
import 'package:stronger_muscles/features/order/domain/usecases/cancel_order_usecase.dart';
import 'package:stronger_muscles/features/order/domain/usecases/create_order_usecase.dart';
import 'package:stronger_muscles/features/order/domain/usecases/get_order_by_id_usecase.dart';
import 'package:stronger_muscles/features/order/domain/usecases/get_user_orders_usecase.dart';

// ── Data Layer Providers ─────────────────────────────────────────────────────

final orderLocalDataSourceProvider = Provider<OrderLocalDatasource>((ref) {
  return OrderLocalDatasourceImpl();
});

final orderRemoteDataSourceProvider = Provider<OrderRemoteDatasource>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return OrderRemoteDatasourceImpl(apiService);
});

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final remote = ref.watch(orderRemoteDataSourceProvider);
  final local = ref.watch(orderLocalDataSourceProvider);
  return OrderRepositoryImpl(remote, local);
});

// ── Domain UseCase Providers ─────────────────────────────────────────────────

final getUserOrdersUseCaseProvider = Provider<GetUserOrdersUseCase>((ref) {
  final repository = ref.watch(orderRepositoryProvider);
  return GetUserOrdersUseCase(repository);
});

final getOrderByIdUseCaseProvider = Provider<GetOrderByIdUseCase>((ref) {
  final repository = ref.watch(orderRepositoryProvider);
  return GetOrderByIdUseCase(repository);
});

final createOrderUseCaseProvider = Provider<CreateOrderUseCase>((ref) {
  final repository = ref.watch(orderRepositoryProvider);
  return CreateOrderUseCase(repository);
});

final cancelOrderUseCaseProvider = Provider<CancelOrderUseCase>((ref) {
  final repository = ref.watch(orderRepositoryProvider);
  return CancelOrderUseCase(repository);
});
