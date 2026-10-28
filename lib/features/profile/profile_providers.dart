import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/features/order/order_feature.dart';
import 'package:stronger_muscles/features/profile/data/datasources/address_local_datasource.dart';
import 'package:stronger_muscles/features/profile/data/datasources/address_remote_datasource.dart';
import 'package:stronger_muscles/features/profile/data/repositories/address_repository_impl.dart';
import 'package:stronger_muscles/features/profile/domain/repositories/address_repository.dart';
import 'package:stronger_muscles/features/profile/domain/usecases/delete_address_usecase.dart';
import 'package:stronger_muscles/features/profile/domain/usecases/get_addresses_usecase.dart';
import 'package:stronger_muscles/features/profile/domain/usecases/save_address_usecase.dart';
import 'package:stronger_muscles/features/profile/domain/usecases/set_default_address_usecase.dart';

// --- DataSources ---
final addressLocalDataSourceProvider = Provider<AddressLocalDataSource>((ref) {
  return AddressLocalDataSourceImpl();
});

final addressRemoteDataSourceProvider =
    Provider<AddressRemoteDataSource>((ref) {
  return AddressRemoteDataSourceImpl(ref.watch(apiServiceProvider));
});

// --- Repository (Single Source of Truth) ---
final profileAddressRepositoryProvider = Provider<AddressRepository>((ref) {
  return AddressRepositoryImpl(
    remoteDataSource: ref.watch(addressRemoteDataSourceProvider),
    localDataSource: ref.watch(addressLocalDataSourceProvider),
  );
});

// --- UseCases ---
final getAddressesUseCaseProvider = Provider<GetAddressesUseCase>((ref) {
  return GetAddressesUseCase(ref.watch(profileAddressRepositoryProvider));
});

final saveAddressUseCaseProvider = Provider<SaveAddressUseCase>((ref) {
  return SaveAddressUseCase(ref.watch(profileAddressRepositoryProvider));
});

final deleteAddressUseCaseProvider = Provider<DeleteAddressUseCase>((ref) {
  return DeleteAddressUseCase(ref.watch(profileAddressRepositoryProvider));
});

final setDefaultAddressUseCaseProvider =
    Provider<SetDefaultAddressUseCase>((ref) {
  return SetDefaultAddressUseCase(ref.watch(profileAddressRepositoryProvider));
});

// --- Aggregated Stats for Dumb UI (Rule 4) ---
class ProfileStats {
  final double totalSpent;
  final int deliveredOrders;

  const ProfileStats({
    required this.totalSpent,
    required this.deliveredOrders,
  });
}

final profileStatsProvider = Provider<ProfileStats>((ref) {
  final orders = ref.watch(ordersControllerProvider).valueOrNull ?? [];
  final totalSpent =
      orders.fold(0.0, (sum, order) => sum + order.totalAmount);
  final deliveredOrders =
      orders.where((o) => o.status.toLowerCase() == 'delivered').length;
  return ProfileStats(
    totalSpent: totalSpent,
    deliveredOrders: deliveredOrders,
  );
});
