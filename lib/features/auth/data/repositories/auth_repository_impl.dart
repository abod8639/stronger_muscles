import 'package:fpdart/fpdart.dart';
import 'package:stronger_muscles/core/errors/errors.dart';
import 'package:stronger_muscles/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:stronger_muscles/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:stronger_muscles/features/auth/data/mappers/auth_mapper.dart';
import 'package:stronger_muscles/features/auth/domain/entities/user_entity.dart';
import 'package:stronger_muscles/features/auth/domain/repositories/auth_repository.dart';

/// Concrete implementation of [AuthRepository].
///
/// Acts as the Single Source of Truth, orchestrating data flow between
/// [AuthRemoteDataSource] (network/Dio) and [AuthLocalDataSource] (secure token caching).
///
/// Converts data-layer DTOs ([UserModel]) into domain entities ([UserEntity])
/// and catches all exceptions, mapping them into typed [Failure] instances.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<Either<Failure, UserEntity>> login({
    required String email,
    required String password,
  }) {
    return NetworkErrorHandler.execute(() async {
      final userModel = await _remoteDataSource.login(
        email: email,
        password: password,
      );

      if (userModel.token != null && userModel.token!.isNotEmpty) {
        await _localDataSource.saveToken(userModel.token!);
      }

      return userModel.toEntity();
    });
  }

  @override
  Future<Either<Failure, UserEntity>> register({
    required String name,
    required String email,
    required String password,
  }) {
    return NetworkErrorHandler.execute(() async {
      final userModel = await _remoteDataSource.register(
        name: name,
        email: email,
        password: password,
      );

      if (userModel.token != null && userModel.token!.isNotEmpty) {
        await _localDataSource.saveToken(userModel.token!);
      }

      return userModel.toEntity();
    });
  }

  @override
  Future<Either<Failure, UserEntity>> googleSignIn() {
    return NetworkErrorHandler.execute(() async {
      final userModel = await _remoteDataSource.googleSignIn();

      if (userModel.token != null && userModel.token!.isNotEmpty) {
        await _localDataSource.saveToken(userModel.token!);
      }

      return userModel.toEntity();
    });
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() {
    return NetworkErrorHandler.execute(() async {
      if (!_localDataSource.hasToken()) {
        return null;
      }

      try {
        final userModel = await _remoteDataSource.getCurrentUser();
        return userModel?.toEntity();
      } on AuthException {
        await _localDataSource.deleteToken();
        return null;
      } catch (e) {
        if (e is AuthFailure || (e is Failure && e.type == FailureType.auth)) {
          await _localDataSource.deleteToken();
          return null;
        }
        rethrow;
      }
    });
  }

  @override
  Future<Either<Failure, Unit>> logout() {
    return NetworkErrorHandler.execute(() async {
      try {
        await _remoteDataSource.logout();
      } catch (_) {
        // Allow logout to succeed locally even if network revocation fails
      } finally {
        await _localDataSource.deleteToken();
      }

      return unit;
    });
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
  }) {
    return NetworkErrorHandler.execute(() async {
      final userModel = await _remoteDataSource.updateProfile(
        name: name,
        email: email,
        phone: phone,
        photoUrl: photoUrl,
      );

      return userModel.toEntity();
    });
  }
}
