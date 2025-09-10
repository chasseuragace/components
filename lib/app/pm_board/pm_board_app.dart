import 'package:flutter/material.dart';
// 
class PMBoardApp extends StatelessWidget {
  const PMBoardApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var tabs2 = [
            Tab(text: "Todos",),
            Tab(text:"Docs")
           ];
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
                      Expanded(child: TabBarView(children: [
                        Text("1"),
                        Text("1"),
                      ]),),
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

class PmHeader extends StatelessWidget {
  const PmHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder(
      fallbackHeight: 120,
    );
  }
}