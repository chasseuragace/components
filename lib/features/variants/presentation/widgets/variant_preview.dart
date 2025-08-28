import 'package:flutter/material.dart';
import '../../domain/entities/variant_item.dart';

class VariantPreview extends StatelessWidget {
  final VariantItem variant;

  const VariantPreview({super.key, required this.variant});

  static const double _mobileWidth = 320.0;
  static const double _mobileHeight = 568.0;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              variant.name,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 12.0),
            width: _mobileWidth,
            height: _mobileHeight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: FittedBox(
                fit: BoxFit.contain,
                child: SizedBox(
                  width: _mobileWidth,
                  height: _mobileHeight,
                  child: MaterialApp(
                    debugShowCheckedModeBanner: false,
                    theme: ThemeData(
                      useMaterial3: true,
                      colorSchemeSeed: Colors.blueGrey,
                      appBarTheme: const AppBarTheme(
                        centerTitle: true,
                      ),
                    ),
                    home: Builder(
                      builder: (BuildContext innerContext) => variant.builder(innerContext),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
