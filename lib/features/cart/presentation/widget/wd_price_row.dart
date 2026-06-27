import 'package:flutter/material.dart';
import 'package:meal_mate/core/theme/app_colors.dart';

class PriceRowWidget extends StatelessWidget {
  const PriceRowWidget({
    required this.label,
    required this.value,
    this.large = false,
    super.key
  });

  final String label;
  final double value;
  final bool large;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: large ? FontWeight.w900 : FontWeight.w600,
          ),
        ),
        const Spacer(),
        Text(
          '\$${value.toStringAsFixed(2)}',
          style: TextStyle(
            color: large ? AppColors.primaryColor : null,
            fontSize: large ? 20 : 14,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}