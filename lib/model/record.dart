import 'package:intl/intl.dart';
import 'package:simple_dyphic/model/dyphic_id.dart';

///
/// 記録情報を保持する
///
class Record {
  const Record._({
    required this.id,
    required this.date,
    required this.breakfast,
    required this.lunch,
    required this.dinner,
    required this.isToilet,
    required this.condition,
    required this.conditionMemo,
    required this.ringfitKcal,
    required this.ringfitKm,
  });

  factory Record.create({
    required int id,
    String? breakfast,
    String? lunch,
    String? dinner,
    bool isToilet = false,
    String? condition,
    String? conditionMemo,
    double? ringfitKcal,
    double? ringfitKm,
  }) {
    return Record._(
      id: id,
      date: DyphicID.idToDate(id),
      breakfast: breakfast,
      lunch: lunch,
      dinner: dinner,
      isToilet: isToilet,
      condition: condition,
      conditionMemo: conditionMemo,
      ringfitKcal: ringfitKcal,
      ringfitKm: ringfitKm,
    );
  }

  factory Record.createEmpty(DateTime idDate) {
    return Record._(
      id: DyphicID.dateToId(idDate),
      date: idDate,
      breakfast: null,
      lunch: null,
      dinner: null,
      isToilet: false,
      condition: null,
      conditionMemo: null,
      ringfitKcal: null,
      ringfitKm: null,
    );
  }

  final int id;
  final DateTime date;
  // 食事
  final String? breakfast;
  final String? lunch;
  final String? dinner;
  // 体調
  final bool isToilet;
  final String? condition;
  final String? conditionMemo;
  // リングフィット記録
  final double? ringfitKcal;
  final double? ringfitKm;

  String showFormatDate() {
    return DateFormat('yyyy年MM月dd日').format(date);
  }

  bool isSameDay(DateTime targetAt) {
    return date.year == targetAt.year && date.month == targetAt.month && date.day == targetAt.day;
  }

  ConditionType? getConditionType() {
    return Condition.toType(condition);
  }

  bool isRingfit() {
    if (ringfitKcal == null || ringfitKm == null) {
      return false;
    }

    return ringfitKcal! > 0 && ringfitKm! > 0;
  }

  bool notRegister() {
    return breakfast == null && lunch == null && dinner == null && condition == null && conditionMemo == null;
  }

  Record copyWith({double? ringfitKcal, double? ringfitKm}) {
    return Record._(
      id: id,
      date: date,
      breakfast: breakfast,
      lunch: lunch,
      dinner: dinner,
      isToilet: isToilet,
      condition: condition,
      conditionMemo: conditionMemo,
      ringfitKcal: ringfitKcal ?? this.ringfitKcal,
      ringfitKm: ringfitKm ?? this.ringfitKm,
    );
  }
}

class Condition {
  Condition._();

  static const String conditionTypeBad = '悪い';
  static const String conditionTypeNormal = '普通';
  static const String conditionTypeGood = '良い';

  static ConditionType? toType(String? condition) {
    return switch (condition) {
      conditionTypeBad => ConditionType.bad,
      conditionTypeGood => ConditionType.good,
      conditionTypeNormal => ConditionType.normal,
      _ => null,
    };
  }

  static String? toStr(ConditionType? type) {
    return switch (type) {
      ConditionType.bad => conditionTypeBad,
      ConditionType.good => conditionTypeGood,
      ConditionType.normal => conditionTypeNormal,
      _ => null,
    };
  }
}

enum ConditionType { bad, normal, good }
