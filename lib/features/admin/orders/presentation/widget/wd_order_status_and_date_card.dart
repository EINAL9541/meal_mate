import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:meal_mate/core/widgets/wd_status_badge.dart';
import 'package:meal_mate/features/orders/domain/entity/order.dart';

class OrderStatusAndDateCardWidget extends StatelessWidget {
  final OrderStatus status;
  final String date;
  const OrderStatusAndDateCardWidget({
    super.key,
    required this.status,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: .all(16.r),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: .start,
              children: [
                const Text(
                  'Current Status',
                  style: TextStyle(color: Color(0xff94a3b8), fontWeight: .w900),
                ),
                SizedBox(height: 8.h),
                StatusBadgeWidget(status: status),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: .end,
              children: [
                const Text(
                  'Order Date',
                  style: TextStyle(
                    color: Color(0xff94a3b8),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(date, style: const TextStyle(fontWeight: .w900)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
