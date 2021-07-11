import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_dyphic/common/app_logger.dart';
import 'package:simple_dyphic/model/record.dart';
import 'package:simple_dyphic/repository/local/record_dao.dart';
import 'package:simple_dyphic/service/firestore.dart';

final recordRepositoryProvider = Provider((ref) => _RecordRepository(ref.read));

class _RecordRepository {
  const _RecordRepository(this._read);

  final Reader _read;

  Future<List<Record>> findAll() async {
    final records = await _read(recordDaoProvider).findAll();
    if (records.isNotEmpty) {
      return records;
    }

    AppLogger.d('ローカルで保持しているレコード情報が0件のためリモートから取得します');
    final remoteRecords = await _read(firestoreProvider).findAll();
    AppLogger.d('リモートから取得したレコード件数: ${remoteRecords.length}');
    await _read(recordDaoProvider).saveAll(remoteRecords);

    return remoteRecords;
  }

  Future<void> save(Record record) async {
    await _read(recordDaoProvider).save(record);
  }

  Future<void> backup(List<Record> records) async {
    await _read(firestoreProvider).saveAll(records);
  }
}
