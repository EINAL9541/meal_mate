import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meal_mate/core/theme/app_colors.dart';
import 'package:meal_mate/core/widgets/wd_app_bar.dart';
import 'package:meal_mate/features/cart/presentation/widget/wd_summary_row.dart';

import '../../../../core/widgets/wd_food_image.dart';
import '../../../../core/widgets/button/primary_button.dart';
import '../controller/cart_controller.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartControllerProvider);
    final subtotal = ref.watch(cartTotalProvider);
    final delivery = cart.isEmpty ? 0.0 : 2.99;
    final total = subtotal + delivery;

    onCheckout() {
      context.push('/checkout');
    }

    return Scaffold(
      appBar: AppBarWidget(title: "Cart"),
      body: cart.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🛒', style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 12),
                  const Text(
                    'Your cart is empty',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: () => context.go('/home'),
                    child: const Text('Browse Meals'),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 220),
              itemCount: cart.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = cart[index];
                return Card(
                  child: Padding(
                    padding: EdgeInsets.all(12.r),
                    child: Row(
                      children: [
                        FoodImageWidget(
                          imageId: item.meal.imageId,
                          label: item.meal.name,
                          width: 72,
                          height: 72,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.meal.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                '\$${item.meal.price.toStringAsFixed(2)} each',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              Text(
                                '\$${(item.meal.price * item.quantity).toStringAsFixed(2)}',
                                style: TextStyle(
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            IconButton(
                              onPressed: () => ref
                                  .read(cartControllerProvider.notifier)
                                  .remove(item.meal.id),
                              icon: const Icon(Icons.close),
                            ),
                            Row(
                              children: [
                                IconButton.outlined(
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () => ref
                                      .read(cartControllerProvider.notifier)
                                      .updateQuantity(
                                        item.meal.id,
                                        item.quantity - 1,
                                      ),
                                  icon: const Icon(Icons.remove),
                                ),
                                SizedBox(
                                  width: 24,
                                  child: Center(
                                    child: Text(
                                      '${item.quantity}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton.filled(
                                  visualDensity: VisualDensity.compact,
                                  onPressed: () => ref
                                      .read(cartControllerProvider.notifier)
                                      .updateQuantity(
                                        item.meal.id,
                                        item.quantity + 1,
                                      ),
                                  icon: const Icon(Icons.add),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      bottomSheet: cart.isEmpty
          ? null
          : SafeArea(
              child: Container(
                padding: .all(20.r),
                decoration: BoxDecoration(
                  color: AppColors.baseWhite,
                  border: Border(top: BorderSide(color: Color(0xffe5e7eb))),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SummaryRowWidget(label: 'Subtotal', value: subtotal),
                    SummaryRowWidget(label: 'Delivery fee', value: delivery),
                    Divider(height: 24.h),
                    SummaryRowWidget(label: 'Total', value: total, large: true),
                    SizedBox(height: 14.h),
                    PrimaryButton(
                      label: 'Proceed to Checkout',
                      onPressed: onCheckout
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

