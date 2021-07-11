import 'package:intl/intl.dart';
import 'package:simple_dyphic/model/dyphic_id.dart';
import 'package:simple_dyphic/res/R.dart';

///
/// 記録情報を保持する
///
class Record {
  const Record._(
    this.id,
    this.date,
    this.breakfast,
    this.lunch,
    this.dinner,
    this.isWalking,
    this.condition,
    this.conditionMemo,
  );

  factory Record.create({
    required int id,
    String? breakfast,
    String? lunch,
    String? dinner,
    bool? isWalking,
    String? condition,
    String? conditionMemo,
  }) {
    return Record._(id, DyphicID.idToDate(id), breakfast, lunch, dinner, isWalking, condition, conditionMemo);
  }

  factory Record.createEmpty(DateTime idDate) {
    return Record._(DyphicID.dateToId(idDate), idDate, null, null, null, null, null, null);
  }

  final int id;
  final DateTime date;
  final String? breakfast;
  final String? lunch;
  final String? dinner;
  final bool? isWalking;
  final String? condition;
  final String? conditionMemo;

  String showFormatDate() {
    return DateFormat(R.res.strings.recordPageTitleDateFormat).format(date);
  }

  bool isSameDay(DateTime targetAt) {
    return date.year == targetAt.year && date.month == targetAt.month && date.day == targetAt.day;
  }

  ConditionType? getConditionType() {
    return Condition.toType(condition);
  }

  bool notRegister() {
    return breakfast == null &&
        lunch == null &&
        dinner == null &&
        isWalking == null &&
        condition == null &&
        conditionMemo == null;
  }

  @override
  String toString() {
    return '''
    date: $date
    breakfast: $breakfast
    lunch: $lunch
    dinner: $dinner
    walking: $isWalking
    condition: $condition
    conditionMemo: $conditionMemo
    ''';
  }
}

class Condition {
  Condition._();

  static ConditionType? toType(String? condition) {
    if (condition == R.res.strings.conditionTypeBad) {
      return ConditionType.bad;
    } else if (condition == R.res.strings.conditionTypeGood) {
      return ConditionType.good;
    } else if (condition == R.res.strings.conditionTypeNormal) {
      return ConditionType.normal;
    } else {
      return null;
    }
  }

  static String? toStr(ConditionType? type) {
    if (type == ConditionType.bad) {
      return R.res.strings.conditionTypeBad;
    } else if (type == ConditionType.good) {
      return R.res.strings.conditionTypeGood;
    } else if (type == ConditionType.normal) {
      return R.res.strings.conditionTypeNormal;
    } else {
      return null;
    }
  }
}

enum ConditionType { bad, normal, good }
