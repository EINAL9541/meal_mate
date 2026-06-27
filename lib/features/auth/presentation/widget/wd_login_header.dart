import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:meal_mate/core/theme/app_colors.dart';
import 'package:meal_mate/core/theme/app_text_style.dart';

class LoginHeaderWidget extends StatelessWidget {
  final String title;
  final String subTitle;
  const LoginHeaderWidget({super.key, required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220.h,
      width: double.infinity,
      alignment: .bottomCenter,
      padding: .only(bottom: 28.h),
      decoration: BoxDecoration(color: AppColors.primaryColor),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 60.h,
            height: 60.h,
            alignment: .center,
            decoration: BoxDecoration(
              color: AppColors.baseWhite,
              borderRadius: .circular(18.r),
            ),
            child: Text('🍽️', style: TextStyle(fontSize: 40.r)),
          ),
          SizedBox(height: 8.h),
          Text('Welcome Back', style: AppTextStyle.titleWhite),
          SizedBox(height: 4.h),
          Text(
            'Sign in to continue ordering',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white70,
              fontWeight: .w600,
            ),
          ),
        ],
      ),
    );
  }
}
