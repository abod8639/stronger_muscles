import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/features/auth/domain/entities/user_entity.dart';
import 'package:stronger_muscles/features/auth/domain/repositories/auth_repository.dart';
import 'package:stronger_muscles/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:stronger_muscles/features/auth/domain/usecases/login_usecase.dart';
import 'package:stronger_muscles/features/auth/domain/usecases/logout_usecase.dart';
import 'package:stronger_muscles/features/auth/domain/usecases/register_usecase.dart';

class FakeAuthRepository implements AuthRepository {
  UserEntity? mockUser;
  bool shouldThrow = false;
  bool logoutCalled = false;
  String? lastLoginEmail;
  String? lastLoginPassword;
  String? lastRegisterName;

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    if (shouldThrow) {
      throw Exception('Invalid credentials');
    }
    lastLoginEmail = email;
    lastLoginPassword = password;
    return mockUser ??
        UserEntity(
          id: 1,
          email: email,
          name: 'Logged In User',
          token: "testToken",
          
        );
  }

  @override
  Future<UserEntity> register({
    required String name,
    required String email,
    required String password,
  }) async {
    if (shouldThrow) {
      throw Exception('Email already in use');
    }
    lastRegisterName = name;
    return UserEntity(
      id: 2,
      email: email,
      name: name,
      token: "testToken",
    );
  }

  @override
  Future<void> logout() async {
    logoutCalled = true;
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    return mockUser;
  }

  @override
  Future<UserEntity> googleSignIn({
    required String email,
    required String name,
    String? photoUrl,
  }) async {
    return UserEntity(id: 3, email: email, name: name, photoUrl: photoUrl,token: "testToken");
  }

  @override
  Future<UserEntity> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
  }) async {
    return UserEntity(
      id: 1,
      email: email ?? 'test@example.com',
      name: name ?? 'Updated',
      token: "testToken",
    );
  }
}

void main() {
  late FakeAuthRepository fakeRepository;

  setUp(() {
    fakeRepository = FakeAuthRepository();
  });

  group('Auth Domain UseCases Tests', () {
    test('LoginUseCase delegates credentials to repository and returns user', () async {
      final loginUseCase = LoginUseCase(fakeRepository);

      final result = await loginUseCase(
        email: 'user@strongermuscles.com',
        password: 'password123',
      );

      expect(result.email, 'user@strongermuscles.com');
      expect(fakeRepository.lastLoginEmail, 'user@strongermuscles.com');
      expect(fakeRepository.lastLoginPassword, 'password123');
    });

    test('LoginUseCase propagates exception on failure', () async {
      fakeRepository.shouldThrow = true;
      final loginUseCase = LoginUseCase(fakeRepository);

      expect(
        () => loginUseCase(
          email: 'wrong@example.com',
          password: 'wrongpassword',
        ),
        throwsA(isA<Exception>()),
      );
    });

    test('RegisterUseCase passes correct registration parameters', () async {
      final registerUseCase = RegisterUseCase(fakeRepository);

      final result = await registerUseCase(
        name: 'Captain Muscle',
        email: 'captain@strongermuscles.com',
        password: 'secretPassword',
      );

      expect(result.name, 'Captain Muscle');
      expect(fakeRepository.lastRegisterName, 'Captain Muscle');
    });

    test('LogoutUseCase invokes repository logout', () async {
      final logoutUseCase = LogoutUseCase(fakeRepository);

      await logoutUseCase();

      expect(fakeRepository.logoutCalled, isTrue);
    });

    test('GetCurrentUserUseCase returns current user or null', () async {
      final getCurrentUserUseCase = GetCurrentUserUseCase(fakeRepository);

      // When no user is logged in
      var user = await getCurrentUserUseCase();
      expect(user, isNull);

      // When user is set
      fakeRepository.mockUser = const UserEntity(
        id: 99,
        email: 'active@example.com',
        name: 'Active User',
        token: "testToken",
      );

      user = await getCurrentUserUseCase();
      expect(user, isNotNull);
      expect(user!.id, 99);
      expect(user.email, 'active@example.com');
    });
  });
}
