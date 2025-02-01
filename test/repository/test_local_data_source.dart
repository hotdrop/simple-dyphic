import 'dart:io';

import 'package:simple_dyphic/repository/local/local_data_source.dart';

class TestLocalDataSource extends LocalDataSource {
  TestLocalDataSource(super.ref);

  @override
  Future<String> getDirectoryPath() async {
    final dir = await Directory.systemTemp.createTemp();
    return dir.path;
  }
}
