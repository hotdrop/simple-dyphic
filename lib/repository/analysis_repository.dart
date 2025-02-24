import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_dyphic/model/user_profile.dart';

final analysisRepository = Provider((ref) => _AnalysisRepository(ref));

class _AnalysisRepository {
  const _AnalysisRepository(this._ref);

  final Ref _ref;

  // TODO データを整形してLLMに送信する
}
