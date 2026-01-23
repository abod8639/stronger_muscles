import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/data/models/address_model.dart';
import 'package:stronger_muscles/data/models/order_model.dart';
import 'package:stronger_muscles/data/repositories/order_repository.dart';
import 'package:stronger_muscles/core/services/address_service.dart';
import 'package:stronger_muscles/presentation/bindings/auth_controller.dart';

class ProfileController extends GetxController {
  final AuthController _authController =Get.put(AuthController());
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final OrderRepository _orderRepository = OrderRepository();
  final AddressService _addressService = Get.put(AddressService());

  final Rx<User?> currentUser = Rx<User?>(null);
  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxList<AddressModel> addresses = <AddressModel>[].obs;
  final RxInt wishlistCount = 0.obs;
  
  // Expose isLoading from AuthController
  RxBool get isLoading => _authController.isLoading;

  @override
  void onInit() {
    super.onInit();
    currentUser.value = _auth.currentUser;
    _auth.authStateChanges().listen((event) {
      currentUser.value = event;
      if (event != null) {
        _loadUserData();
      }
    });
    if (currentUser.value != null) {
      _loadUserData();
    }
  }

  Future<void> _loadUserData() async {
    await _loadOrders();
    await loadAddresses();
    await _loadWishlistCount();
  }

  Future<void> _loadOrders() async {
    try {
      final fetchedOrders = await _orderRepository.getUserOrders();
      orders.assignAll(fetchedOrders);
      print('✅ Profile: Loaded ${orders.length} orders');
    } catch (e) {
      print('❌ Profile: Error loading orders: $e');
    }
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
  int get totalOrders => orders.length;
  double get totalSpent => orders.fold(0, (sum, order) => sum + order.totalAmount);
  int get deliveredOrders => orders.where((o) => o.status == 'delivered').length;

  Future<void> signOut() async {
    await _authController.signOut();
    orders.clear();
    addresses.clear();
    wishlistCount.value = 0;
  }

  Future<void> signInWithGoogle() async {
    await _authController.signInWithGoogle();
  }
}
