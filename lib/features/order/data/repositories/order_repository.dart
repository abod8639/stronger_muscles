import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/features/order/data/datasources/order_local_datasource.dart';
import 'package:stronger_muscles/features/order/data/datasources/order_remote_datasource.dart';
import 'package:stronger_muscles/features/order/data/repositories/order_repository_impl.dart';
import 'package:stronger_muscles/features/order/domain/repositories/order_repository.dart';

export 'package:stronger_muscles/features/order/domain/repositories/order_repository.dart';
export 'package:stronger_muscles/features/order/data/repositories/order_repository_impl.dart';
export 'package:stronger_muscles/features/order/data/datasources/order_remote_datasource.dart';
export 'package:stronger_muscles/features/order/data/datasources/order_local_datasource.dart';

final orderRemoteDataSourceProvider = Provider<OrderRemoteDatasource>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return OrderRemoteDatasourceImpl(apiService);
});

final orderLocalDataSourceProvider = Provider<OrderLocalDatasource>((ref) {
  return OrderLocalDatasourceImpl();
});

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final remote = ref.watch(orderRemoteDataSourceProvider);
  final local = ref.watch(orderLocalDataSourceProvider);
  return OrderRepositoryImpl(remote, local);
});
