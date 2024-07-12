import 'dart:io';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:simple_dyphic/repository/local/entities/record_entity.dart';
import 'package:simple_dyphic/repository/local/local_data_source.dart';

class TestLocalDataSource extends LocalDataSource {
  TestLocalDataSource(super.ref);

  @override
  Future<void> initHive() async {
    Hive.init(Directory.current.path);
    Hive.registerAdapter(RecordEntityAdapter());
  }

  @override
  Future<String> getDirectoryPath() async {
    final dir = await Directory.systemTemp.createTemp();
    return dir.path;
  }
}
