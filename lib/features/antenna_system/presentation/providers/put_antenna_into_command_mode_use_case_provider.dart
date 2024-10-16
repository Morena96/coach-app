import 'package:application/antenna_system/use_cases/put_antenna_into_command_mode_use_case.dart';
import 'package:coach_app/features/antenna_system/presentation/providers/antenna_state_machine_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'put_antenna_into_command_mode_use_case_provider.g.dart';

@riverpod
PutAntennaIntoCommandModeUseCase putAntennaIntoCommandModeUseCase(
    PutAntennaIntoCommandModeUseCaseRef ref) {
  var stateMachine = ref.watch(antennaStateMachineProvider);

  return PutAntennaIntoCommandModeUseCase(stateMachine);
}
