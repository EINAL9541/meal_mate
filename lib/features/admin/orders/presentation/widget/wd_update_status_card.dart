import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:meal_mate/core/theme/app_colors.dart';
import 'package:meal_mate/features/orders/domain/entity/order.dart';

class UpdateStatusCardWidget extends StatelessWidget {
  final Order order;
  final OrderStatus selectedStatus;
  final Function(OrderStatus) onSelectedStatuschange;
  final VoidCallback onPressed;
  const UpdateStatusCardWidget({
    super.key,
    required this.order,
    required this.selectedStatus,
    required this.onSelectedStatuschange,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: .all(16.r),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            const Text(
              'UPDATE STATUS',
              style: TextStyle(color: Color(0xff94a3b8), fontWeight: .w900),
            ),
            SizedBox(height: 12.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: [
                for (final status in OrderStatus.values)
                  ChoiceChip(
                    selected: selectedStatus == status,
                    showCheckmark: false,
                    side: BorderSide(color: AppColors.adminBlue, width: 1),

                    selectedColor: AppColors.adminBlue,
                    label: Text(
                      status.label,
                      style: TextStyle(
                        color: selectedStatus == status
                            ? AppColors.baseWhite
                            : AppColors.adminBlue,
                      ),
                    ),
                    onSelected: (_) => onSelectedStatuschange(status),
                  ),
              ],
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: selectedStatus == order.status ? null : onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff1d4ed8),
                foregroundColor: AppColors.baseWhite,
                minimumSize: Size.fromHeight(52.h),
              ),
              child: Text(
                selectedStatus == order.status
                    ? 'No Changes'
                    : 'Set to ${selectedStatus.label}',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
