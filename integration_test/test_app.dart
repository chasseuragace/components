import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/storage/local_storage.dart';
import 'package:variant_dashboard/app/udaan_saarathi/udaan_saarathi_app.dart';

/// Test app wrapper that provides mock dependencies
class TestApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;
  final List<Override> overrides;

  const TestApp({
    super.key,
    required this.sharedPreferences,
    this.overrides = const [],
  });

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        ...overrides,
      ],
      child: const UdaanSaarathiApp(),
    );
  }
}
