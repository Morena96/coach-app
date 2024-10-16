import 'package:application/antenna_system/use_cases/receive_commands_usecase.dart';
import 'package:binary_data_reader/main.dart';
import 'package:coach_app/features/antenna_system/presentation/providers/antenna_command_source_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'receive_commands_use_case_provider.g.dart';

@riverpod
Stream<Command> receiveCommandsUseCase(ReceiveCommandsUseCaseRef ref) {
  final commandSource = ref.watch(antennaCommandSourceProvider);

  return ReceiveCommandsUseCase(commandSource).execute();
}
