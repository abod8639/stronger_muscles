import 'package:get/get.dart';
import 'package:stronger_muscles/data/models/order_model.dart';
import 'package:stronger_muscles/data/repositories/order_repository.dart';

class OrdersController extends GetxController {
  final OrderRepository _orderRepository = Get.find<OrderRepository>();

  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialOrders();
  }

  /// التهيئة الأولى (يمكنك إضافة منطق الكاش هنا أيضاً إذا كان الـ Repository يدعمه)
  Future<void> _loadInitialOrders() async {
    await fetchOrders();
  }

  /// جلب الطلبات من المستودع
  Future<void> fetchOrders() async {
    try {
      // إظهار التحميل فقط إذا كانت القائمة فارغة لتحسين تجربة المستخدم
      if (orders.isEmpty) isLoading.value = true;
      errorMessage.value = '';

      final fetchedOrders = await _orderRepository.getUserOrders();
      orders.assignAll(fetchedOrders);
      
    } catch (e) {
      errorMessage.value = _handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  /// تحديث الطلبات (مثلاً عند استخدام RefreshIndicator)
  Future<void> refreshOrders() async {
    await fetchOrders();
  }

  // --- Computed Properties (Getters) ---
  // ملاحظة: GetX سيقوم بتحديث الـ UI تلقائياً عند استخدام هذه الـ Getters داخل Obx
  
  List<OrderModel> get deliveredOrders => _filterByStatus('delivered');
  List<OrderModel> get pendingOrders => _filterByStatus('pending');
  List<OrderModel> get processingOrders => _filterByStatus('processing');
  List<OrderModel> get cancelledOrders => _filterByStatus('cancelled');

  // دالة مساعدة خاصة للفلترة لتقليل تكرار الكود (DRY)
  List<OrderModel> _filterByStatus(String status) {
    return orders.where((o) => o.status.toLowerCase() == status).toList();
  }

  /// تنظيف البيانات (عند تسجيل الخروج مثلاً)
  void clearData() {
    orders.clear();
    errorMessage.value = '';
    isLoading.value = false;
  }

  String _handleError(dynamic e) {
    print('❌ Error in OrdersController: $e');
    return e.toString().contains('network') 
        ? 'تأكد من اتصالك بالإنترنت' 
        : 'حدث خطأ أثناء تحميل الطلبات';
  }
}