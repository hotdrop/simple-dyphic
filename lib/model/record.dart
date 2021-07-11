import 'package:simple_dyphic/model/dyphic_id.dart';

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

  bool isSameDay(DateTime targetAt) {
    return date.year == targetAt.year && date.month == targetAt.month && date.day == targetAt.day;
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
