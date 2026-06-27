import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meal_mate/core/theme/app_colors.dart';
import 'package:meal_mate/features/auth/presentation/controller/auth_controller.dart';

class ProfileAppBarWidget extends ConsumerWidget
    implements PreferredSizeWidget {
  const ProfileAppBarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).value;
    final name = user?.name ?? 'User';
    final email = user?.email ?? '';
    final initials = name.split(' ').where((e) => e.isNotEmpty).map((e) => e[0]).take(2).join().toUpperCase();

    return AppBar(
      toolbarHeight: 140.h,
      backgroundColor: AppColors.primaryColor,
      flexibleSpace: SafeArea(
        child: Padding(
          padding: .fromLTRB(20.w, 20.h, 20.w, 24.h),
          child: Row(
            crossAxisAlignment: .end,
            children: [
              CircleAvatar(
                radius: 34.r,
                child: Text(initials.isEmpty ? 'U' : initials, style: const TextStyle(fontWeight: .w900)),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  mainAxisAlignment: .end,
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: AppColors.baseWhite,
                        fontSize: 20.sp,
                        fontWeight: .w900,
                      ),
                    ),
                    Text(
                      email,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    SizedBox(height: 5.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: .circular(4),
                      ),
                      child: Text(
                        'PREMIUM MEMBER',
                        style: TextStyle(color: AppColors.baseWhite, fontSize: 10.sp),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(140.h);
}
