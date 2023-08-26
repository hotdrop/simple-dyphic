import 'package:flutter/material.dart';

class AppCheckBox extends StatefulWidget {
  const AppCheckBox._(this.isExercise, this.initValue, this.onChecked);

  factory AppCheckBox.exercise({required bool initValue, required Function(bool) onChecked}) {
    return AppCheckBox._(true, initValue, onChecked);
  }

  factory AppCheckBox.toilet({required bool initValue, required Function(bool) onChecked}) {
    return AppCheckBox._(false, initValue, onChecked);
  }

  final bool isExercise;
  final bool initValue;
  final Function(bool) onChecked;

  @override
  State<AppCheckBox> createState() => _AppCheckBoxState();
}

class _AppCheckBoxState extends State<AppCheckBox> {
  bool _currentValue = false;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: _currentValue,
          onChanged: (bool? isCheck) {
            if (isCheck != null) {
              setState(() {
                _currentValue = isCheck;
              });
              widget.onChecked(isCheck);
            }
          },
        ),
        _viewLabel(),
      ],
    );
  }

  Widget _viewLabel() {
    if (widget.isExercise) {
      return const Text('🏃‍♂️運動した', style: TextStyle(fontSize: 20));
    } else {
      return const Text('💩排便した', style: TextStyle(fontSize: 20));
    }
  }
}
