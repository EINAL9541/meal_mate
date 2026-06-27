import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:meal_mate/core/theme/app_colors.dart';

class AdminLoginHeaderWidget extends StatelessWidget {
  const AdminLoginHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: .only(
        top: MediaQuery.of(context).padding.top + 12.h,
        left: 20.w,
        right: 20.w,
        bottom: 38.h,
      ),
      decoration: const BoxDecoration(color: AppColors.adminBlue),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Container(
            width: 58.r,
            height: 58.r,
            decoration: BoxDecoration(
              color: AppColors.baseWhite,
              borderRadius: .circular(18.r),
            ),
            child: Icon(
              Icons.restaurant_menu,
              color: AppColors.adminBlue,
              size: 30.r,
            ),
          ),
          SizedBox(height: 14.h),
          Text(
            'MealMate Admin',
            style: TextStyle(
              color: AppColors.baseWhite,
              fontSize: 28.sp,
              fontWeight: .w900,
            ),
          ),
          Text(
            'Restricted access - admin only',
            style: TextStyle(
              color: const Color(0xffbfdbfe),
              fontSize: 14.sp,
              fontWeight: .w600,
            ),
          ),
        ],
      ),
    );
  }
}
