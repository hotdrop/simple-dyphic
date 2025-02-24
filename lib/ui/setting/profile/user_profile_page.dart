import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_dyphic/model/user_profile.dart';
import 'package:simple_dyphic/ui/setting/profile/user_profile_provider.dart';

class UserProfilePage extends ConsumerWidget {
  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ユーザー情報'),
      ),
      body: ref.watch(userProfileControllerProvider).when(
            data: (data) => _ViewBody(data),
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
  const _ViewBody(this.profile);

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _UserProfileCard(profile),
        // TODO 保存ボタンとクローズ処理
      ],
    );
  }
}

class _UserProfileCard extends ConsumerWidget {
  const _UserProfileCard(this.profile);

  final UserProfile profile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('プロフィール情報', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            // TODO 生年月日の入力を実装する必要がある
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: '身長 (cm)'),
              keyboardType: TextInputType.number,
              initialValue: profile.height?.toString(),
              onChanged: (value) {
                final newVal = double.tryParse(value);
                if (newVal != null) {
                  ref.read(userProfileControllerProvider.notifier).inputHeight(newVal);
                }
              },
            ),
            const SizedBox(height: 8),
            TextFormField(
              decoration: const InputDecoration(labelText: '体重'),
              keyboardType: TextInputType.number,
              initialValue: profile.weight?.toString(),
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
