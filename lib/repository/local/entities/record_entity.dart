import 'package:hive/hive.dart';

part 'record_entity.g.dart';

@HiveType(typeId: 0)
class RecordEntity extends HiveObject {
  RecordEntity({
    required this.id,
    this.breakfast,
    this.lunch,
    this.dinner,
    this.isWalking,
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
  final bool? isWalking;

  @HiveField(5)
  final String? condition;

  @HiveField(6)
  final String? conditionMemo;

  static const String boxName = 'records';
}
