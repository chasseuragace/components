import 'package:flutter/material.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/colors/app_colors.dart';

class CustomSnackbar {
  static showSuccessSnackbar(BuildContext context, String message) {
    final snackbar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: AppColors.primaryColor,
      behavior: SnackBarBehavior.floating, // Use fixed snackbar for iOS
    );
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }

  static showFailureSnackbar(BuildContext context, String message) {
    final snackbar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: AppColors.errorColor,
      behavior: SnackBarBehavior.floating, // Use fixed snackbar for iOS
    );
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      snackbar,
    );
  }
}
