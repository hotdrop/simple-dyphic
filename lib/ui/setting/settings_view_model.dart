import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:simple_dyphic/common/app_logger.dart';
import 'package:simple_dyphic/repository/account_repository.dart';
import 'package:simple_dyphic/repository/record_repository.dart';
import 'package:simple_dyphic/res/R.dart';
import 'package:simple_dyphic/ui/base_view_model.dart';

final settingsViewModelProvider = ChangeNotifierProvider.autoDispose((ref) => _SettingsViewModel(ref));
final _packageInfoProvider = Provider((ref) => PackageInfo.fromPlatform());

class _SettingsViewModel extends BaseViewModel {
  _SettingsViewModel(this._ref) {
    _init();
  }

  final Ref _ref;

  late String _appVersion;
  String get appVersion => _appVersion;

  // ステータス
  _LoginStatus _loginStatus = _LoginStatus.notLogin;
  bool get loggedIn => _loginStatus == _LoginStatus.loggedIn;

  Future<void> _init() async {
    final packageInfo = await _ref.read(_packageInfoProvider);
    _appVersion = '${packageInfo.version}-${packageInfo.buildNumber}';

    final isLogin = _ref.read(accountRepositoryProvider).isLogIn();
    if (isLogin) {
      _loginStatus = _LoginStatus.loggedIn;
    } else {
      _loginStatus = _LoginStatus.notLogin;
    }

    onSuccess();
  }

  String getLoginUserName() {
    if (loggedIn) {
      return _ref.read(accountRepositoryProvider).userName() ?? R.res.strings.settingsLoginNameNotSettingLabel;
    } else {
      return R.res.strings.settingsNotLoginNameLabel;
    }
  }

  String getLoginEmail() {
    if (loggedIn) {
      return _ref.read(accountRepositoryProvider).userEmail() ?? R.res.strings.settingsLoginEmailNotSettingLabel;
    } else {
      return R.res.strings.settingsNotLoginEmailLabel;
    }
  }

  Future<void> loginWithGoogle() async {
    nowLoading();
    await _ref.read(accountRepositoryProvider).login();
    _loginStatus = _LoginStatus.loggedIn;
    onSuccess();
  }

  Future<void> logout() async {
    try {
      await _ref.read(accountRepositoryProvider).logout();
      _loginStatus = _LoginStatus.notLogin;
      notifyListeners();
    } catch (e, s) {
      await AppLogger.e('ログアウトに失敗しました。', e, s);
      rethrow;
    }
  }

  Future<void> backup() async {
    await _ref.read(recordRepositoryProvider).backup();
  }

  Future<void> restore() async {
    await _ref.read(recordRepositoryProvider).restore();
  }
}

enum _LoginStatus { notLogin, loggedIn }
