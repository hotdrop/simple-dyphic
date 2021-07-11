import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_dyphic/common/app_logger.dart';
import 'package:simple_dyphic/model/dyphic_id.dart';
import 'package:simple_dyphic/model/record.dart';
import 'package:simple_dyphic/repository/record_repository.dart';
import 'package:simple_dyphic/ui/base_view_model.dart';

final recordViewModelProvider = ChangeNotifierProvider.autoDispose((ref) => _RecordViewModel(ref.read));

class _RecordViewModel extends BaseViewModel {
  _RecordViewModel(this._read);

  final Reader _read;

  late InputRecord _inputRecord;

  bool _isUpdate = false;
  bool get isUpdate => _isUpdate;

  ///
  /// 初期処理
  /// コンストラクタでよび、使用元のViewではPageStateでViewModelの利用状態を判断する。
  ///
  Future<void> init(Record record) async {
    _inputRecord = InputRecord.create(record);
    onSuccess();
  }

  Future<void> inputBreakfast(String? newVal) async {
    _inputRecord.breakfast = newVal ?? '';
    _isUpdate = true;
  }

  Future<void> inputLunch(String? newVal) async {
    _inputRecord.lunch = newVal ?? '';
    _isUpdate = true;
  }

  Future<void> inputDinner(String? newVal) async {
    _inputRecord.dinner = newVal ?? '';
    _isUpdate = true;
  }

  Future<void> inputIsWalking(bool isCheck) async {
    _inputRecord.isWalking = isCheck;
    _isUpdate = true;
  }

  Future<void> inputIsToilet(bool isCheck) async {
    _inputRecord.isToilet = isCheck;
    _isUpdate = true;
  }

  void selectCondition(ConditionType? type) {
    _inputRecord.conditionType = type;
    _isUpdate = true;
  }

  void inputConditionMemo(String newVal) {
    _inputRecord.conditionMemo = newVal;
    _isUpdate = true;
  }

  Future<void> save() async {
    final record = _inputRecord.toRecord();
    AppLogger.d('レコードを保存します。');
    await _read(recordRepositoryProvider).save(record);
  }
}

///
/// 入力保持用のクラス
///
class InputRecord {
  InputRecord._({
    required this.id,
    required this.breakfast,
    required this.lunch,
    required this.dinner,
    required this.isWalking,
    required this.isToilet,
    required this.conditionType,
    required this.conditionMemo,
  });

  factory InputRecord.create(Record record) {
    final id = DyphicID.makeRecordId(record.date);
    return InputRecord._(
      id: id,
      breakfast: record.breakfast ?? '',
      lunch: record.lunch ?? '',
      dinner: record.dinner ?? '',
      isWalking: record.isWalking,
      isToilet: record.isToilet,
      conditionType: Condition.toType(record.condition),
      conditionMemo: record.conditionMemo ?? '',
    );
  }

  int id;
  String breakfast;
  String lunch;
  String dinner;
  bool isWalking;
  bool isToilet;
  ConditionType? conditionType;
  String conditionMemo;

  Record toRecord() {
    return Record.create(
      id: id,
      breakfast: breakfast,
      lunch: lunch,
      dinner: dinner,
      isWalking: isWalking,
      isToilet: isToilet,
      condition: Condition.toStr(conditionType),
      conditionMemo: conditionMemo,
    );
  }
}
