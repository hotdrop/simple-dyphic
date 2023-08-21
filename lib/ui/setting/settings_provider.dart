import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:simple_dyphic/common/app_logger.dart';
import 'package:simple_dyphic/repository/account_repository.dart';
import 'package:simple_dyphic/repository/record_repository.dart';
import 'package:simple_dyphic/res/R.dart';
import 'package:simple_dyphic/ui/base_view_model.dart';

part 'settings_provider.g.dart';

final _packageInfoProvider = Provider((ref) => PackageInfo.fromPlatform());

@riverpod
class SettingsController extends _$SettingsController {
  @override
  Future<void> build() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final isLogin = ref.read(accountRepositoryProvider).isLogIn();
    // _appVersion = '${packageInfo.version}-${packageInfo.buildNumber}';

    //
    // if (isLogin) {
    //   _loginStatus = _LoginStatus.loggedIn;
    // } else {
    //   _loginStatus = _LoginStatus.notLogin;
    // }
  }
}

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
    await _ref.read(accountRepositoryProvider).signIn();
    _loginStatus = _LoginStatus.loggedIn;
    onSuccess();
  }

  Future<void> logout() async {
    try {
      await _ref.read(accountRepositoryProvider).signOut();
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

final _uiStateProvider = StateProvider<_UiState>((ref) => _UiState.empty());

class _UiState {
  const _UiState({
    required this.isLogin,
    required this.appVersion,
  });

  factory _UiState.empty() {
    return const _UiState(isLogin: false, appVersion: '');
  }

  final bool isLogin;
  final String appVersion;

  _UiState copyWith({bool? isLogin, String? appVersion}) {
    return _UiState(
      isLogin: isLogin ?? this.isLogin,
      appVersion: appVersion ?? this.appVersion,
    );
  }
}

// アプリのバージョン情報
final settingAppVersionProvider = Provider<String>((ref) {
  return ref.watch(_uiStateProvider.select((value) => value.appVersion));
});

// ログインしているか？
final settingIsLoginProvider = Provider<bool>((ref) {
  return ref.watch(_uiStateProvider.select((value) => value.isLogin));
});

// ログインしているGoogleアカウントのメアド
final accountEmailProvider = Provider<String>((ref) {
  return ref.watch(settingIsLoginProvider)
      ? ref.read(accountRepositoryProvider).userEmail() ?? R.res.strings.settingsLoginEmailNotSettingLabel
      : R.res.strings.settingsLoginEmailNotSettingLabel;
});

// ログインしているGoogleアカウント名
final accountUserNameProvider = Provider<String>((ref) {
  return ref.watch(settingIsLoginProvider)
      ? ref.read(accountRepositoryProvider).userName() ?? R.res.strings.settingsLoginNameNotSettingLabel
      : R.res.strings.settingsLoginNameNotSettingLabel;
});
