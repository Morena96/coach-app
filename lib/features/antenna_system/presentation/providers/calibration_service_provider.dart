import 'package:binary_data_reader/main.dart';
import 'package:domain/features/antenna_system/calibration/calibration_manager.dart';
import 'package:domain/features/antenna_system/calibration/calibration_service.dart';
import 'package:coach_app/features/antenna_system/presentation/providers/antenna_system_provider.dart';
import 'package:coach_app/features/antenna_system/presentation/providers/calibration_notifier_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'calibration_service_provider.g.dart';

@Riverpod(keepAlive: true)
CalibrationService calibrationService(CalibrationServiceRef ref) {
  final dataRepository = ref.watch(antennaDataRepositoryProvider);
  final commandRepository = ref.watch(antennaCommandRepositoryProvider);
  final notifier = ref.watch(calibrationNotifierProvider);
  final parsingStrategy = GatewayParsingStrategy();
  return CalibrationManager(
      dataRepository: dataRepository,
      commandRepository: commandRepository,
      notifier: notifier,
      parsingStrategy: parsingStrategy);
}
