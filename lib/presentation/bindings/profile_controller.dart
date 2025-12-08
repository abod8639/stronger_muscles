import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:stronger_muscles/data/models/order_model.dart';
import 'package:stronger_muscles/data/models/address_model.dart';
import 'package:stronger_muscles/presentation/bindings/auth_controller.dart';

class ProfileController extends GetxController {
  final AuthController _authController = Get.put(AuthController());
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
    await _loadAddresses();
    await _loadWishlistCount();
  }

  Future<void> _loadOrders() async {
    // Mock data for demonstration
    // In production, load from Firebase or API
    orders.value = [
      OrderModel(
        id: 'ORD001',
        orderDate: DateTime.now().subtract(const Duration(days: 2)),
        status: 'delivered',
        items: [
          OrderItem(
            productId: '1',
            productName: 'Whey Protein',
            price: 899.99,
            quantity: 2,
            imageUrl: 'https://images.unsplash.com/photo-1593095948071-474c5cc2989d',
          ),
        ],
        totalAmount: 1799.98,
        shippingAddress: 'Cairo, Egypt',
        trackingNumber: 'TRK123456',
      ),
      OrderModel(
        id: 'ORD002',
        orderDate: DateTime.now().subtract(const Duration(days: 7)),
        status: 'delivered',
        items: [
          OrderItem(
            productId: '2',
            productName: 'Creatine Monohydrate',
            price: 499.99,
            quantity: 1,
            imageUrl: 'https://images.unsplash.com/photo-1579722821273-0f6c7d44362f',
          ),
        ],
        totalAmount: 499.99,
        shippingAddress: 'Cairo, Egypt',
      ),
    ];
  }

  Future<void> _loadAddresses() async {
    // Mock data for demonstration
    addresses.value = [
      AddressModel(
        id: 'ADDR001',
        label: 'Home',
        fullName: currentUser.value?.displayName ?? 'User Name',
        phoneNumber: '+20 123 456 7890',
        street: '123 Main Street',
        city: 'Cairo',
        state: 'Cairo Governorate',
        postalCode: '11511',
        country: 'Egypt',
        isDefault: true,
        latitude: 30.0444,
        longitude: 31.2357,
      ),
    ];
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
