import 'package:flutter/material.dart';
import 'package:simple_dyphic/res/colors.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData dark = ThemeData.dark().copyWith(
    primaryColor: AppColors.primaryColor,
    primaryColorDark: AppColors.accentColorDark,
    scaffoldBackgroundColor: const Color(0xFF232323),
    applyElevationOverlayColor: true,
    dividerColor: AppColors.accentColor,
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColors.accentColor,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: AppColors.accentColor,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryColor,
    ),
  );
}
