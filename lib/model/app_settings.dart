import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_dyphic/repository/app_settings_repository.dart';

final appSettingsProvider = StateNotifierProvider<_AppSettingsNotifier, AppSettings?>((ref) => _AppSettingsNotifier(ref.read));

class _AppSettingsNotifier extends StateNotifier<AppSettings?> {
  _AppSettingsNotifier(this._read) : super(null) {
    _init();
  }

  final Reader _read;

  Future<void> _init() async {
    await _read(appSettingsRepositoryProvider).initApp();
    final isDarkMode = await _read(appSettingsRepositoryProvider).isDarkMode();
    state = AppSettings(isDarkMode);
  }

  Future<void> saveThemeMode(bool isDarkMode) async {
    await _read(appSettingsRepositoryProvider).saveThemeMode(isDarkMode);
    state = AppSettings(isDarkMode);
  }
}

class AppSettings {
  const AppSettings(this.isDarkMode);
  final bool isDarkMode;
}
