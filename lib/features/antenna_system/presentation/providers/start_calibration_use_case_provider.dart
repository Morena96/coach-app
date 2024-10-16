import 'package:application/antenna_system/use_cases/start_calibration_use_case.dart';
import 'package:coach_app/features/antenna_system/presentation/providers/antenna_state_machine_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'start_calibration_use_case_provider.g.dart';

@riverpod
StartCalibrationUseCase startCalibrationUseCase(
        StartCalibrationUseCaseRef ref) =>
    StartCalibrationUseCase(ref.watch(antennaStateMachineProvider));
