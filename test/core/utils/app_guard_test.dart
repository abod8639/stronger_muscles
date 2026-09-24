import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:stronger_muscles/core/utils/functions/app_guard.dart';
import 'package:stronger_muscles/features/auth/presentation/controllers/auth_controller.dart';
import 'package:stronger_muscles/features/home/presentation/controllers/internet_connection_controller.dart';
import 'package:stronger_muscles/features/profile/data/models/user_model.dart';
import 'package:stronger_muscles/routes/routes.dart';

class MockOnlineNotifier extends InternetConnectionController {
  @override
  bool build() => true;
}

class MockOfflineNotifier extends InternetConnectionController {
  @override
  bool build() => false;
}

class MockLoggedInAuthNotifier extends AuthController {
  @override
  FutureOr<UserModel?> build() {
    return const UserModel(
      id: 1,
      email: 'member@muscle.com',
      name: 'Dexter',
    );
  }
}

class MockLoggedOutAuthNotifier extends AuthController {
  @override
  FutureOr<UserModel?> build() {
    return null;
  }
}

void main() {
  Future<void> Function(WidgetRef ref)? currentTrigger;
  late GoRouter testRouter;

  setUp(() {
    currentTrigger = null;
    testRouter = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(
            body: Center(
              child: Consumer(
                builder: (context, ref, _) => ElevatedButton(
                  key: const Key('guard_trigger_button'),
                  onPressed: () => currentTrigger?.call(ref),
                  child: const Text('Trigger Guard'),
                ),
              ),
            ),
          ),
        ),
        GoRoute(
          path: AppRoutes.auth,
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Auth Screen')),
          ),
        ),
      ],
    );
  });

  Widget buildAppGuardTester({
    required InternetConnectionController Function() internetNotifierBuilder,
    required AuthController Function() authNotifierBuilder,
  }) {
    return ProviderScope(
      overrides: [
        internetConnectionControllerProvider.overrideWith(internetNotifierBuilder),
        authControllerProvider.overrideWith(authNotifierBuilder),
        routerProvider.overrideWithValue(testRouter),
      ],
      child: MaterialApp.router(
        routerConfig: testRouter,
      ),
    );
  }

  group('AppGuard runSafe Tests', () {
    testWidgets('executes action when user is online and authenticated', (tester) async {
      bool actionExecuted = false;
      currentTrigger = (ref) => AppGuard.runSafe(ref, () async {
        actionExecuted = true;
      });

      await tester.pumpWidget(
        buildAppGuardTester(
          internetNotifierBuilder: () => MockOnlineNotifier(),
          authNotifierBuilder: () => MockLoggedInAuthNotifier(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('guard_trigger_button')));
      await tester.pumpAndSettle();

      expect(actionExecuted, isTrue);
      expect(find.text('لا يوجد اتصال'), findsNothing);
      expect(find.text('تنبيه'), findsNothing);
    });

    testWidgets('blocks action and displays dialog when offline', (tester) async {
      bool actionExecuted = false;
      currentTrigger = (ref) => AppGuard.runSafe(ref, () async {
        actionExecuted = true;
      });

      await tester.pumpWidget(
        buildAppGuardTester(
          internetNotifierBuilder: () => MockOfflineNotifier(),
          authNotifierBuilder: () => MockLoggedInAuthNotifier(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('guard_trigger_button')));
      await tester.pumpAndSettle();

      expect(actionExecuted, isFalse);
      expect(find.text('لا يوجد اتصال'), findsOneWidget);
      expect(find.text('يرجى التحقق من اتصالك بالإنترنت للمتابعة'), findsOneWidget);

      // Dismiss dialog
      await tester.tap(find.text('حسناً'));
      await tester.pumpAndSettle();
      expect(find.text('لا يوجد اتصال'), findsNothing);
    });

    testWidgets('blocks action and routes to auth when unauthenticated', (tester) async {
      bool actionExecuted = false;
      currentTrigger = (ref) => AppGuard.runSafe(ref, () async {
        actionExecuted = true;
      });

      await tester.pumpWidget(
        buildAppGuardTester(
          internetNotifierBuilder: () => MockOnlineNotifier(),
          authNotifierBuilder: () => MockLoggedOutAuthNotifier(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('guard_trigger_button')));
      await tester.pumpAndSettle();

      expect(actionExecuted, isFalse);
      expect(find.text('Auth Screen'), findsOneWidget);
    });
  });

  group('AppGuard specialized runners', () {
    testWidgets('runSafeInternet allows action when online', (tester) async {
      bool actionExecuted = false;
      currentTrigger = (ref) => AppGuard.runSafeInternet(ref, () async {
        actionExecuted = true;
      });

      await tester.pumpWidget(
        buildAppGuardTester(
          internetNotifierBuilder: () => MockOnlineNotifier(),
          authNotifierBuilder: () => MockLoggedOutAuthNotifier(),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('guard_trigger_button')));
      await tester.pumpAndSettle();

      expect(actionExecuted, isTrue);
    });

    testWidgets('runSafeInternet blocks action and shows dialog when offline', (tester) async {
      bool actionExecuted = false;
      currentTrigger = (ref) => AppGuard.runSafeInternet(ref, () async {
        actionExecuted = true;
      });

      await tester.pumpWidget(
        buildAppGuardTester(
          internetNotifierBuilder: () => MockOfflineNotifier(),
          authNotifierBuilder: () => MockLoggedOutAuthNotifier(),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('guard_trigger_button')));
      await tester.pumpAndSettle();

      expect(actionExecuted, isFalse);
      expect(find.text('لا يوجد اتصال'), findsOneWidget);
    });

    testWidgets('runSafeAuth allows action when authenticated and redirects when unauthenticated', (tester) async {
      bool actionExecuted = false;
      currentTrigger = (ref) => AppGuard.runSafeAuth(ref, () async {
        actionExecuted = true;
      });

      await tester.pumpWidget(
        buildAppGuardTester(
          internetNotifierBuilder: () => MockOfflineNotifier(),
          authNotifierBuilder: () => MockLoggedInAuthNotifier(),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('guard_trigger_button')));
      await tester.pumpAndSettle();

      expect(actionExecuted, isTrue);
    });
  });
}
