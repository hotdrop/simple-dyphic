import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_dyphic/res/R.dart';

import 'package:simple_dyphic/res/app_theme.dart';
import 'package:simple_dyphic/model/app_settings.dart';
import 'package:simple_dyphic/ui/main_page.dart';

void main() {
  R.init();
  runApp(ProviderScope(child: App()));
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, watch, child) {
      final state = watch(appSettingsProvider);
      if (state != null) {
        return MaterialApp(
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [Locale('ja', '')],
          title: R.res.strings.appTitle,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: MainPage(),
        );
      } else {
        return _SplashScreen();
      }
    });
  }
}

class _SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
