import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    required this.label,
    this.initValue,
    this.hintText = '',
    required this.onChanged,
  });

  final String label;
  final String? initValue;
  final String hintText;
  final void Function(String) onChanged;

  @override
  _AppTextFieldState createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hintText,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
      initialValue: widget.initValue,
      onChanged: (String value) {
        setState(() {
          widget.onChanged(value);
        });
      },
    );
  }
}

///
/// 複数行のテキストフィールド
///
class MultiLineTextField extends StatefulWidget {
  const MultiLineTextField({
    required this.label,
    required this.initValue,
    required this.limitLine,
    required this.hintText,
    required this.onChanged,
  });

  final String label;
  final String? initValue;
  final int limitLine;
  final String hintText;
  final void Function(String) onChanged;

  @override
  _MultiLineTextFieldState createState() => _MultiLineTextFieldState();
}

class _MultiLineTextFieldState extends State<MultiLineTextField> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initValue.toString();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      maxLines: widget.limitLine,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hintText,
        border: const OutlineInputBorder(),
      ),
      style: TextStyle(fontSize: 14.0),
      onChanged: (String value) => widget.onChanged(value),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
