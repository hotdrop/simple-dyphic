import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_dyphic/common/app_logger.dart';
import 'package:simple_dyphic/model/record.dart';
import 'package:simple_dyphic/service/firestore.dart';

final recordApiProvider = Provider((ref) => _RecordApi(ref));

class _RecordApi {
  const _RecordApi(this._ref);

  final Ref _ref;

  Future<List<Record>> findAll() async {
    final records = await _ref.read(firestoreProvider).findAll();
    AppLogger.d('レコード情報を全取得しました。登録数: ${records.length}');
    return records;
  }

  Future<void> saveAll(List<Record> records) async {
    AppLogger.d('${records.length} 件のレコード情報を保存します。');
    await _ref.read(firestoreProvider).saveAll(records);
  }
}
