import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:meal_mate/core/theme/app_colors.dart';

class AppTextStyle {
  static TextStyle get titleWhite {
    return TextStyle(
      color: AppColors.baseWhite,
      fontSize: 24.sp,
      fontWeight: .w900,
    );
  }

  static TextStyle get inputTitle {
    return TextStyle(
      color: AppColors.baseBlack,
      fontSize: 14.sp,
      fontWeight: .w500,
    );
  }

  static TextStyle get errorTitle {
    return TextStyle(
      color: AppColors.error,
      fontSize: 14.sp,
      fontWeight: .w500,
    );
  }

  static TextStyle get scanText {
    return TextStyle(
      color: AppColors.scanTextColor,
      fontSize: 14.sp,
      fontWeight: .w400,
    );
  }

  static TextStyle get primaryText {
    return TextStyle(
      color: AppColors.primaryColor,
      fontSize: 14.sp,
      fontWeight: .w500,
    );
  }

  static TextStyle get primarySmallText {
    return TextStyle(
      color: AppColors.primaryColor,
      fontSize: 12.sp,
      fontWeight: .w500,
    );
  }
}
