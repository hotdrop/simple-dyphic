import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:simple_dyphic/res/app_theme.dart';
import 'package:simple_dyphic/model/app_settings.dart';
import 'package:simple_dyphic/ui/main_page.dart';
import 'package:simple_dyphic/res/R.dart';

class App extends ConsumerWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appSettingsProvider);

    if (state == null) {
      return _SplashScreen();
    } else {
      return MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [Locale('ja', '')],
        title: R.res.strings.appTitle,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        home: MainPage(),
      );
    }
  }
}

class _SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
