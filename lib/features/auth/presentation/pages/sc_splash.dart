import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meal_mate/core/theme/app_colors.dart';
import '../controller/auth_controller.dart';

class SplashScreen extends HookConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    useEffect(() {
      if (authState.isLoading) return null;

      final timer = Timer(const Duration(milliseconds: 1500), () {
        if (!context.mounted) return;
        authState.whenOrNull(
          data: (user) => context.go(user != null
              ? (user.role == 'admin' ? '/admin/dashboard' : '/home')
              : '/login'),
          error: (error, stackTrace) => context.go('/login'),
        );
      });
      return timer.cancel;
    }, [authState.isLoading]);

    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96.h,
              height: 96.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.baseWhite,
                borderRadius: BorderRadius.circular(28.r),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 28,
                    offset: Offset(0, 16),
                  ),
                ],
              ),
              child: const Text('🍽️', style: TextStyle(fontSize: 44)),
            ),
            SizedBox(height: 20.h),
            Text(
              'MealMate',
              style: TextStyle(
                color: AppColors.baseWhite,
                fontSize: 38.sp,
                fontWeight: FontWeight.w900,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Delicious food, delivered fast',
              style: TextStyle(
                color: AppColors.baseWhite.withValues(alpha: .72),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
