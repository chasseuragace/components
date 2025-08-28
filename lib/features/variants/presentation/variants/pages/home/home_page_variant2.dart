import 'package:flutter/material.dart';

class HomePageVariant2 extends StatelessWidget {
  const HomePageVariant2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page V2'),
        backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              leading: Icon(Icons.list_alt, color: Theme.of(context).colorScheme.primary),
              title: Text('List Item ${index + 1}'),
              subtitle: Text('Details for item ${index + 1}'),
              onTap: () {},
            ),
          );
        },
      ),
    );
  }
}
