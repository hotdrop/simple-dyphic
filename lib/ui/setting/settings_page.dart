import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_dyphic/model/app_settings.dart';
import 'package:simple_dyphic/res/R.dart';
import 'package:simple_dyphic/ui/setting/settings_view_model.dart';
import 'package:simple_dyphic/ui/widget/app_icon.dart';
import 'package:simple_dyphic/ui/widget/app_progress_dialog.dart';
import 'package:simple_dyphic/ui/widget/app_dialog.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(R.res.strings.settingsPageTitle),
      ),
      body: Consumer(
        builder: (context, watch, child) {
          final uiState = watch(settingsViewModelProvider).uiState;
          return uiState.when(
            loading: () => _onLoading(),
            success: () => _onSuccess(context),
            error: (err) => _onError(context, '$err'),
          );
        },
      ),
    );
  }

  Widget _onLoading() {
    return Center(
      child: const CircularProgressIndicator(),
    );
  }

  Widget _onError(BuildContext context, String errMsg) {
    Future<void>.delayed(Duration.zero).then((_) {
      AppDialog.ok(message: errMsg).show(context);
    });
    return Center(
      child: const CircularProgressIndicator(),
    );
  }

  Widget _onSuccess(BuildContext context) {
    final loggedIn = context.read(settingsViewModelProvider).loggedIn;
    return ListView(
      children: [
        _rowAccountInfo(context),
        if (!loggedIn) _loginDescriptionLabel(context),
        const Divider(),
        _rowSwitchTheme(context),
        _rowAppVersion(context),
        const Divider(),
      ],
    );
  }

  Widget _rowAccountInfo(BuildContext context) {
    final viewModel = context.read(settingsViewModelProvider);
    return ListTile(
      leading: Icon(Icons.account_circle, size: R.res.integers.settingsPageAccountIconSize),
      title: Text(viewModel.getLoginEmail(), style: TextStyle(fontSize: 12.0)),
      subtitle: Text(viewModel.getLoginUserName()),
      trailing: (viewModel.loggedIn) ? _logoutButton(context) : _loginButton(context),
    );
  }

  Widget _rowSwitchTheme(BuildContext context) {
    final appSettings = context.read(appSettingsProvider)!;
    return ListTile(
      leading: ChangeThemeIcon(appSettings.isDarkMode),
      title: Text(R.res.strings.settingsChangeAppThemeLabel),
      trailing: Switch(
        onChanged: (isDark) => context.read(appSettingsProvider.notifier).saveThemeMode(isDark),
        value: appSettings.isDarkMode,
      ),
    );
  }

  Widget _rowAppVersion(BuildContext context) {
    final appVersion = context.read(settingsViewModelProvider).appVersion;
    return ListTile(
      leading: Icon(Icons.info, size: R.res.integers.settingsPageIconSize),
      title: Text(R.res.strings.settingsAppVersionLabel),
      trailing: Text(appVersion),
    );
  }

  Widget _loginButton(BuildContext context) {
    final viewModel = context.read(settingsViewModelProvider);
    return ElevatedButton(
      onPressed: () {
        viewModel.loginWithGoogle();
      },
      child: Text(R.res.strings.settingsLoginWithGoogle),
    );
  }

  Widget _loginDescriptionLabel(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Text(R.res.strings.settingsLoginInfo, style: Theme.of(context).textTheme.caption),
    );
  }

  Widget _logoutButton(BuildContext context) {
    final viewModel = context.read(settingsViewModelProvider);
    return OutlinedButton(
      onPressed: () {
        final dialog = AppProgressDialog<void>();
        dialog.show(
          context,
          execute: viewModel.logout,
          onSuccess: (_) {
            // 成功時は何もしない
          },
          onError: (err, stack) {
            AppDialog.ok(message: '$err').show(context);
          },
        );
      },
      child: Text(R.res.strings.settingsLogoutLabel),
    );
  }
}
