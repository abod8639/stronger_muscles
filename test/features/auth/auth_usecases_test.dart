import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/features/auth/domain/repositories/auth_repository.dart';
import 'package:stronger_muscles/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:stronger_muscles/features/auth/domain/usecases/login_usecase.dart';
import 'package:stronger_muscles/features/auth/domain/usecases/logout_usecase.dart';
import 'package:stronger_muscles/features/auth/domain/usecases/register_usecase.dart';
import 'package:stronger_muscles/features/profile/data/models/user_model.dart';

class FakeAuthRepository implements AuthRepository {
  UserModel? mockUser;
  bool shouldThrow = false;
  bool logoutCalled = false;
  String? lastLoginEmail;
  String? lastLoginPassword;
  String? lastRegisterName;

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    if (shouldThrow) {
      throw Exception('Invalid credentials');
    }
    lastLoginEmail = email;
    lastLoginPassword = password;
    return mockUser ??
        UserModel(
          id: 1,
          email: email,
          name: 'Logged In User',
        );
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    if (shouldThrow) {
      throw Exception('Email already in use');
    }
    lastRegisterName = name;
    return UserModel(
      id: 2,
      email: email,
      name: name,
    );
  }

  @override
  Future<void> logout() async {
    logoutCalled = true;
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    return mockUser;
  }

  @override
  Future<UserModel> googleSignIn({
    required String email,
    required String name,
    String? photoUrl,
  }) async {
    return UserModel(id: 3, email: email, name: name, photoUrl: photoUrl);
  }

  @override
  Future<UserModel> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
  }) async {
    return UserModel(
      id: 1,
      email: email ?? 'test@example.com',
      name: name ?? 'Updated',
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
      fakeRepository.mockUser = const UserModel(
        id: 99,
        email: 'active@example.com',
        name: 'Active User',
      );

      user = await getCurrentUserUseCase();
      expect(user, isNotNull);
      expect(user!.id, 99);
      expect(user.email, 'active@example.com');
    });
  });
}
