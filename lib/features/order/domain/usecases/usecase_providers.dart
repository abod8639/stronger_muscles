import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/features/order/data/repositories/order_repository.dart';
import 'package:stronger_muscles/features/order/domain/usecases/create_order_usecase.dart';
import 'package:stronger_muscles/features/order/domain/usecases/get_user_orders_usecase.dart';

part 'usecase_providers.g.dart';

@riverpod
GetUserOrdersUseCase getUserOrdersUseCase(GetUserOrdersUseCaseRef ref) {
  return GetUserOrdersUseCase(ref.watch(orderRepositoryProvider));
}

@riverpod
CreateOrderUseCase createOrderUseCase(CreateOrderUseCaseRef ref) {
  return CreateOrderUseCase(ref.watch(orderRepositoryProvider));
}
