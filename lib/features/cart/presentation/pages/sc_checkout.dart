import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meal_mate/core/widgets/wd_app_bar.dart';
import 'package:meal_mate/features/cart/presentation/widget/wd_check_out_card.dart';
import 'package:meal_mate/features/cart/presentation/widget/wd_price_row.dart';

import '../../../../core/widgets/wd_food_image.dart';
import '../../../../core/widgets/button/primary_button.dart';
import '../../../orders/presentation/controller/orders_controller.dart';
import '../controller/cart_controller.dart';

class CheckoutScreen extends ConsumerWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartControllerProvider);
    final subtotal = ref.watch(cartTotalProvider);
    final total = subtotal + 2.99;

    return Scaffold(
      appBar: AppBarWidget(
        title: "Checkout",
        onLeadingPressed: () => context.pop(),
      ),
      body: ListView(
        padding: .all(20.r),
        children: [
          const CheckoutCardWidget(
            title: 'Delivery Address',
            icon: Icons.location_on,
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  '123 Maple Street, Apt 4B',
                  style: TextStyle(fontWeight: .w800),
                ),
                Text('San Francisco, CA 94102'),
              ],
            ),
          ),
          SizedBox(height: 12.r),
          CheckoutCardWidget(
            title: 'Order Summary',
            icon: Icons.receipt_long,
            child: Column(
              children: [
                for (final item in cart)
                  ListTile(
                    contentPadding: .zero,
                    leading: FoodImageWidget(
                      imageId: item.meal.imageId,
                      label: item.meal.name,
                      width: 44.w,
                      height: 44.h,
                      borderRadius: .circular(12.r),
                    ),
                    title: Text(item.meal.name),
                    subtitle: Text('x${item.quantity}'),
                    trailing: Text(
                      '\$${(item.meal.price * item.quantity).toStringAsFixed(2)}',
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          const CheckoutCardWidget(
            title: 'Payment',
            icon: Icons.credit_card,
            child: ListTile(
              contentPadding: .zero,
              title: Text('Visa •••• 4242'),
              subtitle: Text('Expires 08/28'),
            ),
          ),
          SizedBox(height: 12.h),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  PriceRowWidget(label: 'Subtotal', value: subtotal),
                  PriceRowWidget(label: 'Delivery fee', value: 2.99),
                  Divider(height: 26.h),
                  PriceRowWidget(label: 'Total', value: total, large: true),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: .all(20.r),
        child: PrimaryButton(
          label: 'Place Order · \$${total.toStringAsFixed(2)}',
          onPressed: cart.isEmpty
              ? null
              : () {
                  ref.read(ordersControllerProvider.notifier).placeOrder(cart);
                  ref.read(cartControllerProvider.notifier).clear();
                  context.go('/orders');
                },
        ),
      ),
    );
  }
}

