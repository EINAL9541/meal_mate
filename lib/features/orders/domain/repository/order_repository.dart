import '../entity/order.dart';

abstract class OrderRepository {
  Stream<List<Order>> watchAllOrders();
  Stream<List<Order>> watchUserOrders(String userId);
  String createOrderId();
  Future<void> placeOrder(Order order);
  Future<void> updateOrderStatus(String orderId, OrderStatus status);
  Future<void> deleteOrder(String orderId);
}
