import 'package:flutter/material.dart';

class ToiletCheckBox extends StatefulWidget {
  const ToiletCheckBox({super.key, required this.initValue, required this.onChecked});

  final bool initValue;
  final Function(bool) onChecked;

  @override
  State<ToiletCheckBox> createState() => _ToiletCheckBoxState();
}

class _ToiletCheckBoxState extends State<ToiletCheckBox> {
  bool _currentValue = false;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
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
        const Text('💩 排便した', style: TextStyle(fontSize: 20)),
      ],
    );
  }
}
