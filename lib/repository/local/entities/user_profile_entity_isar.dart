import 'package:isar/isar.dart';

part 'user_profile_entity_isar.g.dart';

@Collection()
class UserProfileEntityIsar {
  UserProfileEntityIsar({
    required this.id,
    this.birthDate,
    this.height,
    this.weight,
  });

  Id id;
  DateTime? birthDate;
  double? height;
  double? weight;
}
