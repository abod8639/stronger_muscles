import 'package:get/get.dart';
import '../../data/datasources/profile_remote_datasource.dart';
import '../../data/datasources/profile_local_datasource.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/usecases/get_profiles_usecase.dart';
import '../../domain/usecases/get_profile_by_id_usecase.dart';
import '../../domain/usecases/create_profile_usecase.dart';
import 'profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileRemoteDatasource>(() => ProfileRemoteDatasourceImpl());
    Get.lazyPut<ProfileLocalDatasource>(() => ProfileLocalDatasourceImpl());
    Get.lazyPut(() => ProfileRepositoryImpl(
          remoteDatasource: Get.find(),
          localDatasource: Get.find(),
        ));
    Get.lazyPut(() => GetProfilesUsecase(Get.find()));
    Get.lazyPut(() => GetProfileByIdUsecase(Get.find()));
    Get.lazyPut(() => CreateProfileUsecase(Get.find()));
    Get.lazyPut(() => ProfileController(
          getProfilesUsecase: Get.find(),
          getProfileByIdUsecase: Get.find(),
          createProfileUsecase: Get.find(),
        ));
  }
}
