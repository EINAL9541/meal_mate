import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:meal_mate/core/theme/app_colors.dart';
import 'package:meal_mate/core/theme/app_text_style.dart';

class DiscountCardWidget extends StatelessWidget {
  const DiscountCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .all(20.r),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: .circular(24.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  'LIMITED TIME',
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: .w900,
                    fontSize: 11.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  '20% Off\nYour First Order',
                  style: TextStyle(
                    color: AppColors.baseWhite,
                    fontSize: 21.sp,
                    fontWeight: .w900,
                  ),
                ),
                SizedBox(height: 10.h),
                Chip(label: Text('WELCOME20', style: AppTextStyle.primaryText,)),
              ],
            ),
          ),
          Text('🎉', style: TextStyle(fontSize: 54.sp)),
        ],
      ),
    );
  }
}
