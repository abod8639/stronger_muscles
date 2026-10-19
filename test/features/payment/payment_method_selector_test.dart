import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/features/payment/domain/entities/payment_method_entity.dart';
import 'package:stronger_muscles/features/payment/presentation/widgets/payment_method_selector.dart';

void main() {
  group('PaymentMethodSelector Widget Tests', () {
    final methods = [
      const PaymentMethodEntity(
        id: 'cash',
        title: 'الدفع عند الاستلام',
        subtitle: 'الدفع كاش',
        icon: Icons.payments_outlined,
      ),
      const PaymentMethodEntity(
        id: 'card',
        title: 'بطاقة ائتمان',
        subtitle: 'فيزا وماستركارد',
        icon: Icons.credit_card,
      ),
    ];

    testWidgets('renders all payment methods and security badge', (tester) async {
      String? selected;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PaymentMethodSelector(
              methods: methods,
              selectedMethodId: 'cash',
              onMethodSelected: (id) => selected = id,
            ),
          ),
        ),
      );

      expect(find.text('الدفع عند الاستلام'), findsOneWidget);
      expect(find.text('بطاقة ائتمان'), findsOneWidget);
      expect(find.text('فيزا وماستركارد'), findsOneWidget);

      await tester.tap(find.text('بطاقة ائتمان'));
      await tester.pumpAndSettle();

      expect(selected, 'card');
    });
  });
}
