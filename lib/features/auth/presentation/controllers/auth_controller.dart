import 'package:dio/dio.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/core/errors/errors.dart';
import 'package:stronger_muscles/core/services/push_notification_service.dart';
import 'package:stronger_muscles/features/auth/domain/entities/user_entity.dart';
import 'package:stronger_muscles/features/auth/domain/usecases/usecase_providers.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  CancelToken _cancelToken = CancelToken();

  @override
  FutureOr<UserEntity?> build() async {
    _cancelToken = CancelToken();

    // Safely cancel any active requests on dispose to prevent resource leaks
    ref.onDispose(() {
      if (!_cancelToken.isCancelled) {
        _cancelToken.cancel('AuthController disposed');
      }
    });

    final getCurrentUser = ref.read(getCurrentUserUseCaseProvider);
    final result = await getCurrentUser(cancelToken: _cancelToken);

    return result.fold(
      (failure) {
        // Auth failures on startup (e.g. guest or expired token) result in null user (not crash)
        if (failure.type == FailureType.auth || failure.type == FailureType.cancel) {
          return null;
        }
        // Surface network/server errors for fallback UI if needed
        throw failure;
      },
      (user) => user,
    );
  }

  UserEntity? get currentUser => state.value;
  bool get isLoggedIn => state.value != null;
  bool get isLoading => state.isLoading;

  /// Resets an active error state back to data
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

    final login = ref.read(loginUseCaseProvider);
    final result = await login(
      email: email,
      password: password,
      cancelToken: _cancelToken,
    );

    result.fold(
      (failure) {
        state = AsyncError(failure, failure.stackTrace ?? StackTrace.current);
      },
      (user) {
        ref.read(pushNotificationServiceProvider).syncDeviceToken();
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

    final register = ref.read(registerUseCaseProvider);
    final result = await register(
      email: email,
      password: password,
      name: name ?? '',
      cancelToken: _cancelToken,
    );

    result.fold(
      (failure) {
        state = AsyncError(failure, failure.stackTrace ?? StackTrace.current);
      },
      (user) {
        ref.read(pushNotificationServiceProvider).syncDeviceToken();
        state = AsyncData(user);
      },
    );
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();

    try {
      final googleSignIn = GoogleSignIn.instance;
      try {
        await googleSignIn.initialize();
      } catch (_) {
        // Safe to ignore if already initialized
      }

      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();

      final googleAuthUseCase = ref.read(googleSignInUseCaseProvider);
      final result = await googleAuthUseCase(
        email: googleUser.email,
        name: googleUser.displayName ?? '',
        photoUrl: googleUser.photoUrl,
        cancelToken: _cancelToken,
      );

      result.fold(
        (failure) {
          state = AsyncError(failure, failure.stackTrace ?? StackTrace.current);
        },
        (user) {
          ref.read(pushNotificationServiceProvider).syncDeviceToken();
          state = AsyncData(user);
        },
      );
    } catch (e, st) {
      final failure = NetworkErrorHandler.handle(e, st);
      state = AsyncError(failure, st);
    }
  }

  Future<void> signOut() async {
    state = const AsyncLoading();

    final logout = ref.read(logoutUseCaseProvider);
    final result = await logout(cancelToken: _cancelToken);

    result.fold(
      (failure) {
        // Even if remote logout fails, user local token is cleared
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
    if (state.value == null) return;

    state = const AsyncLoading();

    final updateProfile = ref.read(updateProfileUseCaseProvider);
    final result = await updateProfile(
      name: name,
      email: email,
      phone: phone,
      photoUrl: photoUrl,
      cancelToken: _cancelToken,
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
