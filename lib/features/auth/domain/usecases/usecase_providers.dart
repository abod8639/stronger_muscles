import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:stronger_muscles/features/auth/domain/repositories/auth_repository.dart';
import 'package:stronger_muscles/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:stronger_muscles/features/auth/domain/usecases/login_usecase.dart';
import 'package:stronger_muscles/features/auth/domain/usecases/logout_usecase.dart';
import 'package:stronger_muscles/features/auth/domain/usecases/register_usecase.dart';
import 'package:stronger_muscles/features/auth/domain/usecases/update_profile_usecase.dart';

part 'usecase_providers.g.dart';

@riverpod
LoginUseCase loginUseCase(LoginUseCaseRef ref) {
  final AuthRepository repository = ref.watch(authRepositoryProvider);
  return LoginUseCase(repository);
}

@riverpod
RegisterUseCase registerUseCase(RegisterUseCaseRef ref) {
  final AuthRepository repository = ref.watch(authRepositoryProvider);
  return RegisterUseCase(repository);
}

@riverpod
LogoutUseCase logoutUseCase(LogoutUseCaseRef ref) {
  final AuthRepository repository = ref.watch(authRepositoryProvider);
  return LogoutUseCase(repository);
}

@riverpod
GetCurrentUserUseCase getCurrentUserUseCase(GetCurrentUserUseCaseRef ref) {
  final AuthRepository repository = ref.watch(authRepositoryProvider);
  return GetCurrentUserUseCase(repository);
}

@riverpod
UpdateProfileUseCase updateProfileUseCase(UpdateProfileUseCaseRef ref) {
  final AuthRepository repository = ref.watch(authRepositoryProvider);
  return UpdateProfileUseCase(repository);
}
