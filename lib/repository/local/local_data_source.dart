import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:simple_dyphic/common/app_logger.dart';
import 'package:simple_dyphic/model/record.dart';
import 'package:simple_dyphic/repository/local/entities/record_entitiy_isar.dart';
import 'package:simple_dyphic/repository/local/entities/record_entity.dart';
import 'package:simple_dyphic/repository/local/record_dao.dart';

final localDataSourceProvider = Provider((ref) => LocalDataSource(ref));

///
/// テストで使うためprivateスコープにはしない
///
class LocalDataSource {
  const LocalDataSource(this.ref);

  final Ref ref;
  static Isar? _instance;

  ///
  /// アプリ起動時に必ず呼ぶ
  ///
  Future<void> init() async {
    await initHive();
    await _initIsar();
  }

  ///
  /// テストでinitを実行しているがこの内容だとエラーになるのでoverrideできるようにしている
  ///
  Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(RecordEntityAdapter());
  }

  Future<void> _initIsar() async {
    if (_instance != null && _instance!.isOpen) {
      return;
    }

    final dirPath = await getDirectoryPath();
    // デバッグ用とリリース用でIsarのデータファイル名を分ける
    const isarName = kReleaseMode ? 'release_db' : Isar.defaultName;

    _instance = await Isar.open(
      [RecordEntitiyIsarSchema],
      directory: dirPath,
      name: isarName,
    );
  }

  Isar get isar {
    if (_instance != null) {
      return _instance!;
    } else {
      throw StateError('Isarを初期化せずに使用しようとしました');
    }
  }

  ///
  /// テストでoverrideしてテンポラリディレクトリを使うためpublicスコープで定義する
  ///
  Future<String> getDirectoryPath() async {
    final dir = await path.getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<void> migrateDataIfNecessary() async {
    AppLogger.d("ローカルストレージの移行判定");
    // Hiveのデータが残っているか確認（移行していない状態）
    final hiveBox = (Hive.isBoxOpen(RecordEntity.boxName)) ? Hive.box<RecordEntity>(RecordEntity.boxName) : await Hive.openBox<RecordEntity>(RecordEntity.boxName);
    if (hiveBox.isEmpty) {
      AppLogger.d("移行済なので終了します。");
      return;
    }

    // ここから先は移行が完了していない場合に通るルート
    AppLogger.d("移行を行います。");
    final records = await ref.read(recordDaoProvider).findAllForHive();
    // ConditionMemoからリングフィットの文字列を抜き出して新たに設けた項目に設定する
    final updatedRecords = _extractRingfitFromConditionMemo(records);
    await ref.read(recordDaoProvider).saveAll(updatedRecords);

    // Hiveのデータ削除
    await hiveBox.clear();
  }

  static const String _ringfitRegExp = r'リングフィット (\d{1,3}(?:\.\d{1,2})?)kcal (\d{1,2}(?:\.\d{1,2})?)km';
  List<Record> _extractRingfitFromConditionMemo(List<Record> records) {
    final regex = RegExp(_ringfitRegExp);
    final updatedRecords = <Record>[];

    for (var record in records) {
      final memo = record.conditionMemo;
      if (memo == null) {
        updatedRecords.add(record);
        continue;
      }

      final match = regex.firstMatch(memo);
      if (match == null) {
        updatedRecords.add(record);
        continue;
      }

      final kcal = double.tryParse(match.group(1)!);
      final km = double.tryParse(match.group(2)!);
      updatedRecords.add(record.copyWith(
        ringfitKcal: kcal,
        ringfitKm: km,
      ));
    }
    return updatedRecords;
  }
}
