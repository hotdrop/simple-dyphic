import 'package:flutter/material.dart';

class AppColors {
  AppColors._({
    required this.primaryColor,
    required this.accentColor,
    required this.primaryColorDark,
    required this.accentColorDark,
    required this.statusBarColor,
    required this.selectCalender,
    required this.mealBreakFast,
    required this.mealLunch,
    required this.mealDinner,
    required this.condition,
    required this.conditionNight,
    required this.walking,
  });

  factory AppColors.init() {
    return AppColors._(
      primaryColor: Colors.lightBlue,
      accentColor: Colors.blueAccent,
      primaryColorDark: Color(0xFF0000FF),
      accentColorDark: Color(0xFF3333FF),
      statusBarColor: Color(0xFF0D0D0D),
      selectCalender: Color(0xFF66CCFF),
      mealBreakFast: Color(0xFFFA6B72),
      mealLunch: Color(0xFFFCA41F),
      mealDinner: Color(0xFF3D2EAD),
      condition: Color(0xFFA2FD87),
      conditionNight: Color(0xFF28A305),
      walking: Color(0xFF365FEF),
    );
  }

  final Color primaryColor;
  final Color primaryColorDark;
  final Color accentColor;
  final Color accentColorDark;

  final Color statusBarColor;
  final Color selectCalender;

  final Color mealBreakFast;
  final Color mealLunch;
  final Color mealDinner;

  final Color condition;
  final Color conditionNight;
  final Color walking;
}
