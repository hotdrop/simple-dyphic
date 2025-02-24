import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_dyphic/model/user_profile.dart';
import 'package:simple_dyphic/repository/local/entities/user_profile_entity_isar.dart';
import 'package:simple_dyphic/repository/local/local_data_source.dart';

final userProfileDaoProvider = Provider((ref) => _UserProfileDao(ref));

class _UserProfileDao {
  const _UserProfileDao(this.ref);

  final Ref ref;

  Future<UserProfile> find() async {
    final isar = ref.read(localDataSourceProvider).isar;
    final userProfile = await isar.userProfileEntityIsars.get(1);
    if (userProfile == null) {
      return UserProfile();
    }
    return _entityToModel(userProfile);
  }

  Future<void> save(UserProfile userProfile) async {
    final isar = ref.read(localDataSourceProvider).isar;
    await isar.writeTxn(() async {
      final entity = _modelToEntity(userProfile);
      await isar.userProfileEntityIsars.put(entity);
    });
  }

  UserProfile _entityToModel(UserProfileEntityIsar entity) {
    return UserProfile(
      birthDate: entity.birthDate,
      height: entity.height,
      weight: entity.weight,
    );
  }

  UserProfileEntityIsar _modelToEntity(UserProfile userProfile) {
    return UserProfileEntityIsar(
      id: 1,
      birthDate: userProfile.birthDate,
      height: userProfile.height,
      weight: userProfile.weight,
    );
  }
}
