import 'package:coach_app/features/antenna_system/presentation/antenna_system/calibration_notifier_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final calibrationNotifierProvider =
    ChangeNotifierProvider<CalibrationNotifierImpl>((ref) {
  return CalibrationNotifierImpl();
});
