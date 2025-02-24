import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_dyphic/model/user_profile.dart';
import 'package:simple_dyphic/res/images.dart';
import 'package:simple_dyphic/ui/setting/profile/user_profile_page.dart';
import 'package:simple_dyphic/ui/setting/settings_provider.dart';
import 'package:simple_dyphic/ui/setting/widget/google_button.dart';
import 'package:simple_dyphic/ui/setting/widget/app_progress_dialog.dart';
import 'package:simple_dyphic/ui/widget/app_dialog.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: ref.watch(settingsControllerProvider).when(
            data: (_) => const _ViewBody(),
            error: (err, stackTrace) {
              return Center(
                child: Text('$err', style: const TextStyle(color: Colors.red)),
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
}

class _ViewBody extends ConsumerWidget {
  const _ViewBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSignIn = ref.watch(settingIsSignInProvider);

    return Column(
      children: [
        const _RowAccountInfo(),
        const _RowUserProfile(),
        const _RowAppLicense(),
        if (isSignIn) ...[
          const _RowBackup(),
          const _RowRestore(),
          const SizedBox(height: 64),
          const _SignOutButton(),
        ],
        if (!isSignIn) ...[
          const SizedBox(height: 64),
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
/// ユーザー情報入力
///
class _RowUserProfile extends StatelessWidget {
  const _RowUserProfile();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.person_add_alt_sharp, size: 32),
      title: const Text('ユーザー情報'),
      subtitle: const Text('ユーザー情報を登録します'),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: () {
        UserProfilePage.start(context);
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
/// Googleサインイン
///
class _SignInButton extends ConsumerWidget {
  const _SignInButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GoogleSignInButton(
      onPressed: () async {
        await ref.read(settingsControllerProvider.notifier).signInWithGoogle();
      },
    );
  }
}

///
/// Googleサインアウト
///
class _SignOutButton extends ConsumerWidget {
  const _SignOutButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OutlinedButton(
      child: const Text('Googleからサインアウトする'),
      onPressed: () {
        AppDialog.okAndCancel(
          message: 'Googleアカウントからサインアウトします。よろしいですか？',
          onOk: () async {
            await ref.read(settingsControllerProvider.notifier).signOutWithGoogle();
          },
        ).show(context);
      },
    );
  }
}
