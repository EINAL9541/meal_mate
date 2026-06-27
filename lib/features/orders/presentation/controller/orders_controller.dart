import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../cart/domain/entity/cart_item.dart';
import '../../../auth/presentation/controller/auth_controller.dart';
import '../../data/repositories/order_repository_impl.dart';
import '../../domain/entity/order.dart';

final ordersControllerProvider =
    NotifierProvider<OrdersController, List<Order>>(OrdersController.new);

final userOrdersProvider = Provider<List<Order>>((ref) {
  return ref.watch(ordersControllerProvider);
});

class OrdersController extends Notifier<List<Order>> {
  StreamSubscription<List<Order>>? _subscription;

  @override
  List<Order> build() {
    final authState = ref.watch(authControllerProvider);
    final user = authState.value;
    if (user == null) {
      _subscription?.cancel();
      return [];
    }

    final repo = ref.watch(orderRepositoryProvider);
    final stream = user.role == 'admin'
        ? repo.watchAllOrders()
        : repo.watchUserOrders(user.id);

    _subscription?.cancel();
    _subscription = stream.listen((orders) {
      state = orders;
    });

    ref.onDispose(() {
      _subscription?.cancel();
    });

    return [];
  }

  Future<void> placeOrder(List<CartItem> items) async {
    final user = ref.read(authControllerProvider).value;
    if (user == null) return;

    final subtotal = items.fold<double>(
      0,
      (total, item) => total + item.meal.price * item.quantity,
    );

    final repo = ref.read(orderRepositoryProvider);
    final orderId = repo.createOrderId();

    final order = Order(
      id: orderId,
      userId: user.id,
      date: DateFormat('MMM d, yyyy').format(DateTime.now()),
      items: [...items],
      total: subtotal + 2.99,
      status: OrderStatus.pending,
      userName: user.name,
    );

    await repo.placeOrder(order);
  }

  Future<void> updateStatus(String id, OrderStatus status) async {
    final repo = ref.read(orderRepositoryProvider);
    await repo.updateOrderStatus(id, status);
  }

  Future<void> deleteOrder(String id) async {
    final repo = ref.read(orderRepositoryProvider);
    await repo.deleteOrder(id);
  }
}
