import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/core/components/components.dart';

Widget _wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  group('AppEmptyState', () {
    testWidgets('renders inside a scroll view (unbounded height)', (tester) async {
      await tester.pumpWidget(
        _wrap(
          ListView(
            children: const [
              AppEmptyState(
                icon: Icons.inbox,
                title: 'Empty',
                fillHeight: false,
                extra: Text('extra'),
              ),
            ],
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Empty'), findsOneWidget);
      expect(find.text('extra'), findsOneWidget);
    });

    testWidgets('fillHeight: false keeps a dialog compact', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const Dialog(
            child: AppEmptyState(icon: Icons.check, title: 'Done', fillHeight: false),
          ),
        ),
      );

      final dialogCard = find.descendant(of: find.byType(Dialog), matching: find.byType(Material));
      final dialogHeight = tester.getSize(dialogCard.first).height;
      expect(dialogHeight, lessThan(400));
    });

    testWidgets('shows secondary action and calls it', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _wrap(
          AppEmptyState(
            icon: Icons.error,
            title: 'Oops',
            secondaryActionText: 'Reset',
            onSecondaryActionTap: () => tapped = true,
          ),
        ),
      );

      await tester.tap(find.text('Reset'));
      expect(tapped, isTrue);
    });
  });

  group('AppBottomSheetScaffold', () {
    testWidgets('wraps content without heightFactor', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const Align(
            alignment: Alignment.bottomCenter,
            child: AppBottomSheetScaffold(
              title: 'Title',
              subtitle: 'Sub',
              icon: Icons.support_agent,
              child: SizedBox(height: 100, child: Text('body')),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Title'), findsOneWidget);
      expect(find.text('body'), findsOneWidget);
      expect(tester.getSize(find.byType(AppBottomSheetScaffold)).height, lessThan(400));
    });

    testWidgets('fills the given fraction with heightFactor', (tester) async {
      await tester.pumpWidget(
        _wrap(
          Align(
            alignment: Alignment.bottomCenter,
            child: AppBottomSheetScaffold(
              title: 'List',
              heightFactor: 0.5,
              child: ListView(children: const [Text('row')]),
            ),
          ),
        ),
      );

      final screenHeight = tester.view.physicalSize.height / tester.view.devicePixelRatio;
      expect(
        tester.getSize(find.byType(AppBottomSheetScaffold)).height,
        moreOrLessEquals(screenHeight * 0.5),
      );
    });
  });

  group('AppChoiceChips', () {
    testWidgets('reports the tapped item', (tester) async {
      String? selected;
      await tester.pumpWidget(
        _wrap(
          AppChoiceChips<String>(
            items: const ['a', 'b'],
            selected: 'a',
            labelOf: (item) => item.toUpperCase(),
            onSelected: (item) => selected = item,
            scrollable: false,
          ),
        ),
      );

      await tester.tap(find.text('B'));
      expect(selected, 'b');
    });
  });

  group('AppSwipeToDelete', () {
    testWidgets('calls onDeleted after swiping end to start', (tester) async {
      var deleted = false;
      await tester.pumpWidget(
        _wrap(
          ListView(
            children: [
              AppSwipeToDelete(
                dismissKey: const ValueKey('row'),
                onDeleted: () => deleted = true,
                child: const SizedBox(height: 60, child: Text('row')),
              ),
            ],
          ),
        ),
      );

      await tester.drag(find.text('row'), const Offset(-500, 0));
      await tester.pumpAndSettle();
      expect(deleted, isTrue);
    });
  });

  group('AppAvatar', () {
    testWidgets('shows the initial when there is a name but no photo', (tester) async {
      await tester.pumpWidget(_wrap(const AppAvatar(name: 'sara')));
      expect(find.text('S'), findsOneWidget);
    });

    testWidgets('falls back to the icon without name or photo', (tester) async {
      await tester.pumpWidget(_wrap(const AppAvatar()));
      expect(find.byIcon(Icons.person), findsOneWidget);
    });
  });

  group('AppListTile & AppStatCard', () {
    testWidgets('AppListTile reports taps and shows a chevron', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        _wrap(AppListTile(icon: Icons.language, title: 'Language', onTap: () => taps++)),
      );
      await tester.tap(find.text('Language'));
      expect(taps, 1);
      expect(find.byIcon(Icons.chevron_right_rounded), findsOneWidget);
    });

    testWidgets('AppStatCard shows value and label', (tester) async {
      await tester.pumpWidget(
        _wrap(const AppStatCard(icon: Icons.favorite, value: '7', label: 'Wishlist', color: Colors.red)),
      );
      expect(find.text('7'), findsOneWidget);
      expect(find.text('Wishlist'), findsOneWidget);
    });
  });

  group('AppShimmer', () {
    testWidgets('skeleton boxes animate under one shimmer', (tester) async {
      await tester.pumpWidget(
        _wrap(const AppShimmer(child: AppSkeletonBox(width: 50, height: 10))),
      );
      Color colorNow() => ((tester.widget<Container>(find.byType(Container).last).decoration
              as BoxDecoration)
          .color)!;
      final first = colorNow();
      await tester.pump(const Duration(milliseconds: 600));
      expect(colorNow(), isNot(first));
    });
  });

  group('AppCircleIconButton & AppSearchField', () {
    testWidgets('circle button shows a capped badge and reports taps', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        _wrap(AppCircleIconButton(icon: Icons.notifications, badgeCount: 120, onPressed: () => taps++)),
      );
      expect(find.text('99+'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.notifications));
      expect(taps, 1);
    });

    testWidgets('search field forwards submitted text', (tester) async {
      String? submitted;
      await tester.pumpWidget(_wrap(AppSearchField(onSubmitted: (v) => submitted = v)));
      await tester.enterText(find.byType(TextField), 'whey');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      expect(submitted, 'whey');
    });
  });
}
