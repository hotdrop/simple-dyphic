import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:simple_dyphic/common/app_logger.dart';
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

    AppLogger.d("移行を行います。");
    // ここから先は移行が完了していないルート
    final records = await ref.read(recordDaoProvider).findAllForHive();
    await ref.read(recordDaoProvider).saveAll(records);

    // Hiveのデータ削除
    await hiveBox.clear();
  }
}
