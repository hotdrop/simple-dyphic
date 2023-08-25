import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:simple_dyphic/repository/account_repository.dart';
import 'package:simple_dyphic/repository/record_repository.dart';
import 'package:simple_dyphic/res/strings.dart';

part 'settings_provider.g.dart';

@riverpod
class SettingsController extends _$SettingsController {
  @override
  Future<void> build() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final isSignIn = ref.read(accountRepositoryProvider).isSignIn;

    ref.read(_uiStateProvider.notifier).state = _UiState(
      isSignIn: isSignIn,
      appVersion: '${packageInfo.version}-${packageInfo.buildNumber}',
    );
  }

  Future<void> signInWithGoogle() async {
    await ref.read(accountRepositoryProvider).signInWithGoogle();
    ref.read(_uiStateProvider.notifier).update((state) {
      return state.copyWith(
        isSignIn: ref.read(accountRepositoryProvider).isSignIn,
      );
    });
  }

  Future<void> signOutWithGoogle() async {
    await ref.read(accountRepositoryProvider).signOutWithGoogle();
    ref.read(_uiStateProvider.notifier).update((state) {
      return state.copyWith(
        isSignIn: ref.read(accountRepositoryProvider).isSignIn,
      );
    });
  }

  Future<void> backup() async {
    await ref.read(recordRepositoryProvider).backup();
  }

  Future<void> restore() async {
    await ref.read(recordRepositoryProvider).restore();
  }
}

final _uiStateProvider = StateProvider<_UiState>((ref) => _UiState.empty());

class _UiState {
  const _UiState({
    required this.isSignIn,
    required this.appVersion,
  });

  factory _UiState.empty() {
    return const _UiState(isSignIn: false, appVersion: '');
  }

  final bool isSignIn;
  final String appVersion;

  _UiState copyWith({bool? isSignIn, String? appVersion}) {
    return _UiState(
      isSignIn: isSignIn ?? this.isSignIn,
      appVersion: appVersion ?? this.appVersion,
    );
  }
}

// アプリのバージョン情報
final settingAppVersionProvider = Provider<String>((ref) {
  return ref.watch(_uiStateProvider.select((value) => value.appVersion));
});

// ログインしているか？
final settingIsSignInProvider = Provider<bool>((ref) {
  return ref.watch(_uiStateProvider.select((value) => value.isSignIn));
});

// ログインしているGoogleアカウントのメアド
final accountEmailProvider = Provider<String>((ref) {
  return ref.watch(settingIsSignInProvider)
      ? ref.read(accountRepositoryProvider).userEmail ?? Strings.settingsNotLoginNameLabel
      : Strings.settingsNotLoginNameLabel;
});

// ログインしているGoogleアカウント名
final accountUserNameProvider = Provider<String>((ref) {
  return ref.watch(settingIsSignInProvider)
      ? ref.read(accountRepositoryProvider).userName ?? Strings.settingsNotLoginNameLabel
      : Strings.settingsNotLoginNameLabel;
});
