import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:simple_dyphic/repository/local/local_data_source.dart';
import 'package:simple_dyphic/service/health_care.dart';

///
/// アプリの初期化処理はここで行う
///
final initializerProvider = FutureProvider((ref) async {
  // Androidのみoptionをつけない。他のプラットフォームがある場合は分岐させる
  await Firebase.initializeApp();
  await GoogleSignIn.instance.initialize(
    serverClientId: "446111817812-bldg4ski60dbq15vt9cei6k9071i7lp4.apps.googleusercontent.com",
  );
  await ref.read(localDataSourceProvider).init();
  await ref.read(healthCareProvider.notifier).onInitHealthStatus();
});
