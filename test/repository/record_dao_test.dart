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
    final record2 = Record.create(id: 20240505, breakfast: 'bk', lunch: 'lun', dinner: 'din', condition: 'テスト2');

    // テスト実行
    await dao.save(record1);
    await dao.save(record2);

    final result = await dao.find(testKey);

    // 結果確認
    expect(result.breakfast, 'testBreakfast');
    expect(result.lunch, 'testLunch');
    expect(result.dinner, 'testDinner');
    expect(result.condition, 'テスト1');
  });

  test('DaoのfindAll関数とqsaveAll関数が正しく動作すること', () async {
    final container = ProviderContainer(
      overrides: [localDataSourceProvider.overrideWith((ref) => TestLocalDataSource(ref))],
    );
    final dao = container.read(recordDaoProvider);

    // テストデータ
    final record1 = Record.create(id: 20240110, breakfast: 'testBreakfast', lunch: 'testLunch', dinner: 'testDinner', condition: 'テスト1');
    final record2 = Record.create(id: 20240220, breakfast: 'bk', lunch: 'lun', dinner: 'din', condition: 'テスト2');

    // テスト実行
    await dao.saveAll([record1, record2]);
    final results = await dao.findAll();

    // 結果確認
    expect(results.length, 2);
    final resutlRecord2 = results.where((r) => r.id == 20240220).first;
    expect(resutlRecord2.breakfast, 'bk');
    expect(resutlRecord2.lunch, 'lun');
    expect(resutlRecord2.dinner, 'din');
    expect(resutlRecord2.condition, 'テスト2');
  });
}
