import 'package:flutter/material.dart';
import 'package:meal_mate/core/theme/app_colors.dart';

class CheckoutCardWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  
  const CheckoutCardWidget({
    required this.title,
    required this.icon,
    required this.child,
    super.key
  });

  

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primaryColor),
                const SizedBox(width: 8),
                Text(
                  title.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            child,
          ],
        ),
      ),
    );
  }
}
