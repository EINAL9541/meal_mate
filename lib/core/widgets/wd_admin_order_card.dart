import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import 'wd_status_badge.dart';
import '../../features/orders/domain/entity/order.dart';

class AdminOrderCardWidget extends StatelessWidget {
  const AdminOrderCardWidget({
    required this.order,
    required this.onTap,
    super.key,
  });

  final Order order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final count = order.items.fold<int>(
      0,
      (total, item) => total + item.quantity,
    );

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.all(14.r),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.id,
                          style: TextStyle(
                            color: const Color(0xff1e293b),
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          order.userName,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  StatusBadgeWidget(status: order.status),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 14.r,
                    color: const Color(0xff94a3b8),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    order.date,
                    style: TextStyle(
                      color: const Color(0xff64748b),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '$count item${count == 1 ? '' : 's'}',
                    style: TextStyle(
                      color: const Color(0xff64748b),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    '\$${order.total.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: const Color(0xff1d4ed8),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  const Icon(Icons.chevron_right, color: Color(0xffcbd5e1)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
