import 'package:get/get.dart';
import '../../core/services/auth_service.dart';
import '../../data/models/user_stats_model.dart';

class DashboardController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final Rx<UsersStatsResponse?> usersStats = Rx<UsersStatsResponse?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsersStats();
  }

  // جلب بيانات إحصائيات المستخدمين من قاعدة البيانات
  Future<void> fetchUsersStats() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _authService.getUsersStats();
      usersStats.value = response;

      print('✅ تم جلب بيانات المستخدمين: ${response.totalUsers} مستخدم');
    } catch (e) {
      errorMessage.value = e.toString();
      print('❌ خطأ في جلب بيانات المستخدمين: $e');
      Get.snackbar('خطأ', 'فشل تحميل بيانات المستخدمين');
    } finally {
      isLoading.value = false;
    }
  }

  // الحصول على عدد المستخدمين الكلي
  int getTotalUsers() => usersStats.value?.totalUsers ?? 0;

  // الحصول على قائمة المستخدمين
  List<UserStats> getUsers() => usersStats.value?.users ?? [];

  // الحصول على عدد المستخدمين الذين لديهم طلبات
  int getUsersWithOrders() {
    final users = getUsers();
    return users.where((user) => user.hasOrdered).length;
  }

  // الحصول على إجمالي عدد الطلبات
  int getTotalOrders() {
    final users = getUsers();
    return users.fold<int>(0, (sum, user) => sum + user.ordersCount);
  }
}
