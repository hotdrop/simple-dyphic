import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:simple_dyphic/res/R.dart';
import 'package:simple_dyphic/res/app_theme.dart';
import 'package:simple_dyphic/ui/main_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO ここでFirebaseの初期化をする
  await Firebase.initializeApp();
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
