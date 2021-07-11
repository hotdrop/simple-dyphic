import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPrefsProvider = Provider((ref) => _SharedPrefs(ref.read));
final _sharefPregerencesProvider = Provider((ref) async => await SharedPreferences.getInstance());

class _SharedPrefs {
  const _SharedPrefs(this._read);

  final Reader _read;

  ///
  /// ダークモードを設定しているか？
  ///
  Future<bool> isDarkMode() async => await _getBool('key01', defaultValue: false);
  Future<void> saveIsDarkMode(bool value) async {
    await _saveBool('key01', value);
  }

  Future<bool> _getBool(String key, {required bool defaultValue}) async {
    final prefs = await _read(_sharefPregerencesProvider);
    return prefs.getBool(key) ?? defaultValue;
  }

  Future<void> _saveBool(String key, bool value) async {
    final prefs = await _read(_sharefPregerencesProvider);
    prefs.setBool(key, value);
  }
}
