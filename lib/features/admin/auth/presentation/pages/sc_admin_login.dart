import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meal_mate/core/theme/app_colors.dart';
import 'package:meal_mate/features/admin/auth/presentation/widget/wd_account_demo.dart';
import 'package:meal_mate/features/admin/auth/presentation/widget/wd_admin_login_header.dart';
import 'package:meal_mate/features/admin/auth/presentation/widget/wd_admin_text_field.dart';

import '../../../../auth/presentation/controller/auth_controller.dart';

class AdminLoginScreen extends HookConsumerWidget {
  const AdminLoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final email = useState('');
    final password = useState('');
    final error = useState<String?>(null);
    final authState = ref.watch(authControllerProvider);

    onLogin() async {
      error.value = null;
      try {
        await ref
            .read(authControllerProvider.notifier)
            .login(email.value.trim(), password.value, "admin");
        final user = ref.read(authControllerProvider).value;
        if (user != null) {
          if (user.role == 'admin') {
            if (context.mounted) {
              context.go('/admin/dashboard');
            }
          } else {
            await ref.read(authControllerProvider.notifier).logout();
            error.value = 'Access denied. Only admin users can log in.';
          }
        }
      } catch (e) {
        error.value = e.toString().replaceAll('Exception: ', '');
      }
    }

    return Scaffold(
      backgroundColor: AppColors.adminBackground,
      body: Column(
        children: [
          AdminLoginHeaderWidget(),
          Expanded(
            child: SingleChildScrollView(
              padding: .fromLTRB(20.w, 0, 20.w, 24.h),
              child: Transform.translate(
                offset: Offset(0, -22.h),
                child: Card(
                  child: Padding(
                    padding: .all(20.r),
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        if (error.value != null) ...[
                          Container(
                            padding: .all(12.r),
                            decoration: BoxDecoration(
                              color: const Color(0xfffef2f2),
                              borderRadius: BorderRadius.circular(14.r),
                              border: Border.all(
                                color: const Color(0xfffecaca),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  color: Color(0xffdc2626),
                                ),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: Text(
                                    error.value!,
                                    style: const TextStyle(
                                      color: Color(0xffdc2626),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 18.h),
                        ],
                        AdminTextFieldWidget(
                          label: 'ADMIN EMAIL',
                          hint: 'admin@mealmate.com',
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) => email.value = value,
                        ),
                        SizedBox(height: 16.h),
                        AdminTextFieldWidget(
                          label: 'PASSWORD',
                          hint: 'Enter admin password',
                          obscureText: true,
                          onChanged: (value) => password.value = value,
                        ),
                        SizedBox(height: 12.h),
                        ElevatedButton(
                          onPressed: authState.isLoading ? null : onLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.adminBlue,
                            foregroundColor: AppColors.baseWhite,
                            minimumSize: Size.fromHeight(52.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: .circular(16.r),
                            ),
                          ),
                          child: authState.isLoading
                              ? SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: AppColors.baseWhite,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Sign In to Admin'),
                        ),
                        SizedBox(height: 16.h),
                        AccountDemoWidget()
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


