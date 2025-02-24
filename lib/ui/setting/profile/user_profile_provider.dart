import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:simple_dyphic/model/user_profile.dart';
import 'package:simple_dyphic/repository/user_profile_repository.dart';

part 'user_profile_provider.g.dart';

@riverpod
class UserProfileController extends _$UserProfileController {
  @override
  Future<UserProfile> build() async {
    final profile = await ref.read(userProfileRepository).find();
    return profile;
  }

  void inputBirthDate(DateTime newVal) {
    ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(birthDate: newVal));
  }

  void inputHeight(double newVal) {
    ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(height: newVal));
  }

  void inputWeight(double newVal) {
    ref.read(_uiStateProvider.notifier).update((state) => state.copyWith(weight: newVal));
  }

  Future<void> save(UserProfile currentProfile) async {
    final newProfile = ref.read(_uiStateProvider).toUserProfile(currentProfile);
    await ref.read(userProfileRepository).save(newProfile);
  }
}

final _uiStateProvider = StateProvider<_UiState>((_) => _UiState());

///
/// 入力保持用のクラス
///
class _UiState {
  _UiState({
    this.birthDate,
    this.height,
    this.weight,
  });

  final DateTime? birthDate;
  final double? height;
  final double? weight;

  _UiState copyWith({
    DateTime? birthDate,
    double? height,
    double? weight,
  }) {
    return _UiState(
      birthDate: birthDate ?? this.birthDate,
      height: height ?? this.height,
      weight: weight ?? this.weight,
    );
  }

  UserProfile toUserProfile(UserProfile currentProfile) {
    return UserProfile(
      birthDate: birthDate ?? currentProfile.birthDate,
      height: height ?? currentProfile.height,
      weight: weight ?? currentProfile.weight,
    );
  }
}
