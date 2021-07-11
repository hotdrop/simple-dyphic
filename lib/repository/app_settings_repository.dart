import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_dyphic/common/app_logger.dart';
import 'package:simple_dyphic/repository/local/entities/record_entity.dart';
import 'package:simple_dyphic/repository/local/shared_prefs.dart';
import 'package:simple_dyphic/service/firebase_auth.dart';
import 'package:simple_dyphic/service/firebase_crashlytics.dart';

final appSettingsRepositoryProvider = Provider((ref) => _AppSettingsRepository(ref.read));

class _AppSettingsRepository {
  const _AppSettingsRepository(this._read);

  final Reader _read;

  ///
  /// 保持するデータで必要な初期処理がある場合はここで行う
  ///
  Future<void> initApp() async {
    AppLogger.d('アプリの初期処理を実行します。');
    await _read(firebaseAuthProvider.notifier).init();
    await AppCrashlytics.instance.init();
    await Hive.initFlutter();
    Hive.registerAdapter(RecordEntityAdapter());
  }

  Future<bool> isDarkMode() async {
    return await _read(sharedPrefsProvider).isDarkMode();
  }

  Future<void> saveThemeMode(bool isDarkMode) async {
    await _read(sharedPrefsProvider).saveIsDarkMode(isDarkMode);
  }
}
