import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:simple_dyphic/common/app_logger.dart';

final firebaseAuthProvider = StateNotifierProvider<_FirebaseAuthNotifier, User?>((ref) => _FirebaseAuthNotifier(null));

class _FirebaseAuthNotifier extends StateNotifier<User?> {
  _FirebaseAuthNotifier(User? state) : super(state);

  Future<void> init() async {
    if (state != null) {
      return;
    }
    await Firebase.initializeApp();
    state = FirebaseAuth.instance.currentUser;
  }

  String? get userId => state?.uid;

  Future<void> login() async {
    User? currentUser = state ?? FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      AppLogger.d('Googleアカウントのサインイン: 既にユーザー情報が保持できているのでサインイン完了');
      return;
    }

    AppLogger.d('Googleアカウントのサインイン: ユーザー情報がないのでGoogleアカウントでサインインします　');
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      return;
    }

    try {
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
      final authResult = await FirebaseAuth.instance.signInWithCredential(credential);
      state = authResult.user;
      AppLogger.d('Googleアカウントのサインイン: サインイン完了');
    } on PlatformException catch (e, s) {
      await AppLogger.e('FirebaseAuth: ログイン処理でエラー code=${e.code}', e, s);
      rethrow;
    } on FirebaseAuthException catch (e, s) {
      await AppLogger.e('FirebaseAuth: ログイン処理でエラー code=${e.code}', e, s);
      rethrow;
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    state = null;
  }
}
