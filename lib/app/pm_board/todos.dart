import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/pm_board/todos_provider.dart';

class Todos extends ConsumerWidget {
  const Todos({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final todos = ref.watch(todosProvider);
    return ListView.builder(
      itemBuilder: (context, index) {
        final todo = todos[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(todo['title'] as String),
                subtitle: Text(todo['description'] as String),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...(todo['subtasks'] as List).map((e) => Text(e)),
                ],
              ),
            ],
          ),
        );
      },
      itemCount: todos.length,
    );
  }
}
