import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/features/order/data/repositories/order_repository_impl.dart';
import 'package:stronger_muscles/features/order/domain/repositories/order_repository.dart';

export 'package:stronger_muscles/features/order/domain/repositories/order_repository.dart';
export 'package:stronger_muscles/features/order/data/repositories/order_repository_impl.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return OrderRepositoryImpl(apiService);
});
