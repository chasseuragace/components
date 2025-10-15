import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/colors/app_colors.dart';

//A base method for defining text styles
TextStyle _getTextStyle(
  double fontSize,
  Color color,
  FontWeight fontWeight,
  double lineHeight,
) {
  return GoogleFonts.poppins(
    fontSize: fontSize,
    color: color,
    fontWeight: fontWeight,
    height: lineHeight,
  );
}

//Method types for textstyles
// regular
TextStyle getRegularStyle({
  double fontSize = 14,
  Color color = const Color(
    0xFF222222,
  ),
}) {
  return _getTextStyle(
    fontSize,
    color,
    FontWeight.w400,
    16 / fontSize,
  );
}

// light
TextStyle getLightStyle({
  double fontSize = 14,
  required Color color,
}) {
  return _getTextStyle(fontSize, color, FontWeight.w300, 16 / fontSize);
}

// Bold
TextStyle getBoldStyle({double fontSize = 14, required Color color}) {
  return _getTextStyle(fontSize, color, FontWeight.w700, 16 / fontSize);
}

// SemiBold
TextStyle getSemiBoldStyle({
  double fontSize = 14,
  Color color = AppColors.kblack,
}) {
  return _getTextStyle(
    fontSize,
    color,
    FontWeight.w600,
    16 / fontSize,
  );
}

// medium
TextStyle getMediumStyle({
  double fontSize = 14,
  Color color = AppColors.kblack,
}) {
  return _getTextStyle(
    fontSize,
    color,
    FontWeight.w500,
    16 / fontSize,
  );
}

//free style
TextStyle getStyle({
  required double fontSize,
  required Color color,
  required FontWeight fontWeight,
}) {
  return _getTextStyle(fontSize, color, fontWeight, 16 / fontSize);
}
