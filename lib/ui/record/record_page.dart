import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_dyphic/model/record.dart';
import 'package:simple_dyphic/res/R.dart';
import 'package:simple_dyphic/ui/record/record_view_model.dart';
import 'package:simple_dyphic/ui/record/widget_meal_card.dart';
import 'package:simple_dyphic/ui/widget/app_check_box.dart';
import 'package:simple_dyphic/ui/widget/app_dialog.dart';
import 'package:simple_dyphic/ui/widget/app_text_field.dart';
import 'package:simple_dyphic/ui/widget/condition_radio_group.dart';

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
    return WillPopScope(
      onWillPop: () async {
        final isUpdate = context.read(recordViewModelProvider).isUpdate;
        if (isUpdate) {
          AppDialog.okAndCancel(
            message: R.res.strings.recordCloseAttensionMessage,
            onOk: () async {
              Navigator.pop(context, false);
            },
          ).show(context);
        } else {
          Navigator.pop(context, false);
        }
        return false;
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(title: Text(_record.showFormatDate())),
          body: Consumer(
            builder: (context, watch, child) {
              final uiState = watch(recordViewModelProvider).uiState;
              return uiState.when(
                loading: () => _onLoading(context),
                success: () => _onSuccess(context),
                error: (err) => _onError(context, '$err'),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _onLoading(BuildContext context) {
    Future<void>.delayed(Duration.zero).then((_) {
      context.read(recordViewModelProvider).init(_record);
    });
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
          _viewMealArea(context),
          const SizedBox(height: 16),
          ..._viewCondition(context),
          const SizedBox(height: 16),
          _viewCheckBoxes(context),
          _viewConditionMemo(context),
          const SizedBox(height: 16),
          _viewSaveButton(context),
        ],
      ),
    );
  }

  Widget _viewMealArea(BuildContext context) {
    final viewModel = context.read(recordViewModelProvider);
    return Column(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              MealCard.breakfast(
                initValue: _record.breakfast,
                onChanged: (String? v) => viewModel.inputBreakfast(v),
              ),
              const SizedBox(width: 4),
              MealCard.lunch(
                initValue: _record.lunch,
                onChanged: (String? v) => viewModel.inputLunch(v),
              ),
              const SizedBox(width: 4),
              MealCard.dinner(
                initValue: _record.dinner,
                onChanged: (String? v) => viewModel.inputDinner(v),
              ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _viewCondition(BuildContext context) {
    return <Widget>[
      Center(
        child: Text(R.res.strings.recordConditionOverview),
      ),
      const SizedBox(height: 16),
      ConditionRadioGroup(
        initSelectValue: _record.getConditionType(),
        onSelected: (newVal) => context.read(recordViewModelProvider).selectCondition(newVal),
      ),
    ];
  }

  Widget _viewCheckBoxes(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AppCheckBox.walking(
          initValue: _record.isWalking,
          onChecked: (bool isCheck) {
            context.read(recordViewModelProvider).inputIsWalking(isCheck);
          },
        ),
        AppCheckBox.toilet(
          initValue: _record.isToilet,
          onChecked: (bool isCheck) {
            context.read(recordViewModelProvider).inputIsToilet(isCheck);
          },
        ),
      ],
    );
  }

  Widget _viewConditionMemo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: MultiLineTextField(
        label: R.res.strings.recordConditionMemoTitle,
        initValue: _record.conditionMemo,
        limitLine: 7,
        hintText: R.res.strings.recordConditionMemoHint,
        onChanged: context.read(recordViewModelProvider).inputConditionMemo,
      ),
    );
  }

  Widget _viewSaveButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: ElevatedButton(
        onPressed: () async {
          await context.read(recordViewModelProvider).save();
          Navigator.pop(context, true);
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(R.res.strings.recordSaveButton),
        ),
      ),
    );
  }
}
