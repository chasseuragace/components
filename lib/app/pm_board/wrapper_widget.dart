import 'package:flutter/material.dart';
import 'package:variant_dashboard/app/pm_board/header.dart';
import 'package:variant_dashboard/app/pm_board/panel.dart';
import 'package:variant_dashboard/app/pm_board/udaan_saarathi_project_manager.dart';

class WrapperWidget extends StatelessWidget {
  const WrapperWidget({
    super.key,
    required this.width3,
    required this.height2,
    required this.other, required this. child,
  });
    final Widget child;
  final double width3;
  final double height2;
  final int other;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 145, 144, 144),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SizedBox(
          width: width3,
          height: height2,
          child: Stack(
            children: [
              Center(
                child: FittedBox(
                  child: Container(
                    // color: Colors.red,
                    width: width3 * other,
                    height: height2 * other,
                    child: AspectRatio(
                      aspectRatio: width2 / height2,
                      child: Row(
                        children: [
                 
                            Panel(),
                          // mobile screen for udaansaarathi app
                          // can set builder here
                          // eg: shows using one of the hte existing variant page in use
    
                          Expanded(
                            child: child
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Header(),
            ],
          ),
        ),
      ),
    );
  }
}
