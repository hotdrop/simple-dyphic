import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_dyphic/res/images.dart';
import 'package:simple_dyphic/ui/setting/settings_provider.dart';
import 'package:simple_dyphic/ui/widget/app_progress_dialog.dart';
import 'package:simple_dyphic/ui/widget/app_dialog.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
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
      title: const Text('バージョンとライセンス'),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        showLicensePage(
          context: context,
          applicationName: '体調管理アプリ',
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
      title: const Text('バックアップ'),
      subtitle: const Text('データをリモートにバックアップします。'),
      onTap: () {
        AppDialog.okAndCancel(
          message: 'データをリモートにバックアップします。よろしいですか？',
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
      onSuccess: (_) => AppDialog.ok(message: 'バックアップが完了しました！').show(context),
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
      title: const Text('復元'),
      subtitle: const Text('バックアップからデータを復元します。'),
      onTap: () {
        AppDialog.okAndCancel(
          message: 'バックアップからデータを復元します。よろしいですか？\n注意！現在のデータは全て消えてしまいます。ご注意ください。',
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
      onSuccess: (_) => AppDialog.ok(message: '復元が完了しました！').show(context),
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
        child: const Text('Googleアカウントでサインインする'),
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
        child: const Text('Googleアカウントからサインアウトする'),
        onPressed: () {
          AppDialog.okAndCancel(
            message: 'Googleアカウントからサインアウトします。よろしいですか？',
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
