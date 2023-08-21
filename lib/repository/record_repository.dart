import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_dyphic/common/app_logger.dart';
import 'package:simple_dyphic/model/record.dart';
import 'package:simple_dyphic/repository/local/record_dao.dart';
import 'package:simple_dyphic/service/firestore.dart';

final recordRepositoryProvider = Provider((ref) => _RecordRepository(ref));

class _RecordRepository {
  const _RecordRepository(this._ref);

  final Ref _ref;

  Future<List<Record>> findAll() async {
    return await _ref.read(recordDaoProvider).findAll();
  }

  Future<Record> find(int id) async {
    return await _ref.read(recordDaoProvider).find(id);
  }

  Future<void> save(Record record) async {
    await _ref.read(recordDaoProvider).save(record);
  }

  Future<void> restore() async {
    final remoteRecords = await _ref.read(firestoreProvider).findAll();
    AppLogger.d('リモートから取得したレコード件数: ${remoteRecords.length}');
    await _ref.read(recordDaoProvider).saveAll(remoteRecords);
  }

  Future<void> backup() async {
    final records = await findAll();
    await _ref.read(firestoreProvider).saveAll(records);
  }
}
