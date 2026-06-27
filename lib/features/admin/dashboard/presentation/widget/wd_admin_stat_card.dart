import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class AdminStatCardWidget extends StatelessWidget {
  const AdminStatCardWidget({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.trend,
    super.key,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String? trend;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(14.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38.r,
              height: 38.r,
              decoration: BoxDecoration(
                color: color.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: color, size: 20.r),
            ),
            SizedBox(height: 12.h),
            Text(
              value,
              style: TextStyle(
                color: const Color(0xff1e293b),
                fontSize: 24.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyle(
                color: const Color(0xff64748b),
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (trend != null) ...[
              SizedBox(height: 6.h),
              Text(
                trend!,
                style: TextStyle(
                  color: const Color(0xff16a34a),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
