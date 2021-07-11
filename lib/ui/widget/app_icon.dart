import 'package:flutter/material.dart';
import 'package:simple_dyphic/res/R.dart';

class AppIcon extends StatelessWidget {
  const AppIcon._(this._iconData, this._iconColor, this.size);

  factory AppIcon.condition(bool isDarkMode, {double? size}) {
    Color c = (isDarkMode) ? R.res.colors.conditionNight : R.res.colors.condition;
    return AppIcon._(Icons.sentiment_satisfied_rounded, c, size);
  }

  factory AppIcon.changeTheme(bool isDarkMode, {double? size}) {
    final icon = (isDarkMode) ? Icons.brightness_7 : Icons.brightness_4;
    Color c = (isDarkMode) ? Colors.blue[900]! : Colors.pink[200]!;
    return AppIcon._(icon, c, size);
  }

  final IconData _iconData;
  final Color _iconColor;
  final double? size;

  @override
  Widget build(BuildContext context) {
    if (size != null) {
      return Icon(
        _iconData,
        color: _iconColor,
        size: size,
      );
    } else {
      return Icon(_iconData, color: _iconColor);
    }
  }
}
