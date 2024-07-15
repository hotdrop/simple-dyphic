import 'package:isar/isar.dart';

part 'record_entitiy_isar.g.dart';

@Collection()
class RecordEntitiyIsar {
  RecordEntitiyIsar({
    required this.id,
    this.breakfast,
    this.lunch,
    this.dinner,
    this.isToilet = false,
    this.condition,
    this.conditionMemo,
    this.ringfitKcal,
    this.ringfitKm,
  });

  Id id;
  String? breakfast;
  String? lunch;
  String? dinner;
  bool isToilet;
  String? condition;
  String? conditionMemo;
  double? ringfitKcal;
  double? ringfitKm;
}
