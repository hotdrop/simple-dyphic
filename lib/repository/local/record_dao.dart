import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_dyphic/common/app_logger.dart';
import 'package:simple_dyphic/model/record.dart';
import 'package:simple_dyphic/repository/local/entities/record_entity.dart';

final recordDaoProvider = Provider((ref) => _RecordDao());

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
              condition: e.condition,
              conditionMemo: e.conditionMemo,
            ))
        .toList();
  }

  Future<void> save(Record record) async {
    final entity = RecordEntity(
      id: record.id,
      breakfast: record.breakfast,
      lunch: record.lunch,
      dinner: record.dinner,
      isWalking: record.isWalking,
      condition: record.condition,
      conditionMemo: record.conditionMemo,
    );

    final box = await Hive.openBox<RecordEntity>(RecordEntity.boxName);
    await box.clear();
    await box.add(entity);
  }

  Future<void> saveAll(List<Record> records) async {
    final entities = records
        .map((r) => RecordEntity(
              id: r.id,
              breakfast: r.breakfast,
              lunch: r.lunch,
              dinner: r.dinner,
              isWalking: r.isWalking,
              condition: r.condition,
              conditionMemo: r.conditionMemo,
            ))
        .toList();

    final box = await Hive.openBox<RecordEntity>(RecordEntity.boxName);
    await box.clear();
    await box.addAll(entities);
  }
}
