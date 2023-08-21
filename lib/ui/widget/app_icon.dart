import 'package:flutter/material.dart';
import 'package:simple_dyphic/model/record.dart';

///
/// テーマ変更アイコン
///
class ChangeThemeIcon extends StatelessWidget {
  const ChangeThemeIcon({Key? key, required this.isDarkMode, required this.size}) : super(key: key);

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
  const ConditionIcon._(this._type, this._size, this._selected);

  factory ConditionIcon.onRadioGroup({required ConditionType type, required double size, required bool selected}) {
    return ConditionIcon._(type, size, selected);
  }

  factory ConditionIcon.onCalendar({required ConditionType type, required double size}) {
    return ConditionIcon._(type, size, true);
  }

  final ConditionType _type;
  final double _size;
  final bool _selected;

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color iconColor;
    if (_type == ConditionType.bad) {
      icon = Icons.sentiment_very_dissatisfied_sharp;
      iconColor = _selected ? Colors.red : Colors.grey;
    } else if (_type == ConditionType.normal) {
      icon = Icons.sentiment_satisfied_sharp;
      iconColor = _selected ? Colors.orange : Colors.grey;
    } else if (_type == ConditionType.good) {
      icon = Icons.sentiment_very_satisfied_sharp;
      iconColor = _selected ? Colors.blue : Colors.grey;
    } else {
      throw UnimplementedError('ConditionIconにおかしなステータスが設定されています type=$_type');
    }
    return Icon(icon, color: iconColor, size: _size);
  }
}
