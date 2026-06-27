import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:meal_mate/core/theme/app_colors.dart';
import 'package:meal_mate/core/widgets/wd_admin_order_card.dart';
import 'package:meal_mate/features/orders/domain/entity/order.dart';

class RecentOrdersWidget extends StatelessWidget {
  final List<Order> orders;
  const RecentOrdersWidget({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    onViewAll() {
      context.go('/admin/orders');
    }

    onViewDetails(String id) {
      context.push('/admin/orders/$id');
    }

    return Column(
      mainAxisSize: .min,
      children: [
        Row(
          children: [
            Text(
              'Recent Orders',
              style: TextStyle(
                color: const Color(0xff1e293b),
                fontSize: 16.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: onViewAll,
              style: TextButton.styleFrom(foregroundColor: AppColors.adminBlue),
              child: const Text('View All'),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        for (final order in orders.take(4)) ...[
          AdminOrderCardWidget(
            order: order,
            onTap: () => onViewDetails(order.id),
          ),
          SizedBox(height: 10.h),
        ],
      ],
    );
  }
}
