import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:stronger_muscles/core/errors/errors.dart';
import 'package:stronger_muscles/features/auth/data/datasources/auth_service.dart';
import 'package:stronger_muscles/features/auth/domain/entities/user_entity.dart';
import 'package:stronger_muscles/features/auth/domain/repositories/auth_repository.dart';

part 'auth_repository_impl.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepositoryImpl(ref.watch(authServiceProvider));
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthService authService;

  AuthRepositoryImpl(this.authService);

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser({
    CancelToken? cancelToken,
  }) {
    return NetworkErrorHandler.execute(() async {
      final model = await authService.getCurrentUser(cancelToken: cancelToken);
      return model?.toEntity();
    });
  }

  @override
  Future<Either<Failure, UserEntity>> googleSignIn({
    required String email,
    required String name,
    String? photoUrl,
    CancelToken? cancelToken,
  }) {
    return NetworkErrorHandler.execute(() async {
      final model = await authService.googleSignIn(
        email: email,
        name: name,
        photoUrl: photoUrl,
        cancelToken: cancelToken,
      );
      return model.toEntity();
    });
  }

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
    CancelToken? cancelToken,
  }) {
    return NetworkErrorHandler.execute(() async {
      final model = await authService.login(
        email: email,
        password: password,
        cancelToken: cancelToken,
      );
      return model.toEntity();
    });
  }

  @override
  Future<Either<Failure, Unit>> logout({CancelToken? cancelToken}) {
    return NetworkErrorHandler.execute(() async {
      await authService.logout(cancelToken: cancelToken);
      return unit;
    });
  }

  @override
  Future<Either<Failure, UserEntity>> register({
    required String name,
    required String email,
    required String password,
    CancelToken? cancelToken,
  }) {
    return NetworkErrorHandler.execute(() async {
      final model = await authService.register(
        name: name,
        email: email,
        password: password,
        cancelToken: cancelToken,
      );
      return model.toEntity();
    });
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
    CancelToken? cancelToken,
  }) {
    return NetworkErrorHandler.execute(() async {
      final model = await authService.updateProfile(
        name: name,
        email: email,
        phone: phone,
        photoUrl: photoUrl,
        cancelToken: cancelToken,
      );
      return model.toEntity();
    });
  }
}
