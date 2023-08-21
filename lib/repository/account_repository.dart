import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_dyphic/service/firebase_auth.dart';

final accountRepositoryProvider = Provider((ref) => _AccountRepository(ref));

class _AccountRepository {
  const _AccountRepository(this._ref);

  final Ref _ref;

  bool isLogIn() {
    final user = _ref.read(firebaseAuthProvider);
    return user != null;
  }

  String? userName() {
    return _ref.read(firebaseAuthProvider)?.displayName;
  }

  String? userEmail() {
    return _ref.read(firebaseAuthProvider)?.email;
  }

  Future<void> login() async {
    await _ref.read(firebaseAuthProvider.notifier).login();
  }

  Future<void> logout() async {
    await _ref.read(firebaseAuthProvider.notifier).logout();
  }
}
