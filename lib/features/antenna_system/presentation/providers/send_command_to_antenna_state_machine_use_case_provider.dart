import 'package:application/antenna_system/use_cases/send_command_to_antenna_state_machine_use_case.dart';
import 'package:coach_app/features/antenna_system/presentation/providers/antenna_state_machine_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'send_command_to_antenna_state_machine_use_case_provider.g.dart';

@riverpod
SendCommandToAntennaStateMachineUseCase sendCommandToAntennaStateMachineUseCase(
    SendCommandToAntennaStateMachineUseCaseRef ref) {
  var stateMachine = ref.watch(antennaStateMachineProvider);

  return SendCommandToAntennaStateMachineUseCase(stateMachine);
}
