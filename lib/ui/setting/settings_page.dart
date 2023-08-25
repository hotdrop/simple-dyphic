import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_dyphic/res/images.dart';
import 'package:simple_dyphic/res/strings.dart';
import 'package:simple_dyphic/ui/setting/settings_provider.dart';
import 'package:simple_dyphic/ui/widget/app_progress_dialog.dart';
import 'package:simple_dyphic/ui/widget/app_dialog.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.settingsPageTitle),
      ),
      body: ref.watch(settingsControllerProvider).when(
            data: (_) => const _ViewBody(),
            error: (err, stackTrace) {
              _processOnError(context, '$err');
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
            loading: () {
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
}

class _ViewBody extends ConsumerWidget {
  const _ViewBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSignIn = ref.watch(settingIsSignInProvider);

    return ListView(
      children: [
        const _RowAccountInfo(),
        const _RowAppLicense(),
        const Divider(),
        if (isSignIn) ...[
          const _RowBackup(),
          const _RowRestore(),
          const Divider(),
          const _SignOutButton(),
        ],
        if (!isSignIn) ...[
          const _SignInButton(),
        ],
      ],
    );
  }
}

class _RowAccountInfo extends ConsumerWidget {
  const _RowAccountInfo();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.account_circle, size: 32),
      title: Text(ref.watch(accountUserNameProvider)),
      subtitle: Text(ref.watch(accountEmailProvider)),
    );
  }
}

class _RowAppLicense extends ConsumerWidget {
  const _RowAppLicense();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.note, size: 32),
      title: const Text(Strings.settingsLicenseLavel),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        showLicensePage(
          context: context,
          applicationName: Strings.appTitle,
          applicationVersion: ref.read(settingAppVersionProvider),
          applicationIcon: Image.asset(Images.icAppPath, width: 50, height: 50),
        );
      },
    );
  }
}

///
/// データバックアップ
///
class _RowBackup extends ConsumerWidget {
  const _RowBackup();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.backup, size: 32),
      title: const Text(Strings.settingsBackupLabel),
      subtitle: const Text(Strings.settingsBackupDetailLabel),
      onTap: () {
        AppDialog.okAndCancel(
          message: Strings.settingsBackupConfirmMessage,
          onOk: () => _processBackUp(context, ref),
        ).show(context);
      },
    );
  }

  void _processBackUp(BuildContext context, WidgetRef ref) {
    const progressDialog = AppProgressDialog<void>();
    progressDialog.show(
      context,
      execute: ref.read(settingsControllerProvider.notifier).backup,
      onSuccess: (_) => AppDialog.ok(message: Strings.settingsBackupSuccessMessage).show(context),
      onError: (err) => AppDialog.ok(message: '$err').show(context),
    );
  }
}

///
/// データ復元
///
class _RowRestore extends ConsumerWidget {
  const _RowRestore();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: const Icon(Icons.settings_backup_restore, size: 32),
      title: const Text(Strings.settingsRestoreLabel),
      subtitle: const Text(Strings.settingsRestoreDetailLabel),
      onTap: () {
        AppDialog.okAndCancel(
          message: Strings.settingsRestoreConfirmMessage,
          onOk: () => _processRestore(context, ref),
        ).show(context);
      },
    );
  }

  void _processRestore(BuildContext context, WidgetRef ref) {
    const progressDialog = AppProgressDialog<void>();
    progressDialog.show(
      context,
      execute: ref.read(settingsControllerProvider.notifier).restore,
      onSuccess: (_) => AppDialog.ok(message: Strings.settingsRestoreSuccessMessage).show(context),
      onError: (err) => AppDialog.ok(message: '$err').show(context),
    );
  }
}

///
/// サインインボタン
///
class _SignInButton extends ConsumerWidget {
  const _SignInButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ElevatedButton(
        onPressed: () => _processSignIn(context, ref),
        child: const Text(Strings.settingsLoginWithGoogle),
      ),
    );
  }

  void _processSignIn(BuildContext context, WidgetRef ref) {
    const progressDialog = AppProgressDialog<void>();
    progressDialog.show(
      context,
      execute: ref.read(settingsControllerProvider.notifier).signInWithGoogle,
      onSuccess: (_) {/* 成功時は何もしない */},
      onError: (err) => AppDialog.ok(message: 'err').show(context),
    );
  }
}

///
/// サインアウトボタン
///
class _SignOutButton extends ConsumerWidget {
  const _SignOutButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: OutlinedButton(
        child: const Text(Strings.settingsLogoutLabel),
        onPressed: () {
          AppDialog.okAndCancel(
            message: Strings.settingsSignOutDialogMessage,
            onOk: () => _processSignOut(context, ref),
          ).show(context);
        },
      ),
    );
  }

  void _processSignOut(BuildContext context, WidgetRef ref) {
    const progressDialog = AppProgressDialog<void>();
    progressDialog.show(
      context,
      execute: ref.read(settingsControllerProvider.notifier).signOutWithGoogle,
      onSuccess: (_) {/* 成功時は何もしない */},
      onError: (err) => AppDialog.ok(message: '$err').show(context),
    );
  }
}
