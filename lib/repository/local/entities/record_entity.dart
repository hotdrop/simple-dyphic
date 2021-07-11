import 'package:hive/hive.dart';

part 'record_entity.g.dart';

@HiveType(typeId: 0)
class RecordEntity extends HiveObject {
  RecordEntity({
    required this.id,
    this.breakfast,
    this.lunch,
    this.dinner,
    this.isWalking = false,
    this.isToilet = false,
    this.condition,
    this.conditionMemo,
  });

  @HiveField(0)
  final int id;

  @HiveField(1)
  final String? breakfast;

  @HiveField(2)
  final String? lunch;

  @HiveField(3)
  final String? dinner;

  @HiveField(4)
  final bool isWalking;

  @HiveField(5)
  final bool isToilet;

  @HiveField(6)
  final String? condition;

  @HiveField(7)
  final String? conditionMemo;

  static const String boxName = 'records';
}
