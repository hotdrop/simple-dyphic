import 'package:isar/isar.dart';

part 'record_entity_isar.g.dart';

@Collection()
class RecordEntityIsar {
  RecordEntityIsar({
    required this.id,
    this.breakfast,
    this.lunch,
    this.dinner,
    this.isToilet = false,
    this.condition,
    this.conditionMemo,
    this.stepCount,
    this.healthKcal,
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
  int? stepCount;
  double? healthKcal;
  double? ringfitKcal;
  double? ringfitKm;
}
