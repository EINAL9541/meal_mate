import 'package:flutter/material.dart';
import 'package:meal_mate/core/error/failures.dart';
import 'package:meal_mate/core/theme/app_colors.dart';
import 'package:toastification/toastification.dart'; // Example package

class FailuresHandler {
  static void show(BuildContext context, Failure failure) {
    String message = failure.toString();

    if (failure is NetworkFailure) {
      message = "Check your internet connection: $message";
    }

    toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.simple,
      title: Text(message),
      autoCloseDuration: const Duration(seconds: 2),
      backgroundColor: AppColors.error,
      foregroundColor: AppColors.baseWhite,
      alignment: Alignment.bottomCenter,
      showProgressBar: false,
    );
  }
}
