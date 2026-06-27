import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:meal_mate/core/theme/app_colors.dart';

class TitleAndTextFieldWidget extends HookWidget {
  final Widget? title;
  final String hint;
  final TextInputType textInputType;
  final Function(String) onChange;
  final bool obscureText;

  const TitleAndTextFieldWidget({
    super.key,
    this.title,
    required this.hint,
    this.textInputType = .text,
    required this.onChange,
    this.obscureText = false
  });

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();

    return Column(
      spacing: 6.h,
      children: [
        ?title,
        TextField(
          controller: controller,
          onChanged: onChange,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: .circular(12.r),
              borderSide: .none,
            ),
            filled: true,
            fillColor: AppColors.muted,
            contentPadding: .symmetric(horizontal: 16.w, vertical: 14.h),
            hintText: hint,
          ),
          keyboardType: textInputType,
          obscureText: obscureText,
        ),
      ],
    );
  }
}
