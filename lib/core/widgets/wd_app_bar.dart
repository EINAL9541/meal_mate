import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:meal_mate/core/theme/app_colors.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onLeadingPressed;

  const AppBarWidget({super.key, required this.title, this.onLeadingPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryColor,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        bottom: 20.h,
      ),
      child: Row(
        children: [
          null != onLeadingPressed
              ? IconButton(
                  icon: Icon(Icons.arrow_back, color: AppColors.baseWhite),
                  onPressed: onLeadingPressed,
                )
              : SizedBox(width: 48.w),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.baseWhite,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 48.w),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
