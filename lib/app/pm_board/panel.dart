import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/pm_board/pm_board_app.dart';
import 'package:variant_dashboard/app/pm_board/udaan_saarathi_project_manager.dart';

class Panel extends StatelessWidget {
  const Panel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer(
        child: PMBoardApp(),
        builder: (context, ref, child) {
          return AnimatedContainer(
            width: (ref.watch(expansionStateProvider)
                    ? 3
                    : 0) *
                300,
            duration: Duration(seconds: 1),
            child: GestureDetector(
                onDoubleTap: () {
                  ref
                      .read(expansionStateProvider
                          .notifier)
                      .update((_) => !_);
                },
                child: child!),
          );
        });
  }
}
