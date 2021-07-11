import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_dyphic/common/app_logger.dart';
import 'package:simple_dyphic/model/record.dart';
import 'package:simple_dyphic/service/firestore.dart';

final recordApiProvider = Provider((ref) => _RecordApi(ref.read));

class _RecordApi {
  const _RecordApi(this._read);

  final Reader _read;

  Future<List<Record>> findAll() async {
    final records = await _read(firestoreProvider).findAll();
    AppLogger.d('レコード情報を全取得しました。登録数: ${records.length}');
    return records;
  }

  Future<void> saveAll(List<Record> records) async {
    AppLogger.d('${records.length} 件のレコード情報を保存します。');
    for (var record in records) {
      AppLogger.d('${record.id} のレコードを保存します。');
      await _read(firestoreProvider).save(record);
    }
  }
}
