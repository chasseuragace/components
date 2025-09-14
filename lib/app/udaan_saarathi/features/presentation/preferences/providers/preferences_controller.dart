import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:variant_dashboard/app/udaan_saarathi/core/usecases/usecase.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/preferences/providers/di.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/preferences/providers/preferences_status.dart';

/// Stub controller to manage whether user preferences have been configured.
///
/// This uses LocalStorage under the hood and can be expanded later to
/// read/write structured preferences. For now, it stores a simple flag.
class PreferencesController extends AsyncNotifier<PreferencesStatus> {
  @override
  Future<PreferencesStatus> build() async {
    final result = await ref.read(getAllPreferencesUseCaseProvider)(NoParm());
    return result.fold(
      (_) => PreferencesStatus.error,
      (items) => items.isNotEmpty
          ? PreferencesStatus.configured
          : PreferencesStatus.notConfigured,
    );
  }
}

/// Expose whether preferences are configured (true) or not (false)
final preferencesControllerProvider =
    AsyncNotifierProvider<PreferencesController, PreferencesStatus>(
  PreferencesController.new,
);
