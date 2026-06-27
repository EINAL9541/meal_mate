import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:meal_mate/core/theme/app_colors.dart';

class AdminMenuTileWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  
  const AdminMenuTileWidget({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 38.r,
        height: 38.r,
        decoration: BoxDecoration(
          color: const Color(0xffeff6ff),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(icon, color: AppColors.adminBlue, size: 18.r),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right, color: Color(0xffcbd5e1)),
    );
  }
}
