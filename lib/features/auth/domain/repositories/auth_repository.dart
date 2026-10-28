import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/failures.dart';
import 'package:stronger_muscles/features/auth/domain/entities/user_entity.dart';

/// Pure Dart domain contract for authentication operations.
///
/// Follows Clean Architecture: zero dependencies on external HTTP frameworks (Dio),
/// storage packages, or UI frameworks.
abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> register({
    required String name,
    required String email,
    required String password,
  });

  Future<Either<Failure, Unit>> logout();

  Future<Either<Failure, UserEntity?>> getCurrentUser();

  Future<Either<Failure, UserEntity>> googleSignIn();

  Future<Either<Failure, UserEntity>> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
  });
}
