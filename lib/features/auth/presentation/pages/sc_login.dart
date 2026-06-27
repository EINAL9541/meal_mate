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

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailState = useState<String?>(null);
    final passwordState = useState<String?>(null);

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

    onEmailChange(String value) {
      emailState.value = value;
    }

    onPasswordChange(String value) {
      passwordState.value = value;
    }

    onLogin() async {
      await ref
          .read(authControllerProvider.notifier)
          .login(emailState.value!.trim(), passwordState.value!, "user");
    }

    onRegister() {
      context.push('/register');
    }

    onAdminPortal() {
      context.push('/admin-login');
    }

    isValid() {
      final email = emailState.value;
      final password = passwordState.value;

      final isEmailValid = email != null && email.isNotEmpty;
      final isPasswordValid = password != null && password.isNotEmpty;

      return isEmailValid && isPasswordValid && !authState.isLoading;
    }

    return Scaffold(
      body: Column(
        mainAxisSize: .max,
        children: [
          LoginHeaderWidget(
            title: "Welcome Back",
            subTitle: "Sign in to continue ordering",
          ),
          Expanded(
            child: Padding(
              padding: .all(20.r),
              child: Column(
                mainAxisSize: .min,
                spacing: 10.h,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        spacing: 20.h,
                        children: [
                          TitleAndTextFieldWidget(
                            title: RequiredTitleWidget(title: "EMAIL"),
                            hint: "Enter your email",
                            textInputType: .emailAddress,
                            onChange: onEmailChange,
                          ),
                          TitleAndTextFieldWidget(
                            title: RequiredTitleWidget(title: "PASSWORD"),
                            hint: "Enter your Password",
                            obscureText: true,
                            onChange: onPasswordChange,
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
                              label: 'Login',
                              isValid: isValid(),
                              onPressed: onLogin,
                            ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Row(
                      spacing: 6.w,
                      mainAxisAlignment: .center,
                      children: [
                        Text(
                          "Don't have an account?",
                          style: AppTextStyle.scanText,
                        ),
                        InkWell(
                          onTap: onRegister,
                          child: Text(
                            "Register",
                            style: AppTextStyle.primaryText.copyWith(
                              fontWeight: .w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SafeArea(
                    top: false,
                    child: Center(
                      child: InkWell(
                        onTap: onAdminPortal,
                        child: Row(
                          spacing: 6.w,
                          mainAxisAlignment: .center,
                          children: [
                            Text(
                              "Admin Portal",
                              style: AppTextStyle.inputTitle,
                            ),
                            Icon(
                              Icons.arrow_right_alt_sharp,
                              color: AppColors.primaryColor,
                            ),
                          ],
                        ),
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
