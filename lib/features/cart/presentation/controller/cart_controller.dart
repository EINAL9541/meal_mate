import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../home/domain/entities/meal.dart';
import '../../domain/entity/cart_item.dart';

final cartControllerProvider = NotifierProvider<CartController, List<CartItem>>(
  CartController.new,
);

final cartTotalProvider = Provider<double>((ref) {
  return ref
      .watch(cartControllerProvider)
      .fold(0, (total, item) => total + item.meal.price * item.quantity);
});

final cartCountProvider = Provider<int>((ref) {
  return ref
      .watch(cartControllerProvider)
      .fold(0, (total, item) => total + item.quantity);
});

class CartController extends Notifier<List<CartItem>> {
  @override
  List<CartItem> build() => [];

  void add(Meal meal, {int quantity = 1}) {
    final index = state.indexWhere((item) => item.meal.id == meal.id);
    if (index == -1) {
      state = [...state, CartItem(meal: meal, quantity: quantity)];
      return;
    }

    state = [
      for (final item in state)
        if (item.meal.id == meal.id)
          item.copyWith(quantity: item.quantity + quantity)
        else
          item,
    ];
  }

  void updateQuantity(String mealId, int quantity) {
    if (quantity <= 0) {
      remove(mealId);
      return;
    }

    state = [
      for (final item in state)
        if (item.meal.id == mealId) item.copyWith(quantity: quantity) else item,
    ];
  }

  void remove(String mealId) {
    state = state.where((item) => item.meal.id != mealId).toList();
  }

  void clear() {
    state = [];
  }
}
