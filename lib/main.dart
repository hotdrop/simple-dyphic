import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:simple_dyphic/res/R.dart';
import 'package:simple_dyphic/res/app_theme.dart';
import 'package:simple_dyphic/ui/main_page.dart';

void main() {
  R.init();
  runApp(const ProviderScope(child: App()));
}

class App extends ConsumerWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('ja', '')],
      title: R.res.strings.appTitle,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      home: const MainPage(),
    );
  }
}
