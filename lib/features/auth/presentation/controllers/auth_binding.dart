import 'package:get/get.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/get_auths_usecase.dart';
import '../../domain/usecases/get_auth_by_id_usecase.dart';
import '../../domain/usecases/create_auth_usecase.dart';
import 'auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRemoteDatasource>(() => AuthRemoteDatasourceImpl());
    Get.lazyPut<AuthLocalDatasource>(() => AuthLocalDatasourceImpl());
    Get.lazyPut(() => AuthRepositoryImpl(
          remoteDatasource: Get.find(),
          localDatasource: Get.find(),
        ));
    Get.lazyPut(() => GetAuthsUsecase(Get.find()));
    Get.lazyPut(() => GetAuthByIdUsecase(Get.find()));
    Get.lazyPut(() => CreateAuthUsecase(Get.find()));
    Get.lazyPut(() => AuthController(
          getAuthsUsecase: Get.find(),
          getAuthByIdUsecase: Get.find(),
          createAuthUsecase: Get.find(),
        ));
  }
}
