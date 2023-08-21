import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_dyphic/repository/local/entities/record_entity.dart';

final localDataSourceProvider = Provider((ref) => const _LocalDataSource());

class _LocalDataSource {
  const _LocalDataSource();

  ///
  /// アプリ起動時に必ず呼ぶ
  ///
  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(RecordEntityAdapter());
  }
}
