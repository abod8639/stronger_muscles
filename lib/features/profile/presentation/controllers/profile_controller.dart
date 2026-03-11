import 'package:get/get.dart';
import '../../domain/entities/profile_entity.dart';
import '../../domain/usecases/get_profiles_usecase.dart';
import '../../domain/usecases/get_profile_by_id_usecase.dart';
import '../../domain/usecases/create_profile_usecase.dart';

class ProfileController extends GetxController {
  final GetProfilesUsecase getProfilesUsecase;
  final GetProfileByIdUsecase getProfileByIdUsecase;
  final CreateProfileUsecase createProfileUsecase;

  ProfileController({
    required this.getProfilesUsecase,
    required this.getProfileByIdUsecase,
    required this.createProfileUsecase,
  });

  final RxList<ProfileEntity> items = <ProfileEntity>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAll();
  }

  Future<void> fetchAll() async {
    isLoading.value = true;
    items.value = await getProfilesUsecase();
    isLoading.value = false;
  }
}
