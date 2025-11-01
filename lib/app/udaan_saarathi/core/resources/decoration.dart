import 'package:flutter/material.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/colors/app_colors.dart';
import 'package:variant_dashboard/app/udaan_saarathi/utils/size_config.dart';

OutlineInputBorder _buildOutlineInputBorder(Color color) {
  return OutlineInputBorder(
    borderSide: BorderSide(color: color),
  );
}

TextStyle _buildHintStyle() {
  return TextStyle(
    fontSize: getResponsiveFont(14),
    fontFamily: 'Poppins',
    color: AppColors.kgreyShade500,
    fontWeight: FontWeight.w400,
  );
}

TextStyle _buildLabelStyle() {
  return TextStyle(
    color: AppColors.kgreyShade800,
    fontSize: getResponsiveFont(16),
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
  );
}

InputDecoration inputDecoration() {
  return InputDecoration(
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    contentPadding: const EdgeInsets.all(15),
    fillColor: AppColors.kgreyShade300,
    floatingLabelAlignment: FloatingLabelAlignment.start,
    enabledBorder:
        _buildOutlineInputBorder(AppColors.kgreyShade800.withOpacity(0.3)),
    focusedErrorBorder:
        _buildOutlineInputBorder(AppColors.kred.withOpacity(0.3)),
    errorBorder: _buildOutlineInputBorder(AppColors.kred.withOpacity(0.3)),
    hintStyle: _buildHintStyle(),
    disabledBorder: _buildOutlineInputBorder(AppColors.kgreyShade400),
    focusedBorder: _buildOutlineInputBorder(AppColors.primaryColor),
    alignLabelWithHint: false,
    border: _buildOutlineInputBorder(AppColors.kgreyShade400),
    labelStyle: _buildLabelStyle(),
  );
}

TextStyle get inputFieldValueTextStyle => TextStyle(
      color: AppColors.kblack,
      fontFamily: 'Poppins',
      fontSize: getResponsiveFont(16),
      letterSpacing: 0,
      fontWeight: FontWeight.normal,
      height: 1,
    );

InputDecorationTheme inputDecorationTheme() {
  return InputDecorationTheme(
    contentPadding: const EdgeInsets.all(15),
    fillColor: AppColors.kgreyShade300,
    enabledBorder:
        _buildOutlineInputBorder(AppColors.kgreyShade800.withOpacity(0.3)),
    focusedErrorBorder:
        _buildOutlineInputBorder(AppColors.kred.withOpacity(0.3)),
    errorBorder: _buildOutlineInputBorder(AppColors.kred.withOpacity(0.3)),
    hintStyle: _buildHintStyle(),
    disabledBorder: _buildOutlineInputBorder(AppColors.kgreyShade400),
    focusedBorder: _buildOutlineInputBorder(AppColors.primaryColor),
    border: _buildOutlineInputBorder(AppColors.kgreyShade400),
    labelStyle: _buildLabelStyle(),
  );
}
