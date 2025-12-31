import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:simple_dyphic/common/app_logger.dart';

final firebaseAuthProvider = Provider((ref) => _FirebaseAuthProvider());

class _FirebaseAuthProvider {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

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

      final googleUser = await _signInWithGoogle();
      if (googleUser == null) {
        // サインインをキャンセルした場合はそのまま終了
        return;
      }

      final googleAuth = googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      AppLogger.d('サインイン処理完了');
    } on GoogleSignInException catch (e, s) {
      await AppLogger.e('FirebaseAuth: Googleサインインでエラー code=${e.code}', e, s);
      rethrow;
    } on PlatformException catch (e, s) {
      await AppLogger.e('FirebaseAuth: サインイン処理でエラー code=${e.code}', e, s);
      rethrow;
    } on FirebaseAuthException catch (e, s) {
      await AppLogger.e('FirebaseAuth: サインイン処理でエラー code=${e.code}', e, s);
      rethrow;
    }
  }

  Future<GoogleSignInAccount?> _signInWithGoogle() async {
    try {
      return await _googleSignIn.authenticate();
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled || e.code == GoogleSignInExceptionCode.interrupted || e.code == GoogleSignInExceptionCode.uiUnavailable) {
        AppLogger.d('サインイン処理がキャンセルされたので終了');
        return null;
      }
      rethrow;
    }
  }

  Future<void> signOutWithGoogle() async {
    await _googleSignIn.disconnect();
    await FirebaseAuth.instance.signOut();
  }
}
