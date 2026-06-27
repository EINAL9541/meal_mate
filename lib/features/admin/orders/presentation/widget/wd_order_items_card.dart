import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:meal_mate/core/theme/app_colors.dart';
import 'package:meal_mate/core/widgets/wd_food_image.dart';
import 'package:meal_mate/features/orders/domain/entity/order.dart';

class OrderItemsCardWidget extends StatelessWidget {
  final Order order;
  const OrderItemsCardWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Card(
            child: Padding(
              padding: .all(16.r),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  const Text(
                    'ORDER ITEMS',
                    style: TextStyle(
                      color: Color(0xff94a3b8),
                      fontWeight: .w900,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  for (final item in order.items) ...[
                    Row(
                      children: [
                        FoodImageWidget(
                          imageId: item.meal.imageId,
                          label: item.meal.name,
                          width: 52.r,
                          height: 52.r,
                          borderRadius: .circular(14.r),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: .start,
                            children: [
                              Text(
                                item.meal.name,
                                maxLines: 1,
                                overflow: .ellipsis,
                                style: const TextStyle(
                                  fontWeight: .w900,
                                ),
                              ),
                              Text(
                                'x${item.quantity} - \$${item.meal.price.toStringAsFixed(2)} each',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '\$${(item.meal.price * item.quantity).toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: .w900),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                  ],
                  Divider(color: AppColors.gray50),
                  Row(
                    children: [
                      const Text(
                        'Total Amount',
                        style: TextStyle(fontWeight: .w900),
                      ),
                      const Spacer(),
                      Text(
                        '\$${order.total.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: const Color(0xff1d4ed8),
                          fontSize: 18.sp,
                          fontWeight: .w900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}