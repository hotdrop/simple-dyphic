import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_dyphic/model/record.dart';
import 'package:simple_dyphic/res/images.dart';
import 'package:simple_dyphic/ui/record/record_provider.dart';
import 'package:simple_dyphic/ui/record/widget/meal_card.dart';
import 'package:simple_dyphic/ui/record/widget/ringfit_text_field.dart';
import 'package:simple_dyphic/ui/record/widget/toilet_check_box.dart';
import 'package:simple_dyphic/ui/widget/app_dialog.dart';
import 'package:simple_dyphic/ui/record/widget/condition_memo_field.dart';
import 'package:simple_dyphic/ui/record/widget/condition_radio_group.dart';

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
      onPopInvoked: (bool didPop) => _onPopInvoked(context, ref, didPop),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('体調記録'),
          ),
          body: _ViewBody(record),
        ),
      ),
    );
  }

  Future<void> _onPopInvoked(BuildContext context, WidgetRef ref, bool didPop) async {
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
  }
}

class _ViewBody extends StatelessWidget {
  const _ViewBody(this.record);

  final Record record;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: Column(
          children: [
            _ViewTitle(record.showFormatDate()),
            const SizedBox(height: 16),
            _ViewMealArea(breakfast: record.breakfast, lunch: record.lunch, dinner: record.dinner),
            const SizedBox(height: 16),
            _ViewCondition(record.getConditionType()),
            const SizedBox(height: 16),
            _ViewToiletCheckBox(record.isToilet),
            const _ViewRingfitTitle(),
            _ViewRingfitResult(ringfitKcal: record.ringfitKcal, ringfitKm: record.ringfitKm),
            const SizedBox(height: 16),
            _ViewConditionMemo(record),
            const SizedBox(height: 16),
            _ViewSaveButton(record),
          ],
        ),
      ),
    );
  }
}

class _ViewTitle extends StatelessWidget {
  const _ViewTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}

class _ViewMealArea extends ConsumerWidget {
  const _ViewMealArea({
    required this.breakfast,
    required this.lunch,
    required this.dinner,
  });

  final String? breakfast;
  final String? lunch;
  final String? dinner;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        SizedBox(
          height: 230,
          width: double.infinity,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              MealCard.breakfast(
                initValue: breakfast,
                onChanged: ref.read(recordControllerProvider.notifier).inputBreakfast,
              ),
              const SizedBox(width: 4),
              MealCard.lunch(
                initValue: lunch,
                onChanged: ref.read(recordControllerProvider.notifier).inputLunch,
              ),
              const SizedBox(width: 4),
              MealCard.dinner(
                initValue: dinner,
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
  const _ViewCondition(this.conditionType);

  final ConditionType? conditionType;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConditionRadioGroup(
      initSelectValue: conditionType,
      onSelected: (newVal) => ref.read(recordControllerProvider.notifier).selectCondition(newVal),
    );
  }
}

class _ViewToiletCheckBox extends ConsumerWidget {
  const _ViewToiletCheckBox(this.isToilet);

  final bool isToilet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ToiletCheckBox(
      initValue: isToilet,
      onChecked: (bool isCheck) {
        ref.read(recordControllerProvider.notifier).inputIsToilet(isCheck);
      },
    );
  }
}

class _ViewRingfitTitle extends StatelessWidget {
  const _ViewRingfitTitle();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 48,
          height: 48,
          child: Image.asset(Images.ringfitPath),
        ),
        const Text('リングフィット', style: TextStyle(fontSize: 20))
      ],
    );
  }
}

class _ViewRingfitResult extends ConsumerWidget {
  const _ViewRingfitResult({required this.ringfitKcal, required this.ringfitKm});

  final double? ringfitKcal;
  final double? ringfitKm;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 130,
          child: RingfitTextField(
            label: 'kcal',
            initValue: ringfitKcal,
            onChanged: (double? v) {
              ref.read(recordControllerProvider.notifier).inputRingfitKcal(v);
            },
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: 130,
          child: RingfitTextField(
            label: 'km',
            initValue: ringfitKm,
            onChanged: (double? v) {
              ref.read(recordControllerProvider.notifier).inputRingfitKm(v);
            },
          ),
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
      child: ConditionMemoField(
        initValue: record.conditionMemo,
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
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          child: Text('保存する'),
        ),
      ),
    );
  }
}
