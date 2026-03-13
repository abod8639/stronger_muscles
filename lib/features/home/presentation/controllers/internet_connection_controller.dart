import 'dart:async';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'internet_connection_controller.g.dart';

@Riverpod(keepAlive: true)
class InternetConnectionController extends _$InternetConnectionController {
  StreamSubscription? _subscription;
  late final InternetConnection _internetConnection;

  @override
  bool build() {
    _internetConnection = InternetConnection();
    _startMonitoring();
    
    ref.onDispose(() {
      _subscription?.cancel();
    });

    return true; // Assume connected initially or check first
  }

  void _startMonitoring() {
    _checkInitialStatus();

    _subscription = _internetConnection.onStatusChange.listen((status) {
      state = (status == InternetStatus.connected);
    });
  }

  Future<void> _checkInitialStatus() async {
    bool hasAccess = await _internetConnection.hasInternetAccess;
    state = hasAccess;
  }
}
