import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_dyphic/ui/analysis/analysis_provider.dart';

class AnalysisPage extends ConsumerWidget {
  const AnalysisPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(userProfileControllerProvider);
    final analysisState = ref.watch(analysisProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('運動分析'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // プロフィール入力セクション
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('プロフィール情報', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    TextFormField(
                      decoration: const InputDecoration(labelText: '年齢'),
                      keyboardType: TextInputType.number,
                      initialValue: userProfile.age?.toString(),
                      onChanged: (value) => ref.read(userProfileControllerProvider.notifier).updateAge(int.tryParse(value)),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: const InputDecoration(labelText: '身長 (cm)'),
                      keyboardType: TextInputType.number,
                      initialValue: userProfile.height?.toString(),
                      onChanged: (value) => ref.read(userProfileControllerProvider.notifier).updateHeight(double.tryParse(value)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(analysisProvider.notifier).generateAdvice(userProfile),
              child: const Text('運動分析を生成'),
            ),
            const SizedBox(height: 16),
            if (analysisState.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (analysisState.advice != null)
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Text(analysisState.advice!),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
