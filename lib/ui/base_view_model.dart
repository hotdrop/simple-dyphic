import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_view_model.freezed.dart';

class BaseViewModel extends ChangeNotifier {
  UIState _uiState = OnLoading();
  UIState get uiState => _uiState;

  void nowLoading() {
    _uiState = OnLoading();
    notifyListeners();
  }

  void onSuccess() {
    _uiState = OnSuccess();
    notifyListeners();
  }

  void onError(Exception e) {
    _uiState = OnError(e);
    notifyListeners();
  }
}

@freezed
class UIState with _$UIState {
  const factory UIState.loading() = OnLoading;
  const factory UIState.success() = OnSuccess;
  const factory UIState.error(Exception e) = OnError;
}
