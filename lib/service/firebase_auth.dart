import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:simple_dyphic/common/app_logger.dart';

final firebaseAuthProvider = Provider((ref) => _FirebaseAuthProvider());

class _FirebaseAuthProvider {
  bool get isLogin => FirebaseAuth.instance.currentUser != null;

  String? get userId => FirebaseAuth.instance.currentUser?.uid;
  String? get userName => FirebaseAuth.instance.currentUser?.displayName;
  String? get email => FirebaseAuth.instance.currentUser?.email;

  Future<void> signInWithGoogle() async {
    try {
      if (isLogin) {
        AppLogger.d('既にサインイン済なので何もせず終了');
        return;
      }

      final googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // サインインをキャンセルした場合はそのまま終了
        AppLogger.d('サインイン処理がキャンセルされたので終了');
        return;
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      AppLogger.d('サインイン処理完了');
    } on PlatformException catch (e, s) {
      await AppLogger.e('FirebaseAuth: サインイン処理でエラー code=${e.code}', e, s);
      rethrow;
    } on FirebaseAuthException catch (e, s) {
      await AppLogger.e('FirebaseAuth: サインイン処理でエラー code=${e.code}', e, s);
      rethrow;
    }
  }

  Future<void> signOutWithGoogle() async {
    GoogleSignIn().disconnect();
    await FirebaseAuth.instance.signOut();
  }
}
