import 'package:flutter/material.dart';
import 'package:simple_dyphic/res/R.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData dark = ThemeData.dark().copyWith(
    primaryColor: R.res.colors.primaryColor,
    primaryColorDark: R.res.colors.accentColorDark,
    scaffoldBackgroundColor: const Color(0xFF232323),
    applyElevationOverlayColor: true,
    dividerColor: R.res.colors.accentColor,
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: R.res.colors.accentColor,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: R.res.colors.primaryColor,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: R.res.colors.accentColor,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: R.res.colors.primaryColor,
    ),
  );
}
