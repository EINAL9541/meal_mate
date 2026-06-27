import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meal_mate/core/error/failures.dart';
import 'package:meal_mate/core/theme/app_colors.dart'; // Example package

class FailuresHandler {
  static void show(BuildContext context, Failure failure) {
    String message = failure.toString();
    
    if (failure is NetworkFailure) {
      message = "Check your internet connection: $message";
    }

    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      backgroundColor: AppColors.error,
      textColor: AppColors.baseWhite,
    );
  }
}