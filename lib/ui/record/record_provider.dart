import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:simple_dyphic/common/app_logger.dart';
import 'package:simple_dyphic/model/record.dart';
import 'package:simple_dyphic/repository/record_repository.dart';

part 'record_provider.g.dart';

@riverpod
class RecordController extends _$RecordController {
  @override
  void build() {}

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

  Future<void> inputIsWalking(bool isCheck) async {
    ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(
          isWalking: isCheck,
          isUpdate: true,
        ));
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
    this.isWalking,
    this.isToilet,
    this.conditionType,
    this.conditionMemo,
    this.isUpdate = false,
  });

  String? breakfast;
  String? lunch;
  String? dinner;
  bool? isWalking;
  bool? isToilet;
  ConditionType? conditionType;
  String? conditionMemo;
  bool isUpdate;

  _UiState copyWith({
    String? breakfast,
    String? lunch,
    String? dinner,
    bool? isWalking,
    bool? isToilet,
    ConditionType? conditionType,
    String? conditionMemo,
    bool? isUpdate,
  }) {
    return _UiState(
      breakfast: breakfast ?? this.breakfast,
      lunch: lunch ?? this.lunch,
      dinner: dinner ?? this.dinner,
      isWalking: isWalking ?? this.isWalking,
      isToilet: isToilet ?? this.isToilet,
      conditionType: conditionType ?? this.conditionType,
      conditionMemo: conditionMemo ?? this.conditionMemo,
      isUpdate: isUpdate ?? this.isUpdate,
    );
  }

  Record toRecord(Record record) {
    return Record.create(
      id: record.id,
      breakfast: breakfast ?? record.breakfast,
      lunch: lunch ?? record.lunch,
      dinner: dinner ?? record.dinner,
      isWalking: isWalking ?? record.isWalking,
      isToilet: isToilet ?? record.isToilet,
      condition: conditionType != null ? Condition.toStr(conditionType) : record.condition,
      conditionMemo: conditionMemo ?? record.conditionMemo,
    );
  }
}

final isUpdateRecordProvider = Provider((ref) => ref.watch(_uiStateProvider.select((value) => value.isUpdate)));
