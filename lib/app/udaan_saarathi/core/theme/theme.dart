import 'package:flutter/material.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/colors/app_colors.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/resources/style_manager.dart';
import 'package:variant_dashboard/app/udaan_saarathi/utils/size_config.dart';

class AppTheme {
  static ThemeData build() {
    return ThemeData(
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryColor,
      ),
      useMaterial3: false,
      colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.kwhite,
        foregroundColor: Colors.black,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: AppColors.kblack,
          fontSize: 18,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          height: 0,
        ),
      ),
      // inputDecorationTheme: inputDecorationTheme(),
      popupMenuTheme: PopupMenuThemeData(
        elevation: 1,
        iconSize: 25.0,
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      textTheme: TextTheme(
        titleMedium: TextStyle(
          fontSize: getResponsiveFont(16),
          fontFamily: 'Poppins',
          color: AppColors.kblack,
          fontWeight: FontWeight.w500,
          height: 1,
        ),
      ),
      tabBarTheme: TabBarThemeData(
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(
            color: AppColors.primaryColor,
            width: 2,
          ),
        ),
        labelColor: AppColors.primaryColor,
        overlayColor: const WidgetStatePropertyAll(AppColors.primaryColor),
        labelStyle: getMediumStyle(color: AppColors.primaryColor),
        unselectedLabelStyle: getMediumStyle(),
      ),
      fontFamily: 'Poppins',
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (states) => states.contains(WidgetState.disabled)
                ? AppColors.kgrey
                : AppColors.primaryColor,
          ),
          shape: WidgetStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          foregroundColor: WidgetStateProperty.all<Color>(AppColors.kwhite),
          minimumSize: WidgetStateProperty.all<Size>(const Size(0, 44)),
          textStyle: WidgetStateProperty.all<TextStyle>(
            TextStyle(
              color: AppColors.kred,
              fontSize: getResponsiveFont(16),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  static const Color warningLight = Color(0xFFD97706);
  static const Color successLight = Color(0xFF059669);
}
