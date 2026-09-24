import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/core/utils/components/base_app_bar.dart';
import 'package:stronger_muscles/core/utils/components/flavor_image.dart';
import 'package:stronger_muscles/core/utils/components/internet_connection_banner.dart';
import 'package:stronger_muscles/core/utils/functions/cache_manager.dart';
import 'package:stronger_muscles/features/home/presentation/controllers/internet_connection_controller.dart';

class FakeInternetConnectedNotifier extends InternetConnectionController {
  @override
  bool build() => true;
}

class FakeInternetDisconnectedNotifier extends InternetConnectionController {
  @override
  bool build() => false;
}

void main() {
  group('BaseAppBar Component Tests', () {
    testWidgets('renders baseAppBar with correct title and centered title alignment', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              appBar: baseAppBar(context, 'Test Header'),
            ),
          ),
        ),
      );

      expect(find.text('Test Header'), findsOneWidget);
      final appBarFinder = find.byType(AppBar);
      expect(appBarFinder, findsOneWidget);

      final AppBar appBar = tester.widget<AppBar>(appBarFinder);
      expect(appBar.centerTitle, isTrue);
    });
  });

  group('InternetConnectionBanner Component Tests', () {
    testWidgets('renders SizedBox.shrink when internet is connected', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            internetConnectionControllerProvider.overrideWith(() => FakeInternetConnectedNotifier()),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: InternetConnectionBanner(title: 'لا يوجد اتصال بالإنترنت'),
            ),
          ),
        ),
      );

      expect(find.text('لا يوجد اتصال بالإنترنت'), findsNothing);
      expect(find.byIcon(Icons.wifi_off), findsNothing);
    });

    testWidgets('renders alert banner with title and wifi_off icon when disconnected', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            internetConnectionControllerProvider.overrideWith(() => FakeInternetDisconnectedNotifier()),
          ],
          child: const MaterialApp(
            home: Scaffold(
              body: InternetConnectionBanner(title: 'لا يوجد اتصال بالإنترنت'),
            ),
          ),
        ),
      );

      expect(find.text('لا يوجد اتصال بالإنترنت'), findsOneWidget);
      expect(find.byIcon(Icons.wifi_off), findsOneWidget);
    });
  });

  group('FlavorsData and CustomCacheManager Tests', () {
    test('flavorsData map contains all required flavours with non-empty attributes', () {
      expect(flavorsData.containsKey('vanilla'), isTrue);
      expect(flavorsData.containsKey('chocolate'), isTrue);
      expect(flavorsData.containsKey('strawberry'), isTrue);
      expect(flavorsData.containsKey('banana'), isTrue);

      for (final entry in flavorsData.entries) {
        expect(entry.value.name.isNotEmpty, isTrue);
        expect(entry.value.image.startsWith('http'), isTrue);
      }
    });

    test('CustomCacheManager has defined cache key and instance', () {
      expect(CustomCacheManager.key, 'customCacheKey');
      expect(CustomCacheManager.instance, isNotNull);
    });
  });
}
