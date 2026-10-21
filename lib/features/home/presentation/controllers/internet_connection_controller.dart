import 'dart:async';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'internet_connection_controller.g.dart';

@Riverpod(keepAlive: true)
class InternetConnectionController extends _$InternetConnectionController {
  StreamSubscription<InternetStatus>? _subscription;
  late final InternetConnection _internetConnection;
  bool _isDisposed = false;

  @override
  bool build() {
    _isDisposed = false;
    _internetConnection = InternetConnection();
    _startMonitoring();

    ref.onDispose(() {
      _isDisposed = true;
      _subscription?.cancel();
      _subscription = null;
    });

    return true;
  }

  void _startMonitoring() {
    _checkInitialStatus();

    _subscription = _internetConnection.onStatusChange.listen(
      (status) {
        if (!_isDisposed) {
          state = (status == InternetStatus.connected);
        }
      },
      onError: (_) {
        if (!_isDisposed) {
          state = false;
        }
      },
    );
  }

  Future<void> _checkInitialStatus() async {
    try {
      final hasAccess = await _internetConnection.hasInternetAccess;
      if (!_isDisposed) {
        state = hasAccess;
      }
    } catch (_) {
      if (!_isDisposed) {
        state = false;
      }
    }
  }
}
