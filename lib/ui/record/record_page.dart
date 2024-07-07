import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_dyphic/model/record.dart';
import 'package:simple_dyphic/ui/record/record_provider.dart';
import 'package:simple_dyphic/ui/record/widget_meal_card.dart';
import 'package:simple_dyphic/ui/widget/app_check_box.dart';
import 'package:simple_dyphic/ui/widget/app_dialog.dart';
import 'package:simple_dyphic/ui/widget/app_text_field.dart';
import 'package:simple_dyphic/ui/widget/condition_radio_group.dart';

class RecordPage extends ConsumerWidget {
  const RecordPage._(this.record);

  static Future<bool> start(BuildContext context, Record record) async {
    return await Navigator.push<bool>(
          context,
          MaterialPageRoute(builder: (_) => RecordPage._(record)),
        ) ??
        false;
  }

  final Record record;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopScope(
      canPop: false, // 手動でpopする
      onPopInvoked: (bool didPop) {
        if (!didPop) {
          final isUpdate = ref.read(isUpdateRecordProvider);
          if (isUpdate) {
            AppDialog.okAndCancel(
              message: '内容が更新されていますが、保存せずに閉じてよろしいですか？',
              onOk: () async {
                ref.read(recordControllerProvider.notifier).clear();
                Navigator.pop(context, false);
              },
            ).show(context);
          } else {
            ref.read(recordControllerProvider.notifier).clear();
            Navigator.pop(context, false);
          }
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(title: Text(record.showFormatDate())),
          body: _ViewBody(record),
        ),
      ),
    );
  }
}

class _ViewBody extends StatelessWidget {
  const _ViewBody(this.record);

  final Record record;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      child: ListView(
        children: [
          _ViewMealArea(record),
          const SizedBox(height: 16),
          _ViewCondition(record),
          const SizedBox(height: 16),
          _ViewDayActionCheck(record),
          _ViewConditionMemo(record),
          const SizedBox(height: 16),
          _ViewSaveButton(record),
        ],
      ),
    );
  }
}

class _ViewMealArea extends ConsumerWidget {
  const _ViewMealArea(this.record);

  final Record record;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        SizedBox(
          height: 280,
          width: double.infinity,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              MealCard.breakfast(
                initValue: record.breakfast,
                onChanged: ref.read(recordControllerProvider.notifier).inputBreakfast,
              ),
              const SizedBox(width: 4),
              MealCard.lunch(
                initValue: record.lunch,
                onChanged: ref.read(recordControllerProvider.notifier).inputLunch,
              ),
              const SizedBox(width: 4),
              MealCard.dinner(
                initValue: record.dinner,
                onChanged: ref.read(recordControllerProvider.notifier).inputDinner,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ViewCondition extends ConsumerWidget {
  const _ViewCondition(this.record);

  final Record record;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConditionRadioGroup(
      initSelectValue: record.getConditionType(),
      onSelected: (newVal) => ref.read(recordControllerProvider.notifier).selectCondition(newVal),
    );
  }
}

class _ViewDayActionCheck extends ConsumerWidget {
  const _ViewDayActionCheck(this.record);

  final Record record;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        AppCheckBox.exercise(
          initValue: record.isExercise,
          onChecked: (bool isCheck) {
            ref.read(recordControllerProvider.notifier).inputIsExercise(isCheck);
          },
        ),
        AppCheckBox.toilet(
          initValue: record.isToilet,
          onChecked: (bool isCheck) {
            ref.read(recordControllerProvider.notifier).inputIsToilet(isCheck);
          },
        ),
      ],
    );
  }
}

class _ViewConditionMemo extends ConsumerWidget {
  const _ViewConditionMemo(this.record);

  final Record record;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: MultiLineTextField(
        label: '体調メモ',
        initValue: record.conditionMemo,
        limitLine: 7,
        hintText: '細かい体調はこちらに記載しましょう！',
        onChanged: ref.read(recordControllerProvider.notifier).inputConditionMemo,
      ),
    );
  }
}

class _ViewSaveButton extends ConsumerWidget {
  const _ViewSaveButton(this.record);

  final Record record;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: ElevatedButton(
        onPressed: () {
          ref.read(recordControllerProvider.notifier).save(record).then((_) {
            ref.read(recordControllerProvider.notifier).clear();
            Navigator.pop(context, true);
          });
        },
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text('保存する'),
        ),
      ),
    );
  }
}
