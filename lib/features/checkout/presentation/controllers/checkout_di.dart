import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/api_service.dart';
import '../../data/datasources/checkout_local_data_source.dart';
import '../../data/datasources/checkout_remote_data_source.dart';
import '../../data/repositories/checkout_repository_impl.dart';
import '../../domain/repositories/checkout_repository.dart';
import '../../domain/usecases/place_order_usecase.dart';

final checkoutLocalDataSourceProvider =
    Provider<CheckoutLocalDataSource>((ref) {
  return CheckoutLocalDataSourceImpl();
});

final checkoutRemoteDataSourceProvider =
    Provider<CheckoutRemoteDataSource>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return CheckoutRemoteDataSourceImpl(apiService);
});

final checkoutRepositoryProvider = Provider<CheckoutRepository>((ref) {
  final localDataSource = ref.watch(checkoutLocalDataSourceProvider);
  final remoteDataSource = ref.watch(checkoutRemoteDataSourceProvider);

  return CheckoutRepositoryImpl(
    localDataSource: localDataSource,
    remoteDataSource: remoteDataSource,
  );
});

final placeOrderUseCaseProvider = Provider<PlaceOrderUseCase>((ref) {
  final repository = ref.watch(checkoutRepositoryProvider);
  return PlaceOrderUseCase(repository);
});
