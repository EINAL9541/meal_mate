import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meal_mate/core/error/failures.dart';
import 'package:meal_mate/core/error/failures_handler.dart';
import 'package:meal_mate/core/theme/app_colors.dart';
import 'package:meal_mate/core/theme/app_text_style.dart';
import 'package:meal_mate/core/widgets/input/wd_title_and_text_field.dart';
import 'package:meal_mate/core/widgets/wd_required_title.dart';
import 'package:meal_mate/features/auth/presentation/widget/wd_login_header.dart';
import 'package:meal_mate/features/auth/domain/entity/user.dart';
import 'package:meal_mate/features/auth/presentation/controller/auth_controller.dart';

import '../../../../core/widgets/button/primary_button.dart';

class RegisterScreen extends HookConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fullNameState = useState<String?>(null);
    final emailState = useState<String?>(null);
    final passwordState = useState<String?>(null);
    final roleState = useState<String>('user');

    final authState = ref.watch(authControllerProvider);

    ref.listen<AsyncValue<User?>>(authControllerProvider, (previous, next) {
      next.whenOrNull(
        data: (user) {
          if (user != null) {
            if (user.role == 'admin') {
              context.go('/admin/dashboard');
            } else {
              context.go('/home');
            }
          }
        },
        error: (error, _) {
          if (error is Failure) {
            FailuresHandler.show(context, error);
          }
        },
      );
    });

    onFullNameChange(String value) {
      fullNameState.value = value;
    }

    onEmailChange(String value) {
      emailState.value = value;
    }

    onPasswordChange(String value) {
      passwordState.value = value;
    }

    isValid() {
      final fullName = fullNameState.value;
      final email = emailState.value;
      final password = passwordState.value;

      final isFullNameValid = fullName != null && fullName.isNotEmpty;
      final isEmailValid = email != null && email.isNotEmpty;
      final isPasswordValid = password != null && password.isNotEmpty;

      return isFullNameValid &&
          isEmailValid &&
          isPasswordValid &&
          !authState.isLoading;
    }

    onLogin() {
      context.pop();
    }

    onRegister() async {
      await ref
          .read(authControllerProvider.notifier)
          .register(
            fullNameState.value!.trim(),
            emailState.value!.trim(),
            passwordState.value!,
            roleState.value,
          );
    }

    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          LoginHeaderWidget(
            title: "Create Account",
            subTitle: "Join MealMate today",
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20.r),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 10.h,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        spacing: 20.h,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitleAndTextFieldWidget(
                            title: const RequiredTitleWidget(
                              title: "FULL NAME",
                            ),
                            hint: "Enter your full name",
                            onChange: onFullNameChange,
                          ),
                          TitleAndTextFieldWidget(
                            title: const RequiredTitleWidget(title: "EMAIL"),
                            hint: "Enter your email",
                            textInputType: TextInputType.emailAddress,
                            onChange: onEmailChange,
                          ),
                          TitleAndTextFieldWidget(
                            title: const RequiredTitleWidget(title: "PASSWORD"),
                            hint: "Enter your password",
                            obscureText: true,
                            onChange: onPasswordChange,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 8.h,
                            children: [
                              const RequiredTitleWidget(title: "SELECT ROLE"),
                              Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => roleState.value = 'user',
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 12.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: roleState.value == 'user'
                                              ? AppColors.primaryColor
                                              : AppColors.muted,
                                          borderRadius: BorderRadius.circular(
                                            12.r,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          'User',
                                          style: TextStyle(
                                            color: roleState.value == 'user'
                                                ? AppColors.baseWhite
                                                : Colors.black87,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => roleState.value = 'admin',
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 12.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: roleState.value == 'admin'
                                              ? AppColors.primaryColor
                                              : AppColors.muted,
                                          borderRadius: BorderRadius.circular(
                                            12.r,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          'Admin',
                                          style: TextStyle(
                                            color: roleState.value == 'admin'
                                                ? AppColors.baseWhite
                                                : Colors.black87,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          if (authState.isLoading)
                            Center(
                              child: CircularProgressIndicator(
                                color: AppColors.primaryColor,
                              ),
                            )
                          else
                            PrimaryButton(
                              label: 'Register',
                              isValid: isValid(),
                              onPressed: onRegister,
                            ),
                        ],
                      ),
                    ),
                  ),
                  SafeArea(
                    top: false,
                    child: Center(
                      child: Row(
                        spacing: 6.w,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?",
                            style: AppTextStyle.scanText,
                          ),
                          InkWell(
                            onTap: onLogin,
                            child: Text(
                              "Login",
                              style: AppTextStyle.primaryText.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
