/// Calibration notifier abstract class
/// which is used to notify changes in calibration process
abstract class CalibrationNotifier {
  /// Notify progress
  void onProgress(double progress);

  /// Notify completion
  void onComplete();

  /// Notify error
  void onError(String message);
}
