import 'package:flutter/material.dart';
import 'package:simple_dyphic/common/app_logger.dart';

class AppProgressDialog<T> {
  const AppProgressDialog();

  void show(
    BuildContext context, {
    required Future<T> Function() execute,
    required Function(T) onSuccess,
    required Function(Exception) onError,
  }) {
    _showProgressDialog(context);
    try {
      execute().then((result) {
        Navigator.pop(context);
        onSuccess(result);
      });
    } on Exception catch (e, s) {
      AppLogger.e('エラーが発生しました。', e, s);
      Navigator.pop(context);
      onError(e);
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
