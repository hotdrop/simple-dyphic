import 'package:flutter/material.dart';
import 'package:simple_dyphic/common/app_logger.dart';

class AppProgressDialog<T> {
  const AppProgressDialog();

  Future<void> show(
    BuildContext context, {
    required Future<T> Function() execute,
    required Function(T) onSuccess,
    required Function(Exception) onError,
  }) async {
    _showProgressDialog(context);
    try {
      final result = await execute();
      _closeDialog(context);
      onSuccess(result);
    } on Exception catch (e, s) {
      AppLogger.e('エラーが発生しました。', e, s);
      _closeDialog(context);
      onError(e);
    }
  }

  Future<void> _showProgressDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(
            child: const CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  void _closeDialog(BuildContext context) {
    Navigator.pop(context);
  }
}
