import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_dyphic/ui/setting/profile/user_profile_provider.dart';

class UserProfilePage extends ConsumerWidget {
  const UserProfilePage._();

  static Future<bool> start(BuildContext context) async {
    return await Navigator.push<bool>(
          context,
          MaterialPageRoute(builder: (_) => const UserProfilePage._()),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ユーザー情報'),
      ),
      body: ref.watch(userProfileControllerProvider).when(
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

class _ViewBody extends StatelessWidget {
  const _ViewBody();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _UserProfileCard(),
        SizedBox(height: 16),
        _SaveButton(),
      ],
    );
  }
}

class _UserProfileCard extends ConsumerWidget {
  const _UserProfileCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('プロフィール情報', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            // TODO 身長と体重もLeadingにアイコンを入れて左側を揃えたい
            ListTile(
              title: const Text('生年月日'),
              subtitle: Text(
                ref.watch(uiStateProvider).birthDate?.toString().split(' ')[0] ?? '未設定',
              ),
              onTap: () async {
                final selected = await showDatePicker(
                  context: context,
                  initialDate: ref.read(uiStateProvider).birthDate ?? DateTime(1970),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (selected != null) {
                  ref.read(userProfileControllerProvider.notifier).inputBirthDate(selected);
                }
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              decoration: const InputDecoration(
                labelText: '身長 (cm)',
                hintText: '小数点第一位まで入力可能',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              initialValue: ref.read(uiStateProvider).height?.toStringAsFixed(1),
              onChanged: (value) {
                final newVal = double.tryParse(value);
                if (newVal != null) {
                  ref.read(userProfileControllerProvider.notifier).inputHeight(newVal);
                }
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              decoration: const InputDecoration(
                labelText: '体重 (kg)',
                hintText: '小数点第一位まで入力可能',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              initialValue: ref.read(uiStateProvider).weight?.toStringAsFixed(1),
              onChanged: (value) {
                final newVal = double.tryParse(value);
                if (newVal != null) {
                  ref.read(userProfileControllerProvider.notifier).inputWeight(newVal);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SaveButton extends ConsumerWidget {
  const _SaveButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canSave = ref.watch(enableSaveProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: canSave
              ? () async {
                  await ref.read(userProfileControllerProvider.notifier).save();
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }
                }
              : null,
          child: const Text('保存'),
        ),
      ),
    );
  }
}
