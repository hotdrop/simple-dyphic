import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_dyphic/app.dart';
import 'package:simple_dyphic/res/R.dart';

void main() {
  R.init();
  runApp(const ProviderScope(child: App()));
}
