import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

///
/// CrashlyticsはAppLoggerで使いたいのでstaticでインスタンスを定義する
///
class AppCrashlytics {
  const AppCrashlytics._();

  static const instance = AppCrashlytics._();

  Future<void> init() async {
    if (kDebugMode) {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    } else {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    }

    // 発生したエラーは全てFirebaseCrashlyticsに投げる
    Function? originalOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails errorDetails) async {
      await FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
      if (originalOnError != null) {
        originalOnError(errorDetails);
      }
    };
  }

  Future<void> crashRecord(String message, dynamic exception, StackTrace stackTrace) async {
    await FirebaseCrashlytics.instance.setCustomKey('message', message);
    await FirebaseCrashlytics.instance.recordError(exception, stackTrace);
  }
}
