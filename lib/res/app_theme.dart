import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_dyphic/res/R.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData light = ThemeData.light().copyWith(
    primaryColor: R.res.colors.primaryColor,
    accentColor: R.res.colors.accentColor,
    primaryColorDark: R.res.colors.primaryColorDark,
    backgroundColor: Colors.white,
    dividerColor: R.res.colors.accentColor,
    toggleableActiveColor: R.res.colors.primaryColor,
    appBarTheme: AppBarTheme(
      centerTitle: true,
      backgroundColor: Colors.white,
      titleTextStyle: TextStyle(color: Colors.black87),
      iconTheme: IconThemeData(color: Colors.black87),
      backwardsCompatibility: false,
      systemOverlayStyle: (Platform.isAndroid) ? SystemUiOverlayStyle(statusBarColor: R.res.colors.statusBarColor) : null,
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        primary: R.res.colors.accentColor,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: R.res.colors.primaryColor,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
      primary: R.res.colors.accentColor,
    )),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: R.res.colors.primaryColor,
    ),
  );

  static final ThemeData dark = ThemeData.dark().copyWith(
    primaryColor: R.res.colors.primaryColor,
    accentColor: R.res.colors.accentColorDark,
    scaffoldBackgroundColor: Color(0xFF232323),
    applyElevationOverlayColor: true,
    dividerColor: R.res.colors.accentColor,
    toggleableActiveColor: R.res.colors.accentColor,
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        primary: R.res.colors.accentColor,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: R.res.colors.primaryColor,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
      primary: R.res.colors.accentColor,
    )),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: R.res.colors.primaryColor,
    ),
  );
}
