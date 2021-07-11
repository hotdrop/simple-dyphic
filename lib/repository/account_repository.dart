import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_dyphic/service/firebase_auth.dart';

final accountRepositoryProvider = Provider((ref) => _AccountRepository(ref.read));

class _AccountRepository {
  const _AccountRepository(this._read);

  final Reader _read;

  bool isLogIn() {
    final user = _read(firebaseAuthProvider);
    return user != null;
  }

  String? userName() {
    return _read(firebaseAuthProvider)?.displayName;
  }

  String? userEmail() {
    return _read(firebaseAuthProvider)?.email;
  }

  Future<void> login() async {
    await _read(firebaseAuthProvider.notifier).login();
  }

  Future<void> logout() async {
    await _read(firebaseAuthProvider.notifier).logout();
  }
}
