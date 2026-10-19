import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/features/product/domain/entities/category_entity.dart';
import 'package:stronger_muscles/features/product/domain/entities/localized_string_entity.dart';
import 'package:stronger_muscles/features/product/presentation/controllers/category_controller.dart';
import 'package:stronger_muscles/features/product/presentation/widgets/category_chip_selector.dart';

void main() {
  group('CategoryChipSelector Widget Tests', () {
    const categories = [
      CategoryEntity(
        id: 'cat-1',
        name: LocalizedStringEntity(en: 'Proteins', ar: 'بروتينات'),
      ),
      CategoryEntity(
        id: 'cat-2',
        name: LocalizedStringEntity(en: 'Vitamins', ar: 'فيتامينات'),
      ),
    ];

    testWidgets('renders all category chips and handles selection', (tester) async {
      String? selectedId;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            categoryControllerProvider.overrideWith(
              () => _TestCategoryController(categories),
            ),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: CategoryChipSelector(
                selectedCategoryId: '',
                onCategorySelected: (id) => selectedId = id,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // "All" chip + category names
      expect(find.text('Proteins'), findsOneWidget);
      expect(find.text('Vitamins'), findsOneWidget);

      await tester.tap(find.text('Proteins'));
      await tester.pumpAndSettle();

      expect(selectedId, equals('cat-1'));
    });
  });
}

class _TestCategoryController extends CategoryController {
  final List<CategoryEntity> _items;
  _TestCategoryController(this._items);

  @override
  Future<List<CategoryEntity>> build() async => _items;
}
