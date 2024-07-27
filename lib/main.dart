import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:simple_dyphic/initialize_provider.dart';
import 'package:simple_dyphic/res/app_theme.dart';
import 'package:simple_dyphic/ui/main_page.dart';

void main() {
  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ja', '')],
      title: '体調管理',
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      home: ref.watch(initializerProvider).when(
            data: (_) => const MainPage(),
            error: (error, stackTrace) => _ViewErrorScreen('$error'),
            loading: () => const _ViewLoadingScreen(),
          ),
    );
  }
}

class _ViewLoadingScreen extends StatelessWidget {
  const _ViewLoadingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('体調管理'),
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _ViewErrorScreen extends StatelessWidget {
  const _ViewErrorScreen(this.errorMessage);

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('体調管理'),
      ),
      body: Center(
        child: Text('エラーが発生しました。\n$errorMessage', style: const TextStyle(color: Colors.red)),
      ),
    );
  }
}
