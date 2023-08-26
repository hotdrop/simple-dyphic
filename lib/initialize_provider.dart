import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_dyphic/firebase_options.dart';
import 'package:simple_dyphic/repository/local/local_data_source.dart';

///
/// アプリの初期化処理はここで行う
///
final initializerProvider = FutureProvider((ref) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await ref.read(localDataSourceProvider).init();
});
