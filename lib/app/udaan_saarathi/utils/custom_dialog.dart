import 'package:flutter/material.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/colors/app_colors.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/shared/custom_button.dart';
import 'package:variant_dashboard/app/udaan_saarathi/utils/size_config.dart';

class CustomDialog {
  static void showCustomDialog(
    BuildContext context, {
    required Function() onTap,
    Function()? onNegativeTap,
    required String negativeText,
    String? positiveText,
    required String title,
    String? subtitle,
    Color? positiveColor = AppColors.errorColor,
    Color? negativeColor = AppColors.primaryColor,
    bool barrierDismissible = true,
  }) {
    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (ctx) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.symmetric(horizontal: kHorizontalMargin),
                padding: EdgeInsets.symmetric(
                  vertical: kVerticalMargin,
                  horizontal: kHorizontalMargin,
                ),
                width: width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (subtitle != null)
                      SizedBox(
                        height: kVerticalMargin,
                      ),
                    if (subtitle != null)
                      Text(
                        subtitle,
                        textAlign: TextAlign.center,
                      ),
                    SizedBox(
                      height: kVerticalMargin * 2,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            onPressed: () {
                              if (onNegativeTap != null) onNegativeTap();
                              Navigator.pop(ctx);
                            },
                            title: negativeText,
                            color: negativeColor,
                          ),
                        ),
                        if (positiveText != null) ...[
                          SizedBox(
                            width: kHorizontalMargin * 2,
                          ),
                          Expanded(
                            child: CustomButton(
                              onPressed: () {
                                Navigator.pop(ctx);
                                onTap();
                              },
                              title: positiveText,
                              color: positiveColor,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
