import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/pm_board/docs_provider.dart';

class Docs extends ConsumerWidget {
  const Docs({
    super.key,
  });

  @override
  Widget build(BuildContext context,ref) {
    final  docs = ref.read(docsProvider);
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Text(docs),
    );
  }
}
