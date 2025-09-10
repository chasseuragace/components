import 'package:flutter/material.dart';

class HomePageVariant3 extends StatelessWidget {
  const HomePageVariant3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page V3'),
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.2,
        ),
        itemCount: 6,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.dashboard_customize, size: 40, color: Theme.of(context).colorScheme.secondary),
                const SizedBox(height: 8),
                Text('Grid ${index + 1}', style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
          );
        },
      ),
    );
  }
}
