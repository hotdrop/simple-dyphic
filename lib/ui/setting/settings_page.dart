import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_dyphic/res/R.dart';
import 'package:simple_dyphic/ui/setting/settings_provider.dart';
import 'package:simple_dyphic/ui/widget/app_icon.dart';
import 'package:simple_dyphic/ui/widget/app_progress_dialog.dart';
import 'package:simple_dyphic/ui/widget/app_dialog.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uiState = ref.watch(settingsViewModelProvider).uiState;

    return Scaffold(
      appBar: AppBar(
        title: Text(R.res.strings.settingsPageTitle),
      ),
      body: uiState.when(
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        success: () => _onSuccess(context),
        error: (err) {
          _processOnError(context, '$err');
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  void _processOnError(BuildContext context, String errMsg) {
    Future<void>.delayed(Duration.zero).then((_) {
      AppDialog.ok(message: errMsg).show(context);
    });
  }

  Widget _onSuccess(BuildContext context, WidgetRef ref) {
    final loggedIn = ref.read(settingsViewModelProvider).loggedIn;

    return ListView(
      children: [
        _rowAccountInfo(context),
        if (!loggedIn) _loginDescriptionLabel(context),
        const Divider(),
        _rowSwitchTheme(context),
        _rowLicense(context),
        _rowAppVersion(context),
        const Divider(),
        if (loggedIn) ..._viewLoginMenu(context),
      ],
    );
  }

  Widget _rowAccountInfo(BuildContext context) {
    final viewModel = context.read(settingsViewModelProvider);
    return ListTile(
      leading: Icon(Icons.account_circle, size: 50),
      title: Text(viewModel.getLoginEmail(), style: TextStyle(fontSize: 12.0)),
      subtitle: Text(viewModel.getLoginUserName()),
      trailing: (viewModel.loggedIn) ? _logoutButton(context) : _loginButton(context),
    );
  }

  Widget _rowLicense(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.note),
      title: Text(R.res.strings.settingsLicenseLavel),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () {
        showLicensePage(context: context);
      },
    );
  }

  Widget _rowAppVersion(BuildContext context) {
    final appVersion = context.read(settingsViewModelProvider).appVersion;
    return ListTile(
      leading: Icon(Icons.info, size: 30),
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

  List<Widget> _viewLoginMenu(BuildContext context) {
    return <Widget>[
      ListTile(
        leading: Icon(Icons.backup, size: 30),
        title: Text(R.res.strings.settingsBackupLabel),
        subtitle: Text(R.res.strings.settingsBackupDetailLabel),
        onTap: () => _showBackupDialog(context),
      ),
      ListTile(
        leading: Icon(Icons.restore, size: 30),
        title: Text(R.res.strings.settingsRestoreLabel),
        subtitle: Text(R.res.strings.settingsRestoreDetailLabel),
        onTap: () => _showRestoreDialog(context),
      ),
    ];
  }

  void _showBackupDialog(BuildContext context) {
    AppDialog.okAndCancel(
      message: R.res.strings.settingsBackupConfirmMessage,
      onOk: () {
        final dialog = AppProgressDialog<void>();
        dialog.show(
          context,
          execute: context.read(settingsViewModelProvider).backup,
          onSuccess: (_) {
            AppDialog.ok(message: R.res.strings.settingsBackupSuccessMessage).show(context);
          },
          onError: (err) {
            AppDialog.ok(message: '$err').show(context);
          },
        );
      },
    ).show(context);
  }

  void _showRestoreDialog(BuildContext context) {
    AppDialog.okAndCancel(
      message: R.res.strings.settingsRestoreConfirmMessage,
      onOk: () {
        final dialog = AppProgressDialog<void>();
        dialog.show(
          context,
          execute: context.read(settingsViewModelProvider).restore,
          onSuccess: (_) {
            AppDialog.ok(message: R.res.strings.settingsRestoreSuccessMessage).show(context);
          },
          onError: (err) {
            AppDialog.ok(message: '$err').show(context);
          },
        );
      },
    ).show(context);
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
          onError: (err) {
            AppDialog.ok(message: '$err').show(context);
          },
        );
      },
      child: Text(R.res.strings.settingsLogoutLabel),
    );
  }
}
