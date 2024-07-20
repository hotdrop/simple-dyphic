import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health/health.dart';
import 'package:permission_handler/permission_handler.dart';

final healthCareProvider = NotifierProvider<_HealthCareNotifier, HealthState>(_HealthCareNotifier.new);

class _HealthCareNotifier extends Notifier<HealthState> {
  @override
  HealthState build() {
    Health().configure(useHealthConnectIfAvailable: true);
    return HealthFirstState();
  }

  static const List<HealthDataType> _dataTypes = [
    HealthDataType.STEPS,
  ];

  List<HealthDataAccess> get _permissions => _dataTypes.map((e) => HealthDataAccess.READ).toList();

  Future<void> checkSdkStatus() async {
    if (Platform.isIOS) {
      state = HealthAvailable();
      return;
    }

    final sdkStatus = await Health().getHealthConnectSdkStatus();
    state = switch (sdkStatus) {
      HealthConnectSdkStatus.sdkUnavailable => HealthUnavailable('HealthConnect SDKが利用できません'),
      HealthConnectSdkStatus.sdkUnavailableProviderUpdateRequired => HealthUnavailable('GooglePlayのプロバイダー更新が必要です'),
      HealthConnectSdkStatus.sdkAvailable => HealthAvailable(),
      _ => HealthUnavailable('sdkStatusがnullです'),
    };
  }

  Future<void> authorize() async {
    // TODO これだけだとダメでは？
    await Permission.activityRecognition.request();

    final hasPermissions = await Health().hasPermissions(_dataTypes, permissions: _permissions) ?? false;
    if (!hasPermissions) {
      try {
        final authorized = await Health().requestAuthorization(_dataTypes, permissions: _permissions);
        state = authorized ? HealthAuthorized() : HealthAuthNotGrandted();
      } catch (error) {
        state = HealthNotPermission();
      }
    }
  }

  Future<void> fetchData(DateTime date) async {
    final startAt = DateTime(date.year, date.month, date.day, 0, 0, 0);
    final endAt = DateTime(date.year, date.month, date.day, 23, 59, 59);
    try {
      final data = await Health().getTotalStepsInInterval(startAt, endAt) ?? 0;
      state = HealthStepData(data);
    } catch (error) {
      state = HealthFetchStepError('$error');
    }
  }
}

sealed class HealthState {}

class HealthFirstState extends HealthState {}

class HealthUnavailable extends HealthState {
  HealthUnavailable(this.message);
  final String message;
}

class HealthAvailable extends HealthState {}

class HealthNotPermission extends HealthState {}

class HealthAuthNotGrandted extends HealthState {}

class HealthAuthorized extends HealthState {}

class HealthStepData extends HealthState {
  HealthStepData(this.step);
  final int step;
}

class HealthFetchStepError extends HealthState {
  HealthFetchStepError(this.message);
  final String message;
}
