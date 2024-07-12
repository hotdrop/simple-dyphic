import 'package:isar/isar.dart';

part 'record_entitiy_isar.g.dart';

@Collection()
class RecordEntitiyIsar {
  RecordEntitiyIsar({
    required this.id,
    this.breakfast,
    this.lunch,
    this.dinner,
    this.isWalking = false,
    this.isToilet = false,
    this.condition,
    this.conditionMemo,
  });

  Id id;
  String? breakfast;
  String? lunch;
  String? dinner;
  bool isWalking;
  bool isToilet;
  String? condition;
  String? conditionMemo;
}
