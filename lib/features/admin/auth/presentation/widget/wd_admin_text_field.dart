import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class AdminTextFieldWidget extends StatelessWidget {

  final String label;
  final String hint;
  final ValueChanged<String> onChanged;
  final TextInputType? keyboardType;
  final bool obscureText;

  const AdminTextFieldWidget({
    required this.label,
    required this.hint,
    required this.onChanged,
    this.keyboardType,
    this.obscureText = false,
    super.key
  });


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: const Color(0xff475569),
            fontSize: 12.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 8.h),
        TextField(
          keyboardType: keyboardType,
          obscureText: obscureText,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            fillColor: const Color(0xfff8fafc),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: const BorderSide(color: Color(0xffe2e8f0)),
            ),
          ),
        ),
      ],
    );
  }
}