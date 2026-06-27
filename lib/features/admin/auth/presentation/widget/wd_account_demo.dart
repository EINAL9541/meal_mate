import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

class AccountDemoWidget extends StatelessWidget {
  const AccountDemoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: .all(12.r),
      decoration: BoxDecoration(
        color: const Color(0xfff8fafc),
        borderRadius: .circular(14.r),
        border: .all(color: const Color(0xffe2e8f0)),
      ),
      child: const Column(
        children: [
          Text(
            'Demo credentials',
            style: TextStyle(
              color: Color(0xff94a3b8),
              fontWeight: .w700,
            ),
          ),
          Text(
            'admin@mealmate.com / admin123',
            style: TextStyle(
              color: Color(0xff64748b),
              fontWeight: .w800,
            ),
          ),
        ],
      ),
    );
  }
}
