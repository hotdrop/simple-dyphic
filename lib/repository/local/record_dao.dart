import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:isar/isar.dart';
import 'package:simple_dyphic/common/app_logger.dart';
import 'package:simple_dyphic/model/record.dart';
import 'package:simple_dyphic/repository/local/entities/record_entitiy_isar.dart';
import 'package:simple_dyphic/repository/local/entities/record_entity.dart';
import 'package:simple_dyphic/repository/local/local_data_source.dart';

final recordDaoProvider = Provider((ref) => _RecordDao(ref));

class _RecordDao {
  const _RecordDao(this.ref);

  final Ref ref;

  Future<Record> find(int key) async {
    final isar = ref.read(localDataSourceProvider).isar;
    final record = await isar.recordEntitiyIsars.get(key);
    if (record == null) {
      throw Exception('Record not found');
    }
    return _entityToModel(record);
  }

  Future<List<Record>> findAll() async {
    final isar = ref.read(localDataSourceProvider).isar;
    final records = await isar.recordEntitiyIsars.where().findAll();
    return records.map((e) => _entityToModel(e)).toList();
  }

  Future<void> save(Record record) async {
    final isar = ref.read(localDataSourceProvider).isar;
    await isar.writeTxn(() async {
      final entity = _modelToEntity(record);
      await isar.recordEntitiyIsars.put(entity);
    });
  }

  Future<void> saveAll(List<Record> records) async {
    final isar = ref.read(localDataSourceProvider).isar;
    await isar.writeTxn(() async {
      final entities = records.map((r) => _modelToEntity(r)).toList();
      await isar.clear();
      await isar.recordEntitiyIsars.putAll(entities);
    });
  }

  // 以下、Hive用のメソッド。後ほど消す
  Future<List<Record>> findAllForHive() async {
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
              isToilet: e.isToilet,
              condition: e.condition,
              conditionMemo: e.conditionMemo,
            ))
        .toList();
  }

  Future<Record> findForHive(int key) async {
    final box = await Hive.openBox<RecordEntity>(RecordEntity.boxName);
    AppLogger.d('key=$key');
    final e = box.get(key)!;

    return Record.create(
      id: e.id,
      breakfast: e.breakfast,
      lunch: e.lunch,
      dinner: e.dinner,
      isToilet: e.isToilet,
      condition: e.condition,
      conditionMemo: e.conditionMemo,
    );
  }

  Future<void> saveForHive(Record record) async {
    final entity = RecordEntity(
      id: record.id,
      breakfast: record.breakfast,
      lunch: record.lunch,
      dinner: record.dinner,
      isToilet: record.isToilet,
      condition: record.condition,
      conditionMemo: record.conditionMemo,
    );

    final box = await Hive.openBox<RecordEntity>(RecordEntity.boxName);
    await box.put(entity.id, entity);
  }

  Future<void> saveAllForHive(List<Record> records) async {
    final entities = records
        .map((r) => RecordEntity(
              id: r.id,
              breakfast: r.breakfast,
              lunch: r.lunch,
              dinner: r.dinner,
              isToilet: r.isToilet,
              condition: r.condition,
              conditionMemo: r.conditionMemo,
            ))
        .toList();

    final box = await Hive.openBox<RecordEntity>(RecordEntity.boxName);
    await box.clear();
    await box.addAll(entities);
  }

  Record _entityToModel(RecordEntitiyIsar entity) {
    return Record.create(
      id: entity.id,
      breakfast: entity.breakfast,
      lunch: entity.lunch,
      dinner: entity.dinner,
      isToilet: entity.isToilet,
      condition: entity.condition,
      conditionMemo: entity.conditionMemo,
      ringfitKcal: entity.ringfitKcal,
      ringfitKm: entity.ringfitKm,
    );
  }

  RecordEntitiyIsar _modelToEntity(Record record) {
    return RecordEntitiyIsar(
      id: record.id,
      breakfast: record.breakfast,
      lunch: record.lunch,
      dinner: record.dinner,
      isToilet: record.isToilet,
      condition: record.condition,
      conditionMemo: record.conditionMemo,
      ringfitKcal: record.ringfitKcal,
      ringfitKm: record.ringfitKm,
    );
  }
}
