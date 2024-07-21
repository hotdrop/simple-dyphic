import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:simple_dyphic/common/app_logger.dart';
import 'package:simple_dyphic/model/record.dart';
import 'package:simple_dyphic/repository/record_repository.dart';
import 'package:simple_dyphic/service/health_care.dart';

part 'record_provider.g.dart';

@riverpod
class RecordController extends _$RecordController {
  @override
  Future<void> build(Record record) async {
    await ref.read(recordMethodsProvider).fetchData(record.date);
  }
}

final recordMethodsProvider = Provider((ref) => _RecordMethods(ref));

class _RecordMethods {
  const _RecordMethods(this.ref);
  final Ref ref;

  Future<void> inputBreakfast(String? newVal) async {
    if (newVal != null) {
      ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(
            breakfast: newVal,
            isUpdate: true,
          ));
    }
  }

  Future<void> inputLunch(String? newVal) async {
    if (newVal != null) {
      ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(
            lunch: newVal,
            isUpdate: true,
          ));
    }
  }

  Future<void> inputDinner(String? newVal) async {
    if (newVal != null) {
      ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(
            dinner: newVal,
            isUpdate: true,
          ));
    }
  }

  Future<void> inputIsToilet(bool isCheck) async {
    ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(
          isToilet: isCheck,
          isUpdate: true,
        ));
  }

  void selectCondition(ConditionType? type) {
    if (type != null) {
      ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(
            conditionType: type,
            isUpdate: true,
          ));
    }
  }

  void inputConditionMemo(String newVal) {
    ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(
          conditionMemo: newVal,
          isUpdate: true,
        ));
  }

  Future<void> onHealthAuthorized(DateTime date) async {
    await ref.read(healthCareProvider.notifier).authorize();
    await fetchData(date);
  }

  Future<void> fetchData(DateTime date) async {
    final state = ref.read(healthCareProvider);
    if (state is HealthAuthorized) {
      final healthData = await ref.read(healthCareProvider.notifier).fetchData(date);
      ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(
            stepCount: healthData.step,
            healthKcal: healthData.kcal,
          ));
    }
  }

  void inputRingfitKcal(double? newVal) {
    if (newVal != null) {
      ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(
            ringfitKcal: newVal,
            isUpdate: true,
          ));
    }
  }

  void inputRingfitKm(double? newVal) {
    if (newVal != null) {
      ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(
            ringfitKm: newVal,
            isUpdate: true,
          ));
    }
  }

  Future<void> save(Record record) async {
    final newRecord = ref.read(_uiStateProvider).toRecord(record);
    AppLogger.d('レコードを保存します。key=${newRecord.id}');
    await ref.read(recordRepositoryProvider).save(newRecord);
  }

  void clear() {
    ref.invalidate(_uiStateProvider);
  }
}

final _uiStateProvider = StateProvider<_UiState>((_) => _UiState());

///
/// 入力保持用のクラス
///
class _UiState {
  _UiState({
    this.breakfast,
    this.lunch,
    this.dinner,
    this.isToilet,
    this.conditionType,
    this.conditionMemo,
    this.stepCount,
    this.healthKcal,
    this.ringfitKcal,
    this.ringfitKm,
    this.isUpdate = false,
  });

  String? breakfast;
  String? lunch;
  String? dinner;
  bool? isToilet;
  ConditionType? conditionType;
  String? conditionMemo;
  int? stepCount;
  double? healthKcal;
  double? ringfitKcal;
  double? ringfitKm;
  bool isUpdate;

  _UiState copyWith({
    String? breakfast,
    String? lunch,
    String? dinner,
    bool? isToilet,
    ConditionType? conditionType,
    String? conditionMemo,
    int? stepCount,
    double? healthKcal,
    double? ringfitKcal,
    double? ringfitKm,
    bool? isUpdate,
  }) {
    return _UiState(
      breakfast: breakfast ?? this.breakfast,
      lunch: lunch ?? this.lunch,
      dinner: dinner ?? this.dinner,
      isToilet: isToilet ?? this.isToilet,
      conditionType: conditionType ?? this.conditionType,
      conditionMemo: conditionMemo ?? this.conditionMemo,
      stepCount: stepCount ?? this.stepCount,
      healthKcal: healthKcal ?? this.healthKcal,
      ringfitKcal: ringfitKcal ?? this.ringfitKcal,
      ringfitKm: ringfitKm ?? this.ringfitKm,
      isUpdate: isUpdate ?? this.isUpdate,
    );
  }

  Record toRecord(Record record) {
    return Record.create(
      id: record.id,
      breakfast: breakfast ?? record.breakfast,
      lunch: lunch ?? record.lunch,
      dinner: dinner ?? record.dinner,
      isToilet: isToilet ?? record.isToilet,
      condition: conditionType != null ? Condition.toStr(conditionType) : record.condition,
      conditionMemo: conditionMemo ?? record.conditionMemo,
      stepCount: stepCount ?? record.stepCount,
      healthKcal: healthKcal ?? record.healthKcal,
      ringfitKcal: ringfitKcal ?? record.ringfitKcal,
      ringfitKm: ringfitKm ?? record.ringfitKm,
    );
  }
}

final recordPageHealthDataProvider = Provider<HealthData>((ref) {
  final step = ref.watch(_uiStateProvider.select((v) => v.stepCount)) ?? 0;
  final kcal = ref.watch(_uiStateProvider.select((v) => v.healthKcal)) ?? 0;
  return HealthData(step, kcal);
});

final isUpdateRecordProvider = Provider((ref) => ref.watch(_uiStateProvider.select((value) => value.isUpdate)));
