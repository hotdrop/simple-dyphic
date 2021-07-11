import 'package:flutter/material.dart';
import 'package:simple_dyphic/model/record.dart';
import 'package:simple_dyphic/res/R.dart';

///
/// テーマ変更アイコン
///
class ChangeThemeIcon extends StatelessWidget {
  const ChangeThemeIcon(this.isDarkMode);

  final bool isDarkMode;

  @override
  Widget build(BuildContext context) {
    final iconData = (isDarkMode) ? Icons.brightness_7 : Icons.brightness_4;
    final iconColor = (isDarkMode) ? Colors.blue[900]! : Colors.blue[200]!;
    return Icon(
      iconData,
      color: iconColor,
      size: R.res.integers.settingsPageIconSize,
    );
  }
}

///
/// 体調アイコン
///
class ConditionIcon extends StatelessWidget {
  const ConditionIcon._(this._type, this._size);

  factory ConditionIcon.normal(ConditionType type) {
    return ConditionIcon._(type, R.res.integers.recordPageIconSize);
  }

  factory ConditionIcon.small(ConditionType type) {
    return ConditionIcon._(type, R.res.integers.calendarIconSize);
  }

  final ConditionType _type;
  final double _size;

  @override
  Widget build(BuildContext context) {
    IconData icon;
    if (_type == ConditionType.bad) {
      icon = Icons.sentiment_very_dissatisfied_sharp;
    } else if (_type == ConditionType.good) {
      icon = Icons.sentiment_very_satisfied_sharp;
    } else {
      icon = Icons.sentiment_satisfied_sharp;
    }
    return Icon(icon, size: _size);
  }
}

///
/// 散歩アイコン
///
class WalkingIcon extends StatelessWidget {
  const WalkingIcon._(this._size);

  factory WalkingIcon.normal() {
    return WalkingIcon._(R.res.integers.recordPageIconSize);
  }

  factory WalkingIcon.onCalendar() {
    return WalkingIcon._(R.res.integers.calendarIconSize);
  }

  final double _size;

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.directions_walk, size: _size);
  }
}
