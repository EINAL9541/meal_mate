import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:meal_mate/core/theme/app_colors.dart';

class StatCardWidget extends StatelessWidget {
  const StatCardWidget({
    required this.label,
    required this.value,
    required this.icon,
    super.key
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: AppColors.primary200,
      child: Padding(
        padding: .all(12.r),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primaryColor),
            SizedBox(height: 6.h),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}
