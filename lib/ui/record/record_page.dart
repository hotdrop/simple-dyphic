import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_dyphic/model/record.dart';
import 'package:simple_dyphic/res/app_theme.dart';
import 'package:simple_dyphic/res/images.dart';
import 'package:simple_dyphic/service/health_care.dart';
import 'package:simple_dyphic/ui/record/record_provider.dart';
import 'package:simple_dyphic/ui/record/widget/color_line.dart';
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
          body: ref.watch(recordControllerProvider(record)).when(
                data: (_) => _ViewBody(record),
                error: (e, s) => Padding(padding: const EdgeInsets.all(16), child: Text('$e')),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
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
            ref.read(recordMethodsProvider).clear();
            Navigator.pop(context, false);
          },
        ).show(context);
      } else {
        ref.read(recordMethodsProvider).clear();
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
            const SizedBox(height: 8),
            const Divider(color: AppTheme.cardBackground, thickness: 2.0),
            const SizedBox(height: 16),
            _ViewMealArea(breakfast: record.breakfast, lunch: record.lunch, dinner: record.dinner),
            _ViewHealthApp(record),
            _ViewRingFitArea(ringfitKcal: record.ringfitKcal, ringfitKm: record.ringfitKm),
            const SizedBox(height: 16),
            _ViewCondition(record.getConditionType()),
            const SizedBox(height: 16),
            _ViewToiletCheckBox(record.isToilet),
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
                onChanged: ref.read(recordMethodsProvider).inputBreakfast,
              ),
              const SizedBox(width: 4),
              MealCard.lunch(
                initValue: lunch,
                onChanged: ref.read(recordMethodsProvider).inputLunch,
              ),
              const SizedBox(width: 4),
              MealCard.dinner(
                initValue: dinner,
                onChanged: ref.read(recordMethodsProvider).inputDinner,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ViewHealthApp extends StatelessWidget {
  const _ViewHealthApp(this.record);

  final Record record;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.cardBackground,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const _HealthAppButton(),
            const SizedBox(width: 48),
            _ViewOnLoadHealthData(record),
          ],
        ),
      ),
    );
  }
}

class _HealthAppButton extends ConsumerWidget {
  const _HealthAppButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return InkWell(
      onTap: () {
        ref.read(healthCareProvider.notifier).startApp().catchError((e) {
          AppDialog.ok(message: '$e').show(context);
        });
      },
      child: SizedBox(width: 72, height: 72, child: Image.asset(Images.healthPath)),
    );
  }
}

class _ViewOnLoadHealthData extends ConsumerWidget {
  const _ViewOnLoadHealthData(this.record);

  final Record record;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(healthCareProvider);
    return switch (state) {
      HealthUnavailable() => const _ViewNotAvailable('ヘルスケアアプリが利用できません'),
      HealthAvailable() => const _ViewNotAvailable('このステータスにはならないはずです'),
      HealthAuthNotGrandted() => const _ViewNotAvailable('ヘルスケアアプリの利用権限がありません'),
      HealthAuthorized() => _ViewAuthorized(record, state.healthData),
    };
  }
}

class _ViewNotAvailable extends StatelessWidget {
  const _ViewNotAvailable(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Text(label, style: const TextStyle(color: Colors.red)),
    );
  }
}

class _ViewAuthorized extends ConsumerWidget {
  const _ViewAuthorized(this.record, this.healthData);

  final Record record;
  final HealthData healthData;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentStep = record.stepCount ?? 0;
    final currentKcal = record.healthKcal ?? 0.0;
    final step = (healthData.step > 0) ? healthData.step : currentStep;
    final kcal = (healthData.kcal > 0) ? healthData.kcal : currentKcal;

    Future<void>.delayed(Duration.zero).then((_) {
      final isUpdate = healthData.step != currentStep || healthData.kcal != currentKcal;
      ref.read(recordMethodsProvider).updateHealthData(stepCount: step, healthKcal: kcal, isUpdate: isUpdate);
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12.0),
        Row(
          children: [
            const VerticalColorLine(color: Colors.blue),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text('$step 歩', style: const TextStyle(fontSize: 24)),
            )
          ],
        ),
        const SizedBox(height: 12.0),
        Row(
          children: [
            const VerticalColorLine(color: Colors.yellow),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text('$kcal kcal', style: const TextStyle(fontSize: 24)),
            )
          ],
        ),
      ],
    );
  }
}

class _ViewRingFitArea extends StatelessWidget {
  const _ViewRingFitArea({required this.ringfitKcal, required this.ringfitKm});

  final double? ringfitKcal;
  final double? ringfitKm;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.cardBackground,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            SizedBox(width: 108, height: 108, child: Image.asset(Images.ringfitPath)),
            const SizedBox(width: 8),
            _ViewRingfitResult(
              ringfitKcal: ringfitKcal,
              ringfitKm: ringfitKm,
            ),
          ],
        ),
      ),
    );
  }
}

class _ViewRingfitResult extends ConsumerWidget {
  const _ViewRingfitResult({required this.ringfitKcal, required this.ringfitKm});

  final double? ringfitKcal;
  final double? ringfitKm;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          RingfitTextField(
            label: 'kcal',
            initValue: ringfitKcal,
            onChanged: (double? v) {
              ref.read(recordMethodsProvider).inputRingfitKcal(v);
            },
          ),
          const SizedBox(height: 16),
          RingfitTextField(
            label: 'km',
            initValue: ringfitKm,
            onChanged: (double? v) {
              ref.read(recordMethodsProvider).inputRingfitKm(v);
            },
          ),
        ],
      ),
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
      onSelected: (newVal) => ref.read(recordMethodsProvider).selectCondition(newVal),
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
        ref.read(recordMethodsProvider).inputIsToilet(isCheck);
      },
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
        onChanged: ref.read(recordMethodsProvider).inputConditionMemo,
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
          ref.read(recordMethodsProvider).save(record).then((_) {
            ref.read(recordMethodsProvider).clear();
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
