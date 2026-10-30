import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stronger_muscles/core/utils/functions/app_guard.dart';
import 'package:stronger_muscles/features/auth/presentation/controllers/auth_controller.dart';

/// Shared auth action handling for sign-in / sign-up pages:
/// runs actions behind the internet guard and remembers the last one for retry.
mixin AuthActionsMixin<T extends ConsumerStatefulWidget> on ConsumerState<T> {
  Future<void> Function()? _lastAction;

  AuthController get authController => ref.read(authControllerProvider.notifier);

  void runAuthAction(Future<void> Function() action) {
    _lastAction = action;
    AppGuard.runSafeInternet(ref, action);
  }

  void retryLastAction() {
    final action = _lastAction;
    if (action != null) {
      runAuthAction(action);
    } else {
      authController.clearError();
    }
  }

  void signInWithGoogle() => runAuthAction(authController.signInWithGoogle);
}
