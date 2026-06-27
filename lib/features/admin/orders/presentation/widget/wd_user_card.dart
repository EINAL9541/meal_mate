import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:meal_mate/core/theme/app_colors.dart';

class UserCardWidget extends StatelessWidget {
  final String userName;
  const UserCardWidget({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: .all(16.r),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color(0xffdbeafe),
              foregroundColor: const Color(0xff1d4ed8),
              child: Text(_initials(userName)),
            ),
            SizedBox(width: 12.w),
            Column(
              crossAxisAlignment: .start,
              mainAxisAlignment: .spaceBetween,
              spacing: 2.h,
              children: [
                Text(
                  userName,
                  style: TextStyle(fontSize: 15.sp, fontWeight: .w900),
                ),
                Container(
                  padding: .symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: AppColors.adminBlue.withValues(alpha: .18),
                    borderRadius: .circular(999),
                  ),
                  child: const Text(
                    'PREMIUM MEMBER',
                    style: TextStyle(
                      color: AppColors.adminBlue,
                      fontSize: 10,
                      fontWeight: .w900,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _initials(String name) {
    return name
        .split(' ')
        .where((part) => part.isNotEmpty)
        .map((part) => part[0])
        .take(2)
        .join();
  }
}
