import 'package:cloud_firestore/cloud_firestore.dart' hide Order;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meal_mate/core/error/failures.dart';

import '../../domain/entity/order.dart';
import '../../domain/repository/order_repository.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  return OrderRepositoryImpl(FirebaseFirestore.instance);
});

class OrderRepositoryImpl implements OrderRepository {
  OrderRepositoryImpl(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _ordersCollection =>
      _firestore.collection('orders');

  @override
  Stream<List<Order>> watchAllOrders() {
    return _ordersCollection.orderBy('date', descending: true).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs
          .map((doc) => Order.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    }).handleError((error) {
      throw DatabaseFailure('Failed to sync orders database: ${error.toString()}');
    });
  }

  @override
  Stream<List<Order>> watchUserOrders(String userId) {
    return _ordersCollection.where('userId', isEqualTo: userId).snapshots().map((
      snapshot,
    ) {
      final orders = snapshot.docs
          .map((doc) => Order.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
      orders.sort((a, b) => b.date.compareTo(a.date));
      return orders;
    }).handleError((error) {
      throw DatabaseFailure('Failed to sync user orders: ${error.toString()}');
    });
  }

  @override
  String createOrderId() {
    final id = _ordersCollection.doc().id.substring(0, 6).toUpperCase();
    return 'ORD-$id';
  }

  @override
  Future<void> placeOrder(Order order) async {
    try {
      await _ordersCollection.doc(order.id).set(order.toJson());
    } catch (e) {
      throw DatabaseFailure('Failed to place order: ${e.toString()}');
    }
  }

  @override
  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    try {
      await _ordersCollection.doc(orderId).update({'status': status.name});
    } catch (e) {
      throw DatabaseFailure('Failed to update order status: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteOrder(String orderId) async {
    try {
      await _ordersCollection.doc(orderId).delete();
    } catch (e) {
      throw DatabaseFailure('Failed to cancel order: ${e.toString()}');
    }
  }
}
