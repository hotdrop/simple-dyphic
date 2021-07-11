import 'package:flutter/material.dart';
import 'package:simple_dyphic/res/R.dart';

class MealEditDialog extends StatefulWidget {
  const MealEditDialog({
    required this.title,
    this.initValue,
  });

  final String title;
  final String? initValue;

  @override
  _MealEditDialogState createState() => _MealEditDialogState();
}

class _MealEditDialogState extends State<MealEditDialog> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initValue?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        autofocus: true,
        controller: _controller,
        maxLines: 7,
        decoration: InputDecoration(
          labelText: R.res.strings.recordMealDialogHint,
          border: const OutlineInputBorder(),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(R.res.strings.dialogCancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop<String>(context, _controller.text),
          child: Text(R.res.strings.dialogOk),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
