import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:stronger_muscles/features/order/data/models/order_model.dart';

void main() {
  group('OrderModel Tests', () {
    final testDate = DateTime(2025, 5, 20);

    final baseOrder = OrderModel(
      id: 'order-101',
      userId: 'user-001',
      orderDate: testDate,
      addressId: 'addr-01',
      subtotal: 350.0,
      totalAmount: 370.0,
      shippingCost: 20.0,
      discount: 0.0,
      status: 'pending',
      paymentStatus: 'pending',
    );

    test('computed properties return correct flags based on order status', () {
      expect(baseOrder.canBeCancelled, isTrue);
      expect(baseOrder.isCompleted, isFalse);
      expect(baseOrder.isPaid, isFalse);

      final processingOrder = baseOrder.copyWith(status: 'processing');
      expect(processingOrder.canBeCancelled, isTrue);
      expect(processingOrder.isCompleted, isFalse);

      final deliveredOrder = baseOrder.copyWith(
        status: 'delivered',
        paymentStatus: 'paid',
      );
      expect(deliveredOrder.canBeCancelled, isFalse);
      expect(deliveredOrder.isCompleted, isTrue);
      expect(deliveredOrder.isPaid, isTrue);

      final cancelledOrder = baseOrder.copyWith(status: 'cancelled');
      expect(cancelledOrder.canBeCancelled, isFalse);
      expect(cancelledOrder.isCompleted, isFalse);
    });

    test('formattedDate formats date correctly or returns empty string when null', () {
      expect(baseOrder.formattedDate, DateFormat('d MMMM yyyy').format(testDate));

      final orderWithoutDate = baseOrder.copyWith(orderDate: null);
      expect(orderWithoutDate.formattedDate, isEmpty);
    });

    test('fromJson and toJson maintain data integrity', () {
      final json = {
        'id': 'order-202',
        'user_id': 'user-002',
        'address_id': 'addr-02',
        'subtotal': 500.0,
        'shippingCost': 15.0,
        'discount': 50.0,
        'total_amount': 465.0,
        'status': 'processing',
        'payment_status': 'paid',
        'payment_method': 'credit_card',
        'tracking_number': 'TRK-9999',
        'order_items': [
          {
            'id': 'item-1',
            'order_id': 'order-202',
            'product_id': 'prod-1',
            'product_name': 'Creatine 300g',
            'unit_price': 150.0,
            'quantity': 2,
            'subtotal': 300.0,
            'selected_flavor': 'Fruit Punch',
          }
        ],
      };

      final order = OrderModel.fromJson(json);

      expect(order.id, 'order-202');
      expect(order.userId, 'user-002');
      expect(order.status, 'processing');
      expect(order.isPaid, isTrue);
      expect(order.canBeCancelled, isTrue);
      expect(order.trackingNumber, 'TRK-9999');
      expect(order.items, isNotNull);
      expect(order.items!.length, 1);
      expect(order.items!.first.productName, 'Creatine 300g');
      expect(order.items!.first.unitPrice, 150.0);
      expect(order.items!.first.price, 150.0);
      expect(order.items!.first.selectedFlavor, 'Fruit Punch');

      final serialized = order.toJson();
      expect(serialized['id'], 'order-202');
      expect(serialized['user_id'], 'user-002');
      expect(serialized['total_amount'], 465.0);
    });
  });

  group('OrderItemModel Tests', () {
    test('price getter delegates to unitPrice', () {
      const item = OrderItemModel(
        id: 'item-1',
        orderId: 'order-1',
        productId: 'prod-1',
        productName: 'Iso Whey',
        unitPrice: 125.0,
        quantity: 1,
        subtotal: 125.0,
      );

      expect(item.price, 125.0);
    });
  });
}
