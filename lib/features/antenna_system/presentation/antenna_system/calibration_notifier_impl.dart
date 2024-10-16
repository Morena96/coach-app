import 'package:domain/features/antenna_system/calibration/calibration_notifier.dart';
import 'package:flutter/material.dart';

class CalibrationNotifierImpl extends ChangeNotifier
    implements CalibrationNotifier {
  double _progress = 0.0;
  String? _error;
  bool _isComplete = false;

  double get progress => _progress;

  String? get error => _error;

  bool get isComplete => _isComplete;

  @override
  void onProgress(double progress) {
    _progress = progress;
    notifyListeners();
  }

  @override
  void onComplete() {
    _isComplete = true;
    notifyListeners();
  }

  @override
  void onError(String message) {
    _error = message;
    notifyListeners();
  }

  void reset() {
    _progress = 0.0;
    _error = null;
    _isComplete = false;
    notifyListeners();
  }
}
