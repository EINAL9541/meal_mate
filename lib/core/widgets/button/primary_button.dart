import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:meal_mate/core/theme/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final bool isValid;
  final VoidCallback? onPressed;

  const PrimaryButton({
    required this.label,
    this.isValid = true,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isValid ? onPressed : () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: isValid
            ? AppColors.primaryColor
            : AppColors.primary200,
        foregroundColor: AppColors.baseWhite,
        minimumSize: Size.fromHeight(52.r),
        shape: RoundedRectangleBorder(borderRadius: .circular(16.r)),
        textStyle: TextStyle(fontWeight: FontWeight.w800, fontSize: 14.sp),
      ),
      child: Text(label),
    );
  }
}
