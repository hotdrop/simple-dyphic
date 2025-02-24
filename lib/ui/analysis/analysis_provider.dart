import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:simple_dyphic/model/user_profile.dart';

part 'analysis_provider.g.dart';

@riverpod
class Analysis extends _$Analysis {
  @override
  AnalysisState build() {
    return AnalysisState();
  }

  Future<void> generateAdvice(UserProfile profile) async {
    if (profile.isEmpty()) {
      state = state.copyWith(error: 'プロフィール情報を入力してください');
      return;
    }

    state = state.copyWith(isLoading: true);
    try {
      // TODO: ここでLLMのAPIを呼び出し、アドバイスを生成
      await Future.delayed(const Duration(seconds: 2));
      state = state.copyWith(
        isLoading: false,
        advice: '先週の運動量は良好です。年齢相応の運動量を維持できています。\n\n'
            '歩数: 8,000歩/日の平均は、健康維持に適した量です。\n'
            'リングフィットでの運動も継続的に行えており、素晴らしい習慣が付いています。',
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: '分析の生成に失敗しました: $e',
      );
    }
  }
}

@riverpod
class UserProfileController extends _$UserProfileController {
  @override
  UserProfile build() {
    return UserProfile();
  }

  void updateAge(int? age) {
    state = state.copyWith(age: age);
  }

  void updateHeight(double? height) {
    state = state.copyWith(height: height);
  }
}

class AnalysisState {
  final bool isLoading;
  final String? advice;
  final String? error;

  AnalysisState({
    this.isLoading = false,
    this.advice,
    this.error,
  });

  AnalysisState copyWith({
    bool? isLoading,
    String? advice,
    String? error,
  }) {
    return AnalysisState(
      isLoading: isLoading ?? this.isLoading,
      advice: advice ?? this.advice,
      error: error ?? this.error,
    );
  }
}
