import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meal_mate/core/theme/app_colors.dart';
import 'package:meal_mate/core/widgets/wd_app_bar.dart';

import '../../../../core/widgets/wd_food_image.dart';
import '../../../../core/widgets/wd_status_badge.dart';
import '../controller/orders_controller.dart';

class OrderHistoryScreen extends ConsumerWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(userOrdersProvider);

    return Scaffold(
      appBar: AppBarWidget(title: "Orders"),
      body: orders.isEmpty
          ? const Center(child: Text('No orders yet'))
          : ListView.separated(
              padding: .all(20.r),
              itemCount: orders.length,
              separatorBuilder: (_, _) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                final order = orders[index];
                final count = order.items.fold<int>(
                  0,
                  (total, item) => total + item.quantity,
                );
                return Card(
                  child: Column(
                    crossAxisAlignment: .start,
                    children: [
                      Padding(
                        padding: .all(16.r),
                        child: Column(
                          crossAxisAlignment: .start,
                          children: [
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: .start,
                                  children: [
                                    Text(
                                      order.id,
                                      style: TextStyle(
                                        fontWeight: .w900,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                    Text(
                                      order.date,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                StatusBadgeWidget(status: order.status),
                              ],
                            ),
                            SizedBox(height: 14.h),
                            Row(
                              children: [
                                for (final item in order.items.take(3))
                                  Padding(
                                    padding: .only(right: 8.w),
                                    child: FoodImageWidget(
                                      imageId: item.meal.imageId,
                                      label: item.meal.name,
                                      width: 42.h,
                                      height: 42.h,
                                      borderRadius: .circular(12),
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              order.items
                                  .map((item) => item.meal.name)
                                  .join(', '),
                              maxLines: 2,
                              overflow: .ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: .symmetric(horizontal: 16.w, vertical: 12.h),
                        decoration: const BoxDecoration(
                          color: Color(0xfff8fafc),
                          border: Border(
                            top: BorderSide(color: Color(0xffe5e7eb)),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text('$count item${count == 1 ? '' : 's'}'),
                            const Spacer(),
                            Text(
                              '\$${order.total.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: AppColors.primaryColor,
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
