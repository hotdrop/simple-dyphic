import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:simple_dyphic/model/record.dart';
import 'package:simple_dyphic/repository/local/entities/record_entity_isar.dart';
import 'package:simple_dyphic/repository/local/local_data_source.dart';

final recordDaoProvider = Provider((ref) => _RecordDao(ref));

class _RecordDao {
  const _RecordDao(this.ref);

  final Ref ref;

  Future<Record> find(int key) async {
    final isar = ref.read(localDataSourceProvider).isar;
    final record = await isar.recordEntityIsars.get(key);
    if (record == null) {
      throw Exception('Record not found');
    }
    return _entityToModel(record);
  }

  Future<List<Record>> findAll() async {
    final isar = ref.read(localDataSourceProvider).isar;
    final records = await isar.recordEntityIsars.where().findAll();
    return records.map((e) => _entityToModel(e)).toList();
  }

  Future<void> save(Record record) async {
    final isar = ref.read(localDataSourceProvider).isar;
    await isar.writeTxn(() async {
      final entity = _modelToEntity(record);
      await isar.recordEntityIsars.put(entity);
    });
  }

  Future<void> saveAll(List<Record> records) async {
    final isar = ref.read(localDataSourceProvider).isar;
    await isar.writeTxn(() async {
      final entities = records.map((r) => _modelToEntity(r)).toList();
      await isar.clear();
      await isar.recordEntityIsars.putAll(entities);
    });
  }

  Record _entityToModel(RecordEntityIsar entity) {
    return Record.create(
      id: entity.id,
      breakfast: entity.breakfast,
      lunch: entity.lunch,
      dinner: entity.dinner,
      isToilet: entity.isToilet,
      condition: entity.condition,
      conditionMemo: entity.conditionMemo,
      stepCount: entity.stepCount,
      healthKcal: entity.healthKcal,
      ringfitKcal: entity.ringfitKcal,
      ringfitKm: entity.ringfitKm,
    );
  }

  RecordEntityIsar _modelToEntity(Record record) {
    return RecordEntityIsar(
      id: record.id,
      breakfast: record.breakfast,
      lunch: record.lunch,
      dinner: record.dinner,
      isToilet: record.isToilet,
      condition: record.condition,
      conditionMemo: record.conditionMemo,
      stepCount: record.stepCount,
      healthKcal: record.healthKcal,
      ringfitKcal: record.ringfitKcal,
      ringfitKm: record.ringfitKm,
    );
  }
}
