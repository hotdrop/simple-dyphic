import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
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

  test('Daoのfind関数とsave関数が正しく動作すること', () async {
    final container = ProviderContainer(
      overrides: [localDataSourceProvider.overrideWith((ref) => TestLocalDataSource(ref))],
    );
    final dao = container.read(recordDaoProvider);

    // テストデータ
    const testKey = 20240101;
    final record1 = Record.create(id: testKey, breakfast: 'testBreakfast', lunch: 'testLunch', dinner: 'testDinner', condition: 'テスト1');
    final record2 = Record.create(id: 20240102, breakfast: 'bk', lunch: 'lun', dinner: 'din', condition: 'テスト2');

    // テスト実行
    await dao.save(record1);
    await dao.save(record2);

    final result = await dao.find(testKey);

    // 結果確認
    expect(result.breakfast, 'testBreakfast');
    expect(result.lunch, 'testLunch');
    expect(result.dinner, 'testDinner');
    expect(result.isToilet, false);
    expect(result.condition, 'テスト1');
    expect(result.conditionMemo, null);
    expect(result.ringfitKcal, null);
    expect(result.ringfitKm, null);
  });

  test('DaoのfindAll関数とsaveAll関数が正しく動作すること', () async {
    final container = ProviderContainer(
      overrides: [localDataSourceProvider.overrideWith((ref) => TestLocalDataSource(ref))],
    );
    final dao = container.read(recordDaoProvider);

    // テストデータ
    final record1 = Record.create(id: 20240101, breakfast: 'testBreakfast', lunch: 'testLunch', dinner: 'testDinner', condition: 'テスト1');
    final record2 = Record.create(id: 20240102, breakfast: 'bk', lunch: 'lun', dinner: 'din', condition: 'テスト2');

    // テスト実行
    await dao.saveAll([record1, record2]);
    final results = await dao.findAll();

    // 結果確認
    expect(results.length, 2);
    final resutlRecord2 = results.where((r) => r.id == 20240102).first;
    expect(resutlRecord2.breakfast, 'bk');
    expect(resutlRecord2.lunch, 'lun');
    expect(resutlRecord2.dinner, 'din');
    expect(resutlRecord2.isToilet, false);
    expect(resutlRecord2.condition, 'テスト2');
    expect(resutlRecord2.conditionMemo, null);
    expect(resutlRecord2.ringfitKcal, null);
    expect(resutlRecord2.ringfitKm, null);
  });

  test('新しく追加したリングフィットの記録が正しく行えること', () async {
    final container = ProviderContainer(
      overrides: [localDataSourceProvider.overrideWith((ref) => TestLocalDataSource(ref))],
    );
    final dao = container.read(recordDaoProvider);

    // テストデータ
    final record1 = Record.create(id: 20240101, ringfitKcal: 123.45, ringfitKm: 9.21, conditionMemo: 'リングフィットテスト');
    final record2 = Record.create(id: 20240210, isToilet: true, ringfitKcal: 3.1, ringfitKm: 0.1);
    final record3 = Record.create(id: 20240320, ringfitKcal: 9.9);
    final record4 = Record.create(id: 20240430, ringfitKm: 8.8);

    // テスト実行
    await dao.saveAll([record1, record2, record3, record4]);
    final results = await dao.findAll();

    // 結果確認
    expect(results.length, 4);
    final resutlRecord1 = results.where((r) => r.id == 20240101).first;
    final resutlRecord2 = results.where((r) => r.id == 20240210).first;
    final resutlRecord3 = results.where((r) => r.id == 20240320).first;
    final resutlRecord4 = results.where((r) => r.id == 20240430).first;

    expect(resutlRecord1.isToilet, false);
    expect(resutlRecord1.ringfitKcal, 123.45);
    expect(resutlRecord1.ringfitKm, 9.21);
    expect(resutlRecord1.conditionMemo, 'リングフィットテスト');

    expect(resutlRecord2.isToilet, true);
    expect(resutlRecord2.ringfitKcal, 3.1);
    expect(resutlRecord2.ringfitKm, 0.1);
    expect(resutlRecord2.conditionMemo, null);

    expect(resutlRecord3.isToilet, false);
    expect(resutlRecord3.ringfitKcal, 9.9);
    expect(resutlRecord3.ringfitKm, null);
    expect(resutlRecord3.conditionMemo, null);

    expect(resutlRecord4.isToilet, false);
    expect(resutlRecord4.ringfitKcal, null);
    expect(resutlRecord4.ringfitKm, 8.8);
    expect(resutlRecord4.conditionMemo, null);
  });
}
