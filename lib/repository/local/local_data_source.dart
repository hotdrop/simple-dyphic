import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:simple_dyphic/repository/local/entities/record_entitiy_isar.dart';

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
    await _initIsar();
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
}
