import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:meal_mate/core/theme/app_colors.dart';

class MenutitleWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  const MenutitleWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: .all(16.r),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryColor),
            SizedBox(width: 8.w),
            Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                Text(subtitle),
              ],
            ),
            Spacer(),
            Icon(Icons.chevron_right, color: AppColors.primaryColor),
          ],
        ),
      ),
    );
  }
}
