import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../services/storage_service.dart';

/// Type signature for checking authentication state using Riverpod [Ref].
typedef AuthStateChecker = bool Function(Ref ref);

AuthStateChecker? _authStateDelegate;

/// Allows higher-level features (e.g. AuthController) or test harnesses to register
/// a custom authentication check delegate.
void registerAuthStateChecker(AuthStateChecker? checker) {
  _authStateDelegate = checker;
}

/// Core-level provider determining if the user is authenticated.
///
/// If a delegate has been registered via [registerAuthStateChecker], it is invoked.
/// Otherwise, it safely checks whether an auth token exists in [StorageService] if the box is open.
final authStateProvider = Provider<bool>((ref) {
  if (_authStateDelegate != null) {
    return _authStateDelegate!(ref);
  }
  if (Hive.isBoxOpen('auth_box')) {
    return StorageService.hasToken;
  }
  return false;
});
