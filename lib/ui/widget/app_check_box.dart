import 'package:flutter/material.dart';
import 'package:simple_dyphic/res/R.dart';

class AppCheckBox extends StatefulWidget {
  AppCheckBox._(this.isWalking, this.initValue, this.onChecked);

  factory AppCheckBox.walking({required bool initValue, required Function(bool) onChecked}) {
    return AppCheckBox._(true, initValue, onChecked);
  }

  factory AppCheckBox.toilet({required bool initValue, required Function(bool) onChecked}) {
    return AppCheckBox._(false, initValue, onChecked);
  }

  final bool isWalking;
  final bool initValue;
  final Function(bool) onChecked;

  @override
  _AppCheckBoxState createState() => _AppCheckBoxState();
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
    if (widget.isWalking) {
      return Text(R.res.strings.recordWalkingLabel, style: TextStyle(fontSize: 20));
    } else {
      return Text(R.res.strings.recordToileLabel, style: TextStyle(fontSize: 20));
    }
  }
}
