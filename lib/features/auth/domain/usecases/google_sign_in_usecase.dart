import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/auth/domain/entities/user_entity.dart';
import 'package:stronger_muscles/features/auth/domain/repositories/auth_repository.dart';

/// Pure Dart usecase for signing in via Google.
class GoogleSignInUseCase {
  final AuthRepository _repository;

  const GoogleSignInUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call() {
    return _repository.googleSignIn();
  }
}
