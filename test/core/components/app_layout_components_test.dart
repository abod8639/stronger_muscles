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
}
