import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/pm_board/docs.dart';
import 'package:variant_dashboard/app/pm_board/pm_header.dart';
import 'package:variant_dashboard/app/pm_board/todos.dart';

//

class PMBoardApp extends StatelessWidget {
  const PMBoardApp({super.key});

  @override
  Widget build(BuildContext context) {
    var tabs2 = [Tab(text: "Docs"), Tab(text: "Todos")];
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // titel:  pm dashboard
            // subtitle , whats the intent of this view
            PmHeader(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(34.0),
                child: Card(
                  elevation: 12,
                  child: DefaultTabController(
                    length: tabs2.length,
                    child: Column(
                      children: [
                        // tabs with todos docs
                        TabBar(tabs: tabs2),
                        Expanded(
                          child: TabBarView(children: [Docs(),Todos(), ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
