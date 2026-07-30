import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stronger_muscles/features/auth/domain/usecases/usecase_providers.dart';
import 'package:stronger_muscles/features/profile/data/models/user_model.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<UserModel?> build() async {
    final getCurrentUser = ref.read(getCurrentUserUseCaseProvider);
    return await getCurrentUser();
  }

  UserModel? get currentUser => state.value;
  bool get isLoggedIn => state.value != null;
  bool get isLoading => state.isLoading;

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final login = ref.read(loginUseCaseProvider);
      return await login(email: email, password: password);
    });
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    String? name,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final register = ref.read(registerUseCaseProvider);
      return await register(email: email, password: password, name: name ?? "");
    });
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final googleSignIn = GoogleSignIn.instance;
      try {
        await googleSignIn.initialize();
      } catch (_) {
        // Safe to ignore if already initialized
      }
      
      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

      final googleAuthUseCase = ref.read(googleSignInUseCaseProvider);
      return await googleAuthUseCase(
        email: googleUser.email,
        name: googleUser.displayName ?? '',
        photoUrl: googleUser.photoUrl,
      );
    });
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final logout = ref.read(logoutUseCaseProvider);
      await logout();
      return null;
    });
  }

  Future<void> updateUserProfile({
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
  }) async {
    if (state.value == null) return;

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final updateProfile = ref.read(updateProfileUseCaseProvider);
      return await updateProfile(
        name: name,
        email: email,
        phone: phone,
        photoUrl: photoUrl,
      );
    });
  }
}
