import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_dyphic/model/user_profile.dart';
import 'package:simple_dyphic/repository/local/user_profile_dao.dart';

final userProfileRepository = Provider((ref) => _UserProfileRepository(ref));

class _UserProfileRepository {
  const _UserProfileRepository(this._ref);

  final Ref _ref;

  Future<UserProfile> find() async {
    final profile = await _ref.read(userProfileDaoProvider).find();
    return Future.value(profile);
  }

  Future<void> save(UserProfile userProfile) async {
    await _ref.read(userProfileDaoProvider).save(userProfile);
  }
}
