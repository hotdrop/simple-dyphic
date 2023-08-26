import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_dyphic/common/app_logger.dart';
import 'package:simple_dyphic/model/record.dart';
import 'package:simple_dyphic/repository/local/entities/record_entity.dart';

final recordDaoProvider = Provider((ref) => const _RecordDao());

class _RecordDao {
  const _RecordDao();

  Future<List<Record>> findAll() async {
    final box = await Hive.openBox<RecordEntity>(RecordEntity.boxName);
    if (box.isEmpty) {
      return [];
    }

    final entities = box.values;
    AppLogger.d('ローカルからレコード一覧を取得しました。レコード数: ${entities.length}');

    return entities
        .map((e) => Record.create(
              id: e.id,
              breakfast: e.breakfast,
              lunch: e.lunch,
              dinner: e.dinner,
              isWalking: e.isWalking,
              isToilet: e.isToilet,
              condition: e.condition,
              conditionMemo: e.conditionMemo,
            ))
        .toList();
  }

  Future<Record> find(int key) async {
    final box = await Hive.openBox<RecordEntity>(RecordEntity.boxName);
    AppLogger.d('key=$key');
    final e = box.get(key)!;

    return Record.create(
      id: e.id,
      breakfast: e.breakfast,
      lunch: e.lunch,
      dinner: e.dinner,
      isWalking: e.isWalking,
      isToilet: e.isToilet,
      condition: e.condition,
      conditionMemo: e.conditionMemo,
    );
  }

  Future<void> save(Record record) async {
    final entity = RecordEntity(
      id: record.id,
      breakfast: record.breakfast,
      lunch: record.lunch,
      dinner: record.dinner,
      isWalking: record.isWalking,
      isToilet: record.isToilet,
      condition: record.condition,
      conditionMemo: record.conditionMemo,
    );

    final box = await Hive.openBox<RecordEntity>(RecordEntity.boxName);
    await box.put(entity.id, entity);
  }

  Future<void> saveAll(List<Record> records) async {
    final entities = records
        .map((r) => RecordEntity(
              id: r.id,
              breakfast: r.breakfast,
              lunch: r.lunch,
              dinner: r.dinner,
              isWalking: r.isWalking,
              isToilet: r.isToilet,
              condition: r.condition,
              conditionMemo: r.conditionMemo,
            ))
        .toList();

    final box = await Hive.openBox<RecordEntity>(RecordEntity.boxName);
    await box.clear();
    await box.addAll(entities);
  }
}
