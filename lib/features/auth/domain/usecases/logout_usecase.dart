import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/auth/domain/repositories/auth_repository.dart';

/// Pure Dart usecase for logging out the current user session.
class LogoutUseCase {
  final AuthRepository _repository;

  const LogoutUseCase(this._repository);

  Future<Either<Failure, Unit>> call() {
    return _repository.logout();
  }
}
