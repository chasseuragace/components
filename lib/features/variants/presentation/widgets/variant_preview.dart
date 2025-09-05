import 'package:flutter/material.dart';
import 'package:variant_dashboard/features/variants/presentation/pages/frame.dart';

import '../../domain/entities/variant_item.dart';

class VariantPreview extends StatelessWidget {
  final VariantItem variant;

  const VariantPreview({super.key, required this.variant});
  double get multiplier => .4;

  @override
  Widget build(BuildContext context) {
    double mobileWidth = 1206.0 * multiplier;
    double mobileHeight = 2622.0 * multiplier;

    return true
        ? MobileFrame(
            child: true
                ? FittedBox(
                    fit: BoxFit.contain,
                    child: SizedBox(
                      width: mobileWidth,
                      height: mobileHeight * .94,
                      child: MaterialApp(
                        debugShowCheckedModeBanner: false,
                        theme: ThemeData(
                          useMaterial3: true,
                          colorSchemeSeed: Colors.blueGrey,
                          appBarTheme: const AppBarTheme(centerTitle: true),
                        ),
                        home: Builder(
                          builder: (BuildContext innerContext) => Column(
                            children: [
                              SizedBox(height: 35),
                              Expanded(child: variant.builder(innerContext)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : variant.builder(context),
          )
        : Card(
            color: Colors.black87,
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    variant.name,
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),

                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 12.0),
                  width: 360,
                  height: 770,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: SizedBox(
                        width: mobileWidth,
                        height: mobileHeight,
                        child: MaterialApp(
                          debugShowCheckedModeBanner: false,
                          theme: ThemeData(
                            useMaterial3: true,
                            colorSchemeSeed: Colors.blueGrey,
                            appBarTheme: const AppBarTheme(centerTitle: true),
                          ),
                          home: Builder(
                            builder: (BuildContext innerContext) =>
                                variant.builder(innerContext),
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
