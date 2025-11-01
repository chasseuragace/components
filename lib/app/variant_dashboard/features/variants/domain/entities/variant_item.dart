import 'package:flutter/widgets.dart';

class VariantItem {
  final String name;
  final Widget Function(BuildContext context) builder;

  VariantItem({required this.name, required this.builder});
}
