import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:simple_dyphic/ui/calender/dyphic_calender.dart';
import 'package:simple_dyphic/ui/calender/calendar_view_model.dart';
import 'package:simple_dyphic/res/R.dart';
import 'package:simple_dyphic/ui/widget/app_dialog.dart';

class CalenderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(R.res.strings.calenderPageTitle),
      ),
      body: Consumer(
        builder: (context, watch, child) {
          final uiState = watch(calendarViewModelProvider).uiState;
          return uiState.when(
            loading: () => _onLoading(),
            success: () => _onSuccess(context),
            error: (err) => _onError(context, '$err'),
          );
        },
      ),
    );
  }

  Widget _onLoading() {
    return Center(
      child: const CircularProgressIndicator(),
    );
  }

  Widget _onError(BuildContext context, String errMsg) {
    Future<void>.delayed(Duration.zero).then((_) {
      AppDialog.ok(message: errMsg).show(context);
    });
    return Center(
      child: const CircularProgressIndicator(),
    );
  }

  Widget _onSuccess(BuildContext context) {
    return DyphicCalendar(
      records: context.read(calendarViewModelProvider).records,
      onReturnEditPage: (bool isUpdate) {
        if (isUpdate) {
          context.read(calendarViewModelProvider).refresh();
        }
      },
    );
  }
}
