import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/core/auth/auth_state_provider.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/core/services/push_notification_service.dart';
import 'package:stronger_muscles/features/auth/domain/entities/user_entity.dart';
import 'package:stronger_muscles/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:stronger_muscles/features/auth/domain/usecases/google_sign_in_usecase.dart';
import 'package:stronger_muscles/features/auth/domain/usecases/login_usecase.dart';
import 'package:stronger_muscles/features/auth/domain/usecases/logout_usecase.dart';
import 'package:stronger_muscles/features/auth/domain/usecases/register_usecase.dart';
import 'package:stronger_muscles/features/auth/domain/usecases/update_profile_usecase.dart';
import 'package:stronger_muscles/features/auth/presentation/controllers/auth_di.dart';

part 'auth_controller.g.dart';

/// Presentation state controller managing user authentication lifecycle.
///
/// Strictly enforces:
/// - Immutable states through [AsyncValue].
/// - Zero try-catch blocks: purely functional error handling with [Either.fold].
/// - Pure constructor / provider dependency injection: zero hidden singletons.
@riverpod
class AuthController extends _$AuthController {
  LoginUseCase? _loginUseCaseOverride;
  RegisterUseCase? _registerUseCaseOverride;
  LogoutUseCase? _logoutUseCaseOverride;
  GetCurrentUserUseCase? _getCurrentUserUseCaseOverride;
  GoogleSignInUseCase? _googleSignInUseCaseOverride;
  UpdateProfileUseCase? _updateProfileUseCaseOverride;
  PushNotificationService? _pushNotificationServiceOverride;

  /// Default constructor for Riverpod and production runtime.
  AuthController() {
    registerAuthStateChecker(
      (ref) => ref.read(authControllerProvider.notifier).isLoggedIn,
    );
  }

  /// Dedicated constructor enabling 100% testability via direct mock injection.
  AuthController.test({
    LoginUseCase? loginUseCase,
    RegisterUseCase? registerUseCase,
    LogoutUseCase? logoutUseCase,
    GetCurrentUserUseCase? getCurrentUserUseCase,
    GoogleSignInUseCase? googleSignInUseCase,
    UpdateProfileUseCase? updateProfileUseCase,
    PushNotificationService? pushNotificationService,
  })  : _loginUseCaseOverride = loginUseCase,
        _registerUseCaseOverride = registerUseCase,
        _logoutUseCaseOverride = logoutUseCase,
        _getCurrentUserUseCaseOverride = getCurrentUserUseCase,
        _googleSignInUseCaseOverride = googleSignInUseCase,
        _updateProfileUseCaseOverride = updateProfileUseCase,
        _pushNotificationServiceOverride = pushNotificationService {
    registerAuthStateChecker(
      (ref) => ref.read(authControllerProvider.notifier).isLoggedIn,
    );
  }

  LoginUseCase get _loginUseCase =>
      _loginUseCaseOverride ?? ref.read(loginUseCaseProvider);
  RegisterUseCase get _registerUseCase =>
      _registerUseCaseOverride ?? ref.read(registerUseCaseProvider);
  LogoutUseCase get _logoutUseCase =>
      _logoutUseCaseOverride ?? ref.read(logoutUseCaseProvider);
  GetCurrentUserUseCase get _getCurrentUserUseCase =>
      _getCurrentUserUseCaseOverride ?? ref.read(getCurrentUserUseCaseProvider);
  GoogleSignInUseCase get _googleSignInUseCase =>
      _googleSignInUseCaseOverride ?? ref.read(googleSignInUseCaseProvider);
  UpdateProfileUseCase get _updateProfileUseCase =>
      _updateProfileUseCaseOverride ?? ref.read(updateProfileUseCaseProvider);
  PushNotificationService get _pushNotificationService =>
      _pushNotificationServiceOverride ?? ref.read(pushNotificationServiceProvider);

  @override
  FutureOr<UserEntity?> build() async {
    final result = await _getCurrentUserUseCase();

    return result.fold(
      (failure) {
        if (failure.type == FailureType.auth || failure.type == FailureType.cancel) {
          return null;
        }
        throw failure;
      },
      (user) => user,
    );
  }

  UserEntity? get currentUser => state.valueOrNull;
  bool get isLoggedIn => state.valueOrNull != null;
  bool get isLoading => state.isLoading;

  /// Resets an active error state back to current user data.
  void clearError() {
    if (state.hasError) {
      state = AsyncData(currentUser);
    }
  }

  Future<void> signInWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();

    final result = await _loginUseCase(
      email: email,
      password: password,
    );

    result.fold(
      (failure) {
        state = AsyncError(failure, failure.stackTrace ?? StackTrace.current);
      },
      (user) {
        _pushNotificationService.syncDeviceToken();
        state = AsyncData(user);
      },
    );
  }

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    String? name,
  }) async {
    state = const AsyncLoading();

    final result = await _registerUseCase(
      email: email,
      password: password,
      name: name ?? '',
    );

    result.fold(
      (failure) {
        state = AsyncError(failure, failure.stackTrace ?? StackTrace.current);
      },
      (user) {
        _pushNotificationService.syncDeviceToken();
        state = AsyncData(user);
      },
    );
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();

    final result = await _googleSignInUseCase();

    result.fold(
      (failure) {
        state = AsyncError(failure, failure.stackTrace ?? StackTrace.current);
      },
      (user) {
        _pushNotificationService.syncDeviceToken();
        state = AsyncData(user);
      },
    );
  }

  Future<void> signOut() async {
    state = const AsyncLoading();

    final result = await _logoutUseCase();

    result.fold(
      (failure) {
        // Even if remote session revocation failed, local session is cleared
        state = const AsyncData(null);
      },
      (_) {
        state = const AsyncData(null);
      },
    );
  }

  Future<void> updateUserProfile({
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
  }) async {
    if (state.valueOrNull == null) return;

    state = const AsyncLoading();

    final result = await _updateProfileUseCase(
      name: name,
      email: email,
      phone: phone,
      photoUrl: photoUrl,
    );

    result.fold(
      (failure) {
        state = AsyncError(failure, failure.stackTrace ?? StackTrace.current);
      },
      (user) {
        state = AsyncData(user);
      },
    );
  }
}
