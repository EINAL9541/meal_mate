import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:meal_mate/core/theme/app_colors.dart';



class AdminAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AdminAppBarWidget({
    required this.title,
    this.onBack,
    this.onProfile,
    super.key,
  });

  final String title;
  final VoidCallback? onBack;
  final VoidCallback? onProfile;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.from(alpha: 1, red: 1, green: 1, blue: 1),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 16.w,
        right: 16.w,
        bottom: 12.h,
      ),
      child: Row(
        children: [
          if (onBack != null)
            IconButton.filledTonal(
              onPressed: onBack,
              icon: const Icon(Icons.arrow_back),
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xfff1f5f9),
                foregroundColor: const Color(0xff334155),
              ),
            )
          else
            Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                color: AppColors.adminBlue,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Center(
                child: Text(
                  'M',
                  style: TextStyle(
                    color: AppColors.baseWhite,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: const Color(0xff1e293b),
                fontSize: 20.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          IconButton.filledTonal(
            onPressed: () {},
            icon: const Icon(Icons.notifications_none),
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xfff1f5f9),
              foregroundColor: const Color(0xff475569),
            ),
          ),
          if (onProfile != null) ...[
            SizedBox(width: 6.w),
            IconButton.filledTonal(
              onPressed: onProfile,
              icon: Icon(Icons.person_outline),
              style: IconButton.styleFrom(
                backgroundColor: const Color(0xffeff6ff),
                foregroundColor: AppColors.adminBlue,
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(88.h);
}
