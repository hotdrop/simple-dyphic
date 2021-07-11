import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info/package_info.dart';
import 'package:simple_dyphic/common/app_logger.dart';
import 'package:simple_dyphic/repository/account_repository.dart';
import 'package:simple_dyphic/repository/record_repository.dart';
import 'package:simple_dyphic/res/R.dart';
import 'package:simple_dyphic/ui/base_view_model.dart';

final settingsViewModelProvider = ChangeNotifierProvider.autoDispose((ref) => _SettingsViewModel(ref.read));
final _packageInfoProvider = Provider((ref) => PackageInfo.fromPlatform());

class _SettingsViewModel extends BaseViewModel {
  _SettingsViewModel(this._read) {
    _init();
  }

  final Reader _read;

  late String _appVersion;
  String get appVersion => _appVersion;

  // ステータス
  _LoginStatus _loginStatus = _LoginStatus.notLogin;
  bool get loggedIn => _loginStatus == _LoginStatus.loggedIn;

  Future<void> _init() async {
    final packageInfo = await _read(_packageInfoProvider);
    _appVersion = packageInfo.version + '-' + packageInfo.buildNumber;

    final isLogin = _read(accountRepositoryProvider).isLogIn();
    if (isLogin) {
      _loginStatus = _LoginStatus.loggedIn;
    } else {
      _loginStatus = _LoginStatus.notLogin;
    }

    onSuccess();
  }

  String getLoginUserName() {
    if (loggedIn) {
      return _read(accountRepositoryProvider).userName() ?? R.res.strings.settingsLoginNameNotSettingLabel;
    } else {
      return R.res.strings.settingsNotLoginNameLabel;
    }
  }

  String getLoginEmail() {
    if (loggedIn) {
      return _read(accountRepositoryProvider).userEmail() ?? R.res.strings.settingsLoginEmailNotSettingLabel;
    } else {
      return R.res.strings.settingsNotLoginEmailLabel;
    }
  }

  Future<void> loginWithGoogle() async {
    nowLoading();
    await _read(accountRepositoryProvider).login();
    _loginStatus = _LoginStatus.loggedIn;
    notifyListeners();
  }

  Future<void> logout() async {
    try {
      await _read(accountRepositoryProvider).logout();
      _loginStatus = _LoginStatus.notLogin;
      notifyListeners();
    } catch (e, s) {
      await AppLogger.e('ログアウトに失敗しました。', e, s);
      rethrow;
    }
  }

  Future<void> backup() async {
    await _read(recordRepositoryProvider).backup();
  }

  Future<void> restore() async {
    await _read(recordRepositoryProvider).restore();
  }
}

enum _LoginStatus { notLogin, loggedIn }
