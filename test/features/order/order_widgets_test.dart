import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stronger_muscles/features/order/domain/entities/order_entity.dart';
import 'package:stronger_muscles/features/order/domain/entities/order_item_entity.dart';
import 'package:stronger_muscles/features/order/presentation/pages/order_details_view.dart';
import 'package:stronger_muscles/features/order/presentation/widgets/order_card.dart';
import 'package:stronger_muscles/l10n/generated/app_localizations.dart';

Widget _wrap(Widget child) => MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    );

const _items = [
  OrderItemEntity(
    id: 'i1',
    orderId: 'order-123456',
    productId: 'p1',
    productName: 'Whey Isolate',
    unitPrice: 100.0,
    quantity: 2,
    subtotal: 200.0,
    selectedFlavor: 'Chocolate',
  ),
  OrderItemEntity(
    id: 'i2',
    orderId: 'order-123456',
    productId: 'p2',
    productName: 'Creatine',
    unitPrice: 50.0,
    quantity: 1,
    subtotal: 50.0,
  ),
];

OrderEntity _order({String status = 'shipped', String paymentStatus = 'paid'}) => OrderEntity(
      id: 'order-123456',
      userId: 'u1',
      addressId: 'a1',
      status: status,
      paymentStatus: paymentStatus,
      subtotal: 250.0,
      shippingCost: 20.0,
      totalAmount: 270.0,
      orderDate: DateTime(2026, 10, 1, 14, 30),
      items: _items,
    );

void main() {
  testWidgets('OrderCard shows short id, status, first item and total', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      _wrap(Scaffold(body: OrderCard(order: _order(), onTap: () => tapped = true))),
    );

    expect(find.text('#order-'), findsOneWidget);
    expect(find.text('Shipped'), findsOneWidget);
    expect(find.text('Whey Isolate'), findsOneWidget);
    expect(find.text('LE 270.00'), findsOneWidget);

    await tester.tap(find.text('Whey Isolate'));
    expect(tapped, isTrue);
  });

  testWidgets('OrderDetailsView renders tracker, items and payment summary', (tester) async {
    await tester.pumpWidget(_wrap(OrderDetailsView(order: _order(paymentStatus: 'pending'))));

    expect(tester.takeException(), isNull);
    expect(find.text('Whey Isolate'), findsOneWidget);
    expect(find.text('Chocolate'), findsOneWidget);
    expect(find.text('2 × LE 100.00'), findsOneWidget);
    expect(find.text('Cash on Delivery'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('LE 270.00'), 200);
    expect(find.text('LE 270.00'), findsOneWidget);
  });

  testWidgets('OrderDetailsView shows the cancelled notice for cancelled orders', (tester) async {
    await tester.pumpWidget(_wrap(OrderDetailsView(order: _order(status: 'cancelled'))));

    expect(find.byIcon(Icons.cancel), findsOneWidget);
  });
}
