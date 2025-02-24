import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_dyphic/ui/analysis/analysis_provider.dart';

class AnalysisPage extends ConsumerWidget {
  const AnalysisPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
            // TODO グラフとか
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(analysisProvider.notifier).generateAdvice(),
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
