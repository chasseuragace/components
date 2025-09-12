import 'package:flutter_riverpod/flutter_riverpod.dart';

// Step index in the Set Preferences flow
final currentStepProvider = StateProvider<int>((ref) => 0);

// Salary range as a simple map: {'min': double, 'max': double}
final salaryRangeProvider =
    StateProvider<Map<String, double>>((ref) => {'min': 800, 'max': 3000});

// Whether the user needs training support
final trainingSupportProvider = StateProvider<bool>((ref) => false);
