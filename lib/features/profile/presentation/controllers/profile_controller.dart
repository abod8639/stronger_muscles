import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/features/auth/auth_feature.dart';
import 'package:stronger_muscles/features/order/order_feature.dart';
import 'package:stronger_muscles/features/profile/domain/entities/address_entity.dart';
import 'package:stronger_muscles/features/profile/presentation/controllers/address_controller.dart';
import 'package:stronger_muscles/features/profile/profile_providers.dart';
import 'package:stronger_muscles/features/wishlist/wishlist_feature.dart';

part 'profile_controller.g.dart';

@riverpod
class ProfileController extends _$ProfileController {
  @override
  void build() {
    // Listen for auth changes to clear data on logout
    ref.listen(authControllerProvider, (previous, next) {
      if (next.value == null && !next.isLoading) {
        _clearData();
      }
    });
  }

  UserEntity? get currentUser => ref.watch(authControllerProvider).valueOrNull;
  bool get isLoading => ref.watch(authControllerProvider).isLoading;

  List<OrderEntity> get orders =>
      ref.watch(ordersControllerProvider).valueOrNull ?? [];
  List<AddressEntity> get addresses =>
      ref.watch(addressControllerProvider).valueOrNull ?? [];

  int get wishlistCount => ref.watch(wishlistControllerProvider).length;

  void _clearData() {
    ref.invalidate(ordersControllerProvider);
    ref.invalidate(addressControllerProvider);
    ref.read(addressLocalDataSourceProvider).clearAddresses();
  }

  Future<void> loadUserData() async {
    if (currentUser == null) return;

    await Future.wait([
      ref.read(ordersControllerProvider.notifier).refreshOrders(),
      ref.read(addressControllerProvider.notifier).fetchAddresses(),
    ]);
  }

  int get totalOrders => orders.length;
  double get totalSpent =>
      orders.fold(0.0, (sum, order) => sum + order.totalAmount);
  int get deliveredOrders =>
      orders.where((o) => o.status.toLowerCase() == 'delivered').length;

  Future<void> signOut() async {
    await ref.read(authControllerProvider.notifier).signOut();
    _clearData();
  }

  Future<void> signInWithGoogle() async {
    await ref.read(authControllerProvider.notifier).signInWithGoogle();
  }
}
