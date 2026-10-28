import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/services/api_service.dart';
import 'package:stronger_muscles/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:stronger_muscles/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:stronger_muscles/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:stronger_muscles/features/auth/domain/repositories/auth_repository.dart';
import 'package:stronger_muscles/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:stronger_muscles/features/auth/domain/usecases/google_sign_in_usecase.dart';
import 'package:stronger_muscles/features/auth/domain/usecases/login_usecase.dart';
import 'package:stronger_muscles/features/auth/domain/usecases/logout_usecase.dart';
import 'package:stronger_muscles/features/auth/domain/usecases/register_usecase.dart';
import 'package:stronger_muscles/features/auth/domain/usecases/update_profile_usecase.dart';

// ── Data Sources ─────────────────────────────────────────────────────────────

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return const AuthLocalDataSourceImpl();
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return AuthRemoteDataSourceImpl(apiService: apiService);
});

// ── Repository ───────────────────────────────────────────────────────────────

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  final localDataSource = ref.watch(authLocalDataSourceProvider);

  return AuthRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );
});

// ── Use Cases ────────────────────────────────────────────────────────────────

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
});

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  return RegisterUseCase(ref.watch(authRepositoryProvider));
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  return LogoutUseCase(ref.watch(authRepositoryProvider));
});

final getCurrentUserUseCaseProvider = Provider<GetCurrentUserUseCase>((ref) {
  return GetCurrentUserUseCase(ref.watch(authRepositoryProvider));
});

final googleSignInUseCaseProvider = Provider<GoogleSignInUseCase>((ref) {
  return GoogleSignInUseCase(ref.watch(authRepositoryProvider));
});

final updateProfileUseCaseProvider = Provider<UpdateProfileUseCase>((ref) {
  return UpdateProfileUseCase(ref.watch(authRepositoryProvider));
});
