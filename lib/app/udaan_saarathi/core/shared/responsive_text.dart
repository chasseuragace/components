import 'package:flutter/material.dart';
import 'package:variant_dashboard/app/udaan_saarathi/utils/size_config.dart';

class ResponsiveText extends StatelessWidget {
  const ResponsiveText(
    this.text, {
    super.key,
    this.fontSize = 14,
    this.color,
    this.fontWeight,
    this.textAlign = TextAlign.start,
    this.fontFamily,
    this.fontStyle,
    this.textOverflow,
    this.maxLines,
    this.decoration,
    this.height,
    this.overflow,
    this.letterSpacing,
    this.softWrap,
  });

  final double fontSize;
  final String text;
  final Color? color;
  final TextAlign textAlign;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final TextOverflow? textOverflow;
  final FontStyle? fontStyle;
  final int? maxLines;
  final double? height;
  final TextDecoration? decoration;
  final TextOverflow? overflow;
  final double? letterSpacing;
  final bool? softWrap;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      textScaler: const TextScaler.linear(1),
      overflow: overflow,
      softWrap: softWrap,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            decoration: decoration,
            color: color,
            height: height,
            fontFamily: 'Poppins',
            fontSize: getResponsiveFont(fontSize),
            fontWeight: fontWeight,
            overflow: textOverflow,
            fontStyle: fontStyle,
            letterSpacing: letterSpacing,
          ),
      maxLines: maxLines,
    );
  }
}
