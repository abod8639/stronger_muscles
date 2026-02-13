import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/data/models/user_model.dart';
import 'package:stronger_muscles/data/models/address_model.dart';
import 'package:stronger_muscles/data/models/order_model.dart';
import 'package:stronger_muscles/presentation/controllers/address_controller.dart';
import 'package:stronger_muscles/presentation/controllers/auth_controller.dart';
import 'package:stronger_muscles/presentation/controllers/orders_controller.dart';

class ProfileController extends GetxController {
  final AuthController _authController = Get.find<AuthController>();
  final OrdersController _ordersController = Get.find<OrdersController>();
  final AddressController _addressController = Get.find<AddressController>();

  RxList<OrderModel> get orders => _ordersController.orders;
  RxList<AddressModel> get addresses => _addressController.addresses;

  final RxInt wishlistCount = 0.obs;

  RxBool get isLoading => _authController.isLoading;
  Rx<UserModel?> get currentUser => _authController.currentUser;

  @override
  void onInit() {
    super.onInit();

    // Load initial data if logged in
    if (_authController.currentUser.value != null) {
      _loadUserData();
    }

    // Listen for future changes
    ever(_authController.currentUser, (UserModel? user) {
      if (user != null) {
        // Only load if data is empty to avoid redundant switches
        if (addresses.isEmpty) {
          _loadUserData();
        }
      } else {
        _clearData();
      }
    });
  }

  void _clearData() {
    _ordersController.clearData();
    _addressController.addresses.clear();
    wishlistCount.value = 0;
  }

  Future<void> _loadUserData() async {
    await Future.wait([
      _ordersController.fetchOrders(),
      _addressController.fetchAddresses(),
      _loadWishlistCount(),
    ]);
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
