import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/features/auth/presentation/controllers/auth_controller.dart';

Future<void> updateProfile(
  WidgetRef ref,
  String name,
  String email,
  String phone,
) async {
  await ref
      .read(authControllerProvider.notifier)
      .updateUserProfile(name: name, email: email, phone: phone);
}
