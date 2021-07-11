import 'package:flutter/material.dart';
import 'package:simple_dyphic/common/app_logger.dart';
import 'package:simple_dyphic/model/record.dart';
import 'package:simple_dyphic/ui/widget/app_icon.dart';

class ConditionRadioGroup extends StatefulWidget {
  const ConditionRadioGroup({
    required this.initSelectValue,
    required this.onSelected,
  });

  final ConditionType? initSelectValue;
  final Function(ConditionType) onSelected;

  @override
  _ConditionRadioGroupState createState() => _ConditionRadioGroupState();
}

class _ConditionRadioGroupState extends State<ConditionRadioGroup> {
  ConditionType? _selectType;

  @override
  void initState() {
    super.initState();
    _selectType = widget.initSelectValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: ConditionType.values.map((type) => _typeRadio(context, type)).toList(),
    );
  }

  Widget _typeRadio(BuildContext context, ConditionType type) {
    return Column(
      children: [
        ConditionIcon.normal(type),
        Radio<ConditionType>(
          value: type,
          groupValue: _selectType,
          onChanged: (ConditionType? newVal) {
            AppLogger.d('選択した値は ${Condition.toStr(newVal)}');
            if (newVal != null) {
              setState(() {
                _selectType = newVal;
              });
              widget.onSelected(newVal);
            }
          },
        )
      ],
    );
  }
}
