import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:meal_mate/core/theme/app_text_style.dart';

class RequiredTitleWidget extends StatelessWidget {
  final String title;
  const RequiredTitleWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 6.w,
      children: [
        Text(title, style: AppTextStyle.inputTitle),
        Text("*", style: AppTextStyle.errorTitle),
      ],
    );
  }
}
