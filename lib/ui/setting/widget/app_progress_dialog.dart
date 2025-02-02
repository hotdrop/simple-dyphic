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
      if (context.mounted) {
        Navigator.pop(context);
        onSuccess(result);
      }
    } on Exception catch (e, s) {
      AppLogger.e('エラーが発生しました。', e, s);
      onError(e);
      if (context.mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> _showProgressDialog(BuildContext context) async {
    await showDialog<void>(
      context: context,
      builder: (_) {
        return const Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
