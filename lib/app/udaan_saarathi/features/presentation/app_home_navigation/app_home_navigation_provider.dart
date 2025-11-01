import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Holds the index of the current tab in the bottom navigation bar
final appHomeNavIndexProvider = StateProvider<int>((ref) => 0);
