import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/core/components/app_empty_state.dart';
import 'package:stronger_muscles/features/product/data/models/product_model.dart';
import 'package:stronger_muscles/features/auth/domain/entities/user_entity.dart';
import 'package:stronger_muscles/features/auth/presentation/controllers/auth_controller.dart';
import 'package:stronger_muscles/features/order/domain/entities/order_entity.dart';
import 'package:stronger_muscles/features/order/presentation/controllers/orders_controller.dart';
import 'package:stronger_muscles/features/profile/domain/entities/address_entity.dart';
import 'package:stronger_muscles/features/profile/presentation/controllers/address_controller.dart';
import 'package:stronger_muscles/features/profile/presentation/widgets/account_settings_list.dart';
import 'package:stronger_muscles/features/profile/presentation/widgets/login_prompt_card.dart';
import 'package:stronger_muscles/features/profile/presentation/widgets/profile_header.dart';
import 'package:stronger_muscles/features/profile/presentation/widgets/purchase_stats_card.dart';
import 'package:stronger_muscles/features/profile/presentation/widgets/quick_actions_row.dart';
import 'package:stronger_muscles/features/profile/presentation/widgets/saved_addresses_list.dart';
import 'package:stronger_muscles/features/notifications/presentation/controllers/notification_controller.dart';
import 'package:stronger_muscles/features/wishlist/presentation/controllers/wishlist_controller.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

void main() {
  Widget createTestWidget({
    required Widget child,
    List<Override> overrides = const [],
  }) {
    return ProviderScope(
      overrides: [
        unreadNotificationCountProvider.overrideWithValue(0),
        ...overrides,
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: Scaffold(
          body: SingleChildScrollView(child: child),
        ),
      ),
    );
  }

  group('Profile Widgets Clean Architecture & Theme Tests', () {
    testWidgets('SavedAddressesList renders AppEmptyState when address list is empty', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const SavedAddressesList(),
          overrides: [
            addressControllerProvider.overrideWith(
              () => _FakeAddressController(const AsyncData([])),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(AppEmptyState), findsOneWidget);
      expect(find.byIcon(Icons.location_off_outlined), findsOneWidget);
    });

    testWidgets('PurchaseStatsCard calculates total spent and delivered orders', (tester) async {
      final orders = [
        OrderEntity(
          id: '1',
          userId: 'u1',
          addressId: 'a1',
          subtotal: 250.0,
          totalAmount: 250.0,
          status: 'delivered',
          createdAt: DateTime(2026, 1, 1),
        ),
        OrderEntity(
          id: '2',
          userId: 'u1',
          addressId: 'a1',
          subtotal: 150.0,
          totalAmount: 150.0,
          status: 'pending',
          createdAt: DateTime(2026, 1, 2),
        ),
      ];

      await tester.pumpWidget(
        createTestWidget(
          child: const PurchaseStatsCard(),
          overrides: [
            ordersControllerProvider.overrideWith(
              () => _FakeOrdersController(AsyncData(orders)),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('LE 400'), findsOneWidget);
      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('QuickActionsRow displays orders, wishlist, and addresses counts', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const QuickActionsRow(),
          overrides: [
            ordersControllerProvider.overrideWith(
              () => _FakeOrdersController(
                AsyncData([
                  OrderEntity(
                    id: '1',
                    userId: 'u1',
                    addressId: 'a1',
                    subtotal: 100,
                    totalAmount: 100,
                    status: 'completed',
                    createdAt: DateTime(2026, 1, 1),
                  ),
                ]),
              ),
            ),
            wishlistControllerProvider.overrideWith(
              () => _FakeWishlistController([
                const ProductModel(id: 'prod-1', price: 10),
                const ProductModel(id: 'prod-2', price: 20),
              ]),
            ),
            addressControllerProvider.overrideWith(
              () => _FakeAddressController(
                const AsyncData([
                  AddressEntity(
                    id: 1,
                    street: 'Street 1',
                    city: 'Cairo',
                  ),
                ]),
              ),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('1'), findsNWidgets(2)); // ordersCount & addressesCount
      expect(find.text('2'), findsOneWidget); // wishlistCount
      expect(find.text('Orders'), findsOneWidget);
      expect(find.text('Wishlist'), findsOneWidget);
      expect(find.text('Addresses'), findsOneWidget);
    });

    testWidgets('ProfileHeader displays user name, email and avatar', (tester) async {
      const user = UserEntity(
        id: 1,
        name: 'John Doe',
        email: 'john@example.com',
        token: 'test_token',
      );

      await tester.pumpWidget(
        createTestWidget(
          child: const ProfileHeader(),
          overrides: [
            authControllerProvider.overrideWith(
              () => _FakeAuthController(const AsyncData(user)),
            ),
          ],
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('john@example.com'), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('LoginPromptCard displays prompt and sign in buttons', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const LoginPromptCard(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Sign in to Your Account'), findsOneWidget);
      expect(find.text('Login / Register'), findsOneWidget);
      expect(find.text('Sign in with Google'), findsOneWidget);
      expect(find.byType(AccountSettingsList), findsOneWidget);
    });

    testWidgets('AccountSettingsList renders settings items', (tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const AccountSettingsList(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Edit Profile'), findsOneWidget);
      expect(find.text('Theme'), findsOneWidget);
      expect(find.text('Notifications'), findsOneWidget);
      expect(find.text('Language'), findsOneWidget);
      expect(find.text('Help & Support'), findsOneWidget);
      expect(find.text('About'), findsOneWidget);
    });
  });
}

class _FakeAddressController extends AddressController {
  final AsyncValue<List<AddressEntity>> _initial;
  _FakeAddressController(this._initial);

  @override
  FutureOr<List<AddressEntity>> build() {
    return _initial.value ?? [];
  }
}

class _FakeOrdersController extends OrdersController {
  final AsyncValue<List<OrderEntity>> _initial;
  _FakeOrdersController(this._initial);

  @override
  FutureOr<List<OrderEntity>> build() {
    return _initial.value ?? [];
  }
}

class _FakeWishlistController extends WishlistController {
  final List<ProductModel> _initial;
  _FakeWishlistController(this._initial);

  @override
  List<ProductModel> build() {
    return _initial;
  }
}

class _FakeAuthController extends AuthController {
  final AsyncValue<UserEntity?> _initial;
  _FakeAuthController(this._initial);

  @override
  FutureOr<UserEntity?> build() {
    return _initial.value;
  }
}
