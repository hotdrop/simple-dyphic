import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:simple_dyphic/model/app_settings.dart';
import 'package:simple_dyphic/model/record.dart';
import 'package:simple_dyphic/res/R.dart';
import 'package:simple_dyphic/ui/calender/record/record_view_model.dart';
import 'package:simple_dyphic/ui/calender/record/widget_meal_card.dart';
import 'package:simple_dyphic/ui/widget/app_icon.dart';
import 'package:simple_dyphic/ui/widget/app_dialog.dart';
import 'package:simple_dyphic/ui/widget/app_text_field.dart';

class RecordPage extends StatelessWidget {
  const RecordPage._(this._record);

  static Future<bool> start(BuildContext context, Record record) async {
    return await Navigator.push<bool>(
          context,
          MaterialPageRoute(builder: (_) => RecordPage._(record)),
        ) ??
        false;
  }

  final Record _record;

  @override
  Widget build(BuildContext context) {
    final headerTitle = DateFormat(R.res.strings.recordPageTitleDateFormat).format(_record.date);
    return WillPopScope(
      onWillPop: () async {
        final isUpdate = context.read(recordViewModelProvider).isUpdate;
        if (isUpdate) {
          await context.read(recordViewModelProvider).save();
          Navigator.pop(context, true);
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(title: Text(headerTitle)),
        body: Consumer(
          builder: (context, watch, child) {
            final uiState = watch(recordViewModelProvider).uiState;
            return uiState.when(
              loading: () => _onLoading(),
              success: () => _onSuccess(context),
              error: (err) => _onError(context, '$err'),
            );
          },
        ),
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
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0, bottom: 16.0),
      child: ListView(
        children: <Widget>[
          _mealViewArea(context),
          const SizedBox(height: 16.0),
          _conditionViewArea(context),
          const SizedBox(height: 16.0),
        ],
      ),
    );
  }

  Widget _mealViewArea(BuildContext context) {
    final viewModel = context.read(recordViewModelProvider);
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              MealCard(
                type: MealType.morning,
                detail: _record.breakfast,
                onEditValue: (String? newVal) {
                  viewModel.inputBreakfast(newVal);
                },
              ),
              const SizedBox(width: 4),
              MealCard(
                type: MealType.lunch,
                detail: _record.lunch,
                onEditValue: (String? newVal) {
                  viewModel.inputLunch(newVal);
                },
              ),
              const SizedBox(width: 4),
              MealCard(
                type: MealType.dinner,
                detail: _record.dinner,
                onEditValue: (String? newVal) {
                  viewModel.inputDinner(newVal);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _conditionViewArea(BuildContext context) {
    final viewModel = context.read(recordViewModelProvider);
    final isDarkMode = context.read(appSettingsProvider)!.isDarkMode;
    return Card(
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _contentsTitle(
              title: R.res.strings.recordConditionTitle,
              icon: AppIcon.condition(isDarkMode),
            ),
            const Divider(),
            // TODO 体調を顔によって3つ表示する
            const Divider(),
            Row(
              children: [
                Checkbox(
                  value: _record.isWalking,
                  onChanged: (bool? isCheck) => viewModel.inputIsWalking(isCheck),
                ),
                Text(R.res.strings.recordWalkingLabel),
              ],
            ),
            MultiLineTextField(
              label: R.res.strings.recordConditionMemoTitle,
              initValue: _record.conditionMemo,
              limitLine: 10,
              hintText: R.res.strings.recordConditionMemoHint,
              onChanged: viewModel.inputConditionMemo,
            ),
          ],
        ),
      ),
    );
  }

  Widget _contentsTitle({required String title, required AppIcon icon}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        icon,
        const SizedBox(width: 8),
        Text(title),
      ],
    );
  }
}
