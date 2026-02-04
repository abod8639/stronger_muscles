import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/data/models/user_model.dart';
import 'package:stronger_muscles/data/models/address_model.dart';
import 'package:stronger_muscles/data/models/order_model.dart';
import 'package:stronger_muscles/core/services/address_service.dart';
import 'package:stronger_muscles/presentation/controllers/auth_controller.dart';
import 'package:stronger_muscles/presentation/controllers/orders_controller.dart';

class ProfileController extends GetxController {
  final AuthController _authController =     Get.find<AuthController>();
  final AddressService _addressService =     Get.find<AddressService>();
  final OrdersController _ordersController = Get.find<OrdersController>();

  RxList<OrderModel> get orders => _ordersController.orders;

  final RxList<AddressModel> addresses = <AddressModel>[].obs;
  final RxInt wishlistCount = 0.obs;

  RxBool get isLoading => _authController.isLoading;
  Rx<UserModel?> get currentUser => _authController.currentUser;

  @override
  void onInit() {
    super.onInit();

    ever(_authController.currentUser, (UserModel? user) {
      if (user != null) {
        _loadUserData();
      } else {
        _clearData();
      }
    });

    // Initial load if user is already logged in
    if (_authController.currentUser.value != null) {
      _loadUserData();
    }
  }

  void _clearData() {
    _ordersController.clearData();
    addresses.clear();
    wishlistCount.value = 0;
  }

  Future<void> _loadUserData() async {
    await _ordersController.fetchOrders();
    await loadAddresses();
    await _loadWishlistCount();
  }

  Future<void> loadAddresses() async {
    try {
      final fetchedAddresses = await _addressService.getAddresses();
      addresses.assignAll(fetchedAddresses);
      print('✅ Profile: Loaded ${addresses.length} addresses');
    } catch (e) {
      print('❌ Profile: Error loading addresses: $e');
    }
  }

  Future<void> _loadWishlistCount() async {
    try {
      if (Hive.isBoxOpen('wishlist')) {
        final wishlistBox = Hive.box<String>('wishlist');
        wishlistCount.value = wishlistBox.length;
      }
    } catch (e) {
      wishlistCount.value = 0;
    }
  }

  // Statistics
  int get totalOrders => _ordersController.orders.length;
  double get totalSpent =>
      _ordersController.orders.fold(0, (sum, order) => sum + order.totalAmount);
  int get deliveredOrders => _ordersController.deliveredOrders.length;

  Future<void> signOut() async {
    await _authController.signOut();
    _clearData();
  }

  Future<void> signInWithGoogle() async {
    await _authController.signInWithGoogle();
  }
}
