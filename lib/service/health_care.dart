import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health/health.dart';
import 'package:simple_dyphic/common/app_logger.dart';

final healthCareProvider = NotifierProvider<_HealthCareNotifier, HealthState>(_HealthCareNotifier.new);

class _HealthCareNotifier extends Notifier<HealthState> {
  @override
  HealthState build() {
    Health().configure(useHealthConnectIfAvailable: true);
    return HealthUnavailable();
  }

  static const List<HealthDataType> _dataTypes = [
    HealthDataType.STEPS,
    HealthDataType.ACTIVE_ENERGY_BURNED,
  ];

  static const platform = MethodChannel('com.example.simple_dyphic.health/intents');

  List<HealthDataAccess> get _permissions => _dataTypes.map((e) => HealthDataAccess.READ).toList();

  Future<void> startApp() async {
    // iOS未実装
    await platform.invokeMethod('startHealthApp');
  }

  ///
  /// ヘルスエア機能が利用可能か？
  /// アプリ起動時によぶ
  ///
  Future<void> onInitHealthStatus() async {
    if (Platform.isIOS) {
      state = HealthAvailable();
      return;
    }

    final sdkStatus = await Health().getHealthConnectSdkStatus();
    if (sdkStatus != HealthConnectSdkStatus.sdkAvailable) {
      AppLogger.d('ヘルスコネクトアプリが未インストールです');
      state = HealthUnavailable();
      return;
    }

    AppLogger.d('ヘルスコネクトアプリは利用可能です');
    state = HealthAvailable();
  }

  ///
  /// 権限チェック
  /// 歩数を取得する前によぶ
  ///
  Future<void> authorize() async {
    final hasPermissions = await Health().hasPermissions(_dataTypes, permissions: _permissions) ?? false;
    if (hasPermissions) {
      state = HealthAuthorized();
      return;
    }

    try {
      final authorized = await Health().requestAuthorization(_dataTypes, permissions: _permissions);
      state = authorized ? HealthAuthorized() : HealthAuthNotGrandted();
    } catch (e, s) {
      AppLogger.e('Authorizedでエラー', e, s);
      state = HealthAuthNotGrandted();
    }
  }

  ///
  /// 引数で受け取った日付の歩数とkcalを取得する
  /// エラーが発生した場合は例外で返す
  ///
  Future<HealthData> fetchData(DateTime date) async {
    if (state is! HealthAuthorized) {
      throw Exception('必要な権限が許可されていないのにデータを取得しようとしました');
    }

    final startAt = DateTime(date.year, date.month, date.day, 0, 0, 0);
    final endAt = DateTime(date.year, date.month, date.day, 23, 59, 59);
    try {
      AppLogger.d('$startAt 〜 $endAt の歩数と消費カロリーデータを取得します。');
      final List<HealthDataPoint> datas = await Health().getHealthDataFromTypes(
        types: _dataTypes,
        startTime: startAt,
        endTime: endAt,
      );

      int step = 0;
      double kcal = 0.0;
      for (var dataPoint in datas) {
        if (dataPoint.type == HealthDataType.STEPS) {
          step += _getStepValue(dataPoint);
        } else if (dataPoint.type == HealthDataType.ACTIVE_ENERGY_BURNED) {
          kcal += _getKcalValue(dataPoint);
        }
      }
      AppLogger.d('取得した情報: 歩数=$step 消費カロリー=$kcal');
      return HealthData(step, kcal);
    } catch (e, s) {
      AppLogger.e('歩数取得でエラー', e, s);
      rethrow;
    }
  }

  int _getStepValue(HealthDataPoint dp) {
    final v = dp.value;
    if (v is NumericHealthValue) {
      return v.numericValue.toInt();
    } else {
      return 0;
    }
  }

  double _getKcalValue(HealthDataPoint dp) {
    final v = dp.value;
    if (v is NumericHealthValue) {
      return v.numericValue.toDouble();
    } else {
      return 0;
    }
  }
}

sealed class HealthState {}

class HealthUnavailable extends HealthState {}

class HealthAvailable extends HealthState {}

class HealthAuthNotGrandted extends HealthState {}

class HealthAuthorized extends HealthState {}

class HealthData {
  HealthData(this.step, this.kcal);
  final int step;
  final double kcal;
}
