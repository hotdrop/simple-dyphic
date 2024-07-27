import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:isar/isar.dart';
import 'package:simple_dyphic/model/record.dart';
import 'package:simple_dyphic/repository/local/local_data_source.dart';
import 'package:simple_dyphic/repository/local/record_dao.dart';

import 'test_local_data_source.dart';

void main() {
  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
    final container = ProviderContainer(
      overrides: [localDataSourceProvider.overrideWith((ref) => TestLocalDataSource(ref))],
    );
    await container.read(localDataSourceProvider).init();
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
  });

  test('HiveからIsarへのmigraitonが正しく行えること', () async {
    final container = ProviderContainer(
      overrides: [localDataSourceProvider.overrideWith((ref) => TestLocalDataSource(ref))],
    );
    final dao = container.read(recordDaoProvider);
    final localDataSource = container.read(localDataSourceProvider);

    // データ登録
    final testData = [
      Record.create(id: 20240510, breakfast: 'bk1', lunch: 'lc1', dinner: 'dn1', condition: '移行テスト1'),
      Record.create(id: 20240511, breakfast: 'bk2', lunch: 'lc2', dinner: 'dn2', condition: '移行テスト2'),
      Record.create(id: 20240512, breakfast: 'bk3', lunch: 'lc3', dinner: 'dn3', condition: '移行テスト3'),
      Record.create(id: 20240513, breakfast: 'bk4', lunch: 'lc4', dinner: 'dn4', condition: '移行テスト4'),
    ];

    // Hive経由でデータを登録
    await dao.saveAllForHive(testData);
    // 移行関数をよぶ
    await localDataSource.migrateDataIfNecessary();
    // Isarデータ取得
    final resultFromIsar = await dao.findAll();
    final resultFromHive = await dao.findAllForHive();

    // 結果確認
    expect(resultFromIsar.length, 4);
    expect(resultFromHive.length, 0);

    final result1 = resultFromIsar.where((e) => e.id == 20240510).first;
    final result2 = resultFromIsar.where((e) => e.id == 20240511).first;
    final result3 = resultFromIsar.where((e) => e.id == 20240512).first;
    final result4 = resultFromIsar.where((e) => e.id == 20240513).first;

    expect(result1.breakfast, 'bk1');
    expect(result2.lunch, 'lc2');
    expect(result3.dinner, 'dn3');
    expect(result4.condition, '移行テスト4');
  });

  test('HiveからIsarへのmigraiton時にConditionMemoをリングフィットの各項目に抽出できること', () async {
    final container = ProviderContainer(
      overrides: [localDataSourceProvider.overrideWith((ref) => TestLocalDataSource(ref))],
    );
    final dao = container.read(recordDaoProvider);
    final localDataSource = container.read(localDataSourceProvider);

    // データ登録
    final testData = [
      Record.create(id: 20240801, conditionMemo: "リングフィット 123kcal 5km"),
      Record.create(id: 20240802, conditionMemo: "リングフィット 123.45kcal 10.24km"),
      Record.create(id: 20240803, conditionMemo: "体調は良い。\nリングフィット 167.8kcal 9.3km"),
      Record.create(id: 20240804, conditionMemo: "体調は良い。排便した"),
      Record.create(id: 20240805, conditionMemo: null),
      Record.create(id: 20240806, conditionMemo: "リングフィット 123kcal"),
    ];

    // Hive経由でデータを登録
    await dao.saveAllForHive(testData);
    // 移行関数をよぶ
    await localDataSource.migrateDataIfNecessary();
    // Isarデータ取得
    final resultFromIsar = await dao.findAll();
    final resultFromHive = await dao.findAllForHive();

    // 結果確認
    expect(resultFromIsar.length, 6);
    expect(resultFromHive.length, 0);

    expect(resultFromIsar[0].ringfitKcal, 123.0);
    expect(resultFromIsar[0].ringfitKm, 5.0);
    expect(resultFromIsar[1].ringfitKcal, 123.45);
    expect(resultFromIsar[1].ringfitKm, 10.24);
    expect(resultFromIsar[2].ringfitKcal, 167.8);
    expect(resultFromIsar[2].ringfitKm, 9.3);
    expect(resultFromIsar[3].ringfitKcal, null);
    expect(resultFromIsar[3].ringfitKm, null);
    expect(resultFromIsar[4].ringfitKcal, null);
    expect(resultFromIsar[4].ringfitKm, null);
    expect(resultFromIsar[5].ringfitKcal, null);
    expect(resultFromIsar[5].ringfitKm, null);
  });
}
