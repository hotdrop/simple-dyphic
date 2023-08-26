import 'package:flutter/material.dart';
import 'package:simple_dyphic/model/record.dart';
import 'package:simple_dyphic/ui/widget/condition_icon.dart';

class ConditionRadioGroup extends StatefulWidget {
  const ConditionRadioGroup({
    Key? key,
    required this.initSelectValue,
    required this.onSelected,
  }) : super(key: key);

  final ConditionType? initSelectValue;
  final Function(ConditionType) onSelected;

  @override
  State<ConditionRadioGroup> createState() => _ConditionRadioGroupState();
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
        ConditionIcon.onRadioGroup(type: type, size: 50, selected: type == _selectType),
        Radio<ConditionType>(
          value: type,
          groupValue: _selectType,
          onChanged: (ConditionType? newVal) {
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
