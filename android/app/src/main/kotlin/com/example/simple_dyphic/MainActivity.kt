package com.example.simple_dyphic

import android.content.Intent
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterFragmentActivity() {
  private val startHealthAppChannel = "com.example.simple_dyphic.health/intents"

  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    MethodChannel(flutterEngine.dartExecutor.binaryMessenger, startHealthAppChannel).setMethodCallHandler { call, result ->
      if (call.method == "startHealthApp") {
        startHealthConnectApp()
        result.success(null)
      } else {
        result.notImplemented()
      }
    }
  }

  private fun startHealthConnectApp() {
    val intent = Intent()
    intent.action = "androidx.health.ACTION_HEALTH_CONNECT_SETTINGS"
    startActivity(intent)
  }
}
