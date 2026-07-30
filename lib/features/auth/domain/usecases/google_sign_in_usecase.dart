import 'package:stronger_muscles/features/auth/domain/repositories/auth_repository.dart';
import 'package:stronger_muscles/features/profile/data/models/user_model.dart';

class GoogleSignInUseCase {
  final AuthRepository repository;

  GoogleSignInUseCase(this.repository);

  Future<UserModel> call({
    required String email,
    required String name,
    String? photoUrl,
  }) {
    return repository.googleSignIn(
      email: email,
      name: name,
      photoUrl: photoUrl,
    );
  }
}
