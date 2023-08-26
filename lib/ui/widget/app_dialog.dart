import 'package:flutter/material.dart';

class AppDialog {
  const AppDialog._(this._message, this._onOk, this._onCancel);

  factory AppDialog.ok({required String message, Function? onOk}) {
    return AppDialog._(message, onOk, null);
  }

  factory AppDialog.okAndCancel({required String message, required Function onOk, Function? onCancel}) {
    if (onCancel == null) {
      return AppDialog._(message, onOk, () {});
    } else {
      return AppDialog._(message, onOk, onCancel);
    }
  }

  final String _message;
  final Function? _onOk;
  final Function? _onCancel;

  void show(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) {
        return _createDialog(context);
      },
    );
  }

  AlertDialog _createDialog(BuildContext context) {
    return AlertDialog(
      content: Text(_message),
      actions: <Widget>[
        if (_onCancel != null)
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _onCancel!.call();
            },
            child: const Text('キャンセル'),
          ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            _onOk?.call();
          },
          child: const Text('OK'),
        ),
      ],
    );
  }
}
