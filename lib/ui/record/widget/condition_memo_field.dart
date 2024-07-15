import 'package:flutter/material.dart';

class ConditionMemoField extends StatefulWidget {
  const ConditionMemoField({
    super.key,
    required this.initValue,
    required this.onChanged,
  });

  final String? initValue;
  final void Function(String) onChanged;

  @override
  State<ConditionMemoField> createState() => _ConditionMemoFieldState();
}

class _ConditionMemoFieldState extends State<ConditionMemoField> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initValue?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      maxLines: 4,
      decoration: const InputDecoration(
        labelText: '体調メモ',
        border: OutlineInputBorder(),
      ),
      onChanged: (String value) => widget.onChanged(value),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
