import 'package:flutter/material.dart';

class AppColors {
  AppColors._({
    required this.primaryColor,
    required this.accentColor,
    required this.primaryColorDark,
    required this.accentColorDark,
    required this.statusBarColor,
    required this.mealBreakFast,
    required this.mealLunch,
    required this.mealDinner,
    required this.condition,
    required this.conditionNight,
    required this.walking,
  });

  factory AppColors.init() {
    return AppColors._(
      primaryColor: Color(0xFFF48FB1),
      accentColor: Colors.pinkAccent,
      primaryColorDark: Color(0xFFC2185B),
      accentColorDark: Color(0xFFF06292),
      statusBarColor: Color(0xFFC2185B),
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

  final Color mealBreakFast;
  final Color mealLunch;
  final Color mealDinner;

  final Color condition;
  final Color conditionNight;
  final Color walking;
}
