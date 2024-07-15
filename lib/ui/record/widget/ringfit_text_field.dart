import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RingfitTextField extends StatefulWidget {
  const RingfitTextField({
    super.key,
    required this.label,
    required this.initValue,
    required this.onChanged,
  });

  final String label;
  final double? initValue;
  final void Function(double?) onChanged;

  @override
  State<RingfitTextField> createState() => _RingfitTextFieldState();
}

class _RingfitTextFieldState extends State<RingfitTextField> {
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
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d{0,3}(\.\d{0,2})?$')),
      ],
      maxLines: 1,
      decoration: InputDecoration(
        labelText: widget.label,
        border: const OutlineInputBorder(),
      ),
      onChanged: (String? value) {
        if (value == null) {
          return;
        }
        final valueDouble = double.tryParse(value);
        widget.onChanged(valueDouble);
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
