import '../../data/models/order_model.dart';

class OrderRepository {
  Future<void> createOrder(OrderModel order) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));
    
    // In a real app, this would make an API call to your backend
    // e.g., await _apiProvider.post('/orders', order.toJson());
    
    print('Order created: ${order.id}');
  }
}
