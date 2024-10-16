import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppState extends ChangeNotifier {
  bool _isConnected;

  AppState({bool isConnected = false}) : _isConnected = isConnected;

  bool get isConnected => _isConnected;

  void setConnectivityStatus(bool isConnected) {
    _isConnected = isConnected;
    notifyListeners();
  }
}

class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier() : super(AppState(isConnected: false));

  void setConnectivityStatus(bool isConnected) {
    state = AppState(isConnected: isConnected);
  }
}

final appStateProvider =
    StateNotifierProvider<AppStateNotifier, AppState>((ref) {
  return AppStateNotifier();
});
