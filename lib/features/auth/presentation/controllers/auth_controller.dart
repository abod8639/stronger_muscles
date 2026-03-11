import 'package:get/get.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/usecases/get_auths_usecase.dart';
import '../../domain/usecases/get_auth_by_id_usecase.dart';
import '../../domain/usecases/create_auth_usecase.dart';

class AuthController extends GetxController {
  final GetAuthsUsecase getAuthsUsecase;
  final GetAuthByIdUsecase getAuthByIdUsecase;
  final CreateAuthUsecase createAuthUsecase;

  AuthController({
    required this.getAuthsUsecase,
    required this.getAuthByIdUsecase,
    required this.createAuthUsecase,
  });

  final RxList<AuthEntity> items = <AuthEntity>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAll();
  }

  Future<void> fetchAll() async {
    isLoading.value = true;
    items.value = await getAuthsUsecase();
    isLoading.value = false;
  }
}
