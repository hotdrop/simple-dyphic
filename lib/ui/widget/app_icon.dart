import 'package:flutter/material.dart';
import 'package:simple_dyphic/model/record.dart';

///
/// テーマ変更アイコン
///
class ChangeThemeIcon extends StatelessWidget {
  const ChangeThemeIcon({required this.isDarkMode, required this.size});

  final bool isDarkMode;
  final double size;

  @override
  Widget build(BuildContext context) {
    final iconData = (isDarkMode) ? Icons.brightness_7 : Icons.brightness_4;
    final iconColor = (isDarkMode) ? Colors.blue[900]! : Colors.blue[200]!;
    return Icon(
      iconData,
      color: iconColor,
      size: size,
    );
  }
}

///
/// 体調アイコン
///
class ConditionIcon extends StatelessWidget {
  const ConditionIcon({required this.type, required this.size});

  final ConditionType type;
  final double size;

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color iconColor;
    if (type == ConditionType.bad) {
      icon = Icons.sentiment_very_dissatisfied_sharp;
      iconColor = Colors.red;
    } else if (type == ConditionType.normal) {
      iconColor = Colors.orange;
      icon = Icons.sentiment_satisfied_sharp;
    } else if (type == ConditionType.good) {
      iconColor = Colors.blue;
      icon = Icons.sentiment_very_satisfied_sharp;
    } else {
      throw UnimplementedError('ConditionIconにおかしなステータスが設定されています type=$type');
    }
    return Icon(icon, color: iconColor, size: size);
  }
}
