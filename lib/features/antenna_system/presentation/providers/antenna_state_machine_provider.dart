import 'package:binary_data_reader/main.dart';
import 'package:coach_app/features/antenna_system/presentation/providers/antenna_command_source_provider.dart';
import 'package:coach_app/features/antenna_system/presentation/providers/antenna_system_provider.dart';
import 'package:coach_app/features/antenna_system/presentation/providers/calibration_service_provider.dart';
import 'package:coach_app/features/shared/utils/rx_behavior_stream.dart';
import 'package:coach_app/shared/providers/logger_provider.dart';
import 'package:domain/features/antenna_system/entities/antenna_state.dart';
import 'package:domain/features/antenna_system/state_machine/antenna_context.dart';
import 'package:domain/features/antenna_system/state_machine/antenna_state_machine.dart';
import 'package:domain/features/logging/repositories/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'antenna_state_machine_provider.g.dart';

@Riverpod(keepAlive: true)
AntennaStateMachine antennaStateMachine(AntennaStateMachineRef ref) {
  final commandSource = ref.watch(antennaCommandSourceProvider);
  final antennaCommandRepository = ref.watch(antennaCommandRepositoryProvider);
  final calibrationService = ref.watch(calibrationServiceProvider);
  final LoggerRepository logger = ref.watch(loggerProvider);
  return AntennaStateMachine(
      AntennaContext(
          parsingStrategy: GatewayParsingStrategy(),
          repository: antennaCommandRepository,
          logger: logger),
      commandSource.getCommands(),
      RxBehaviorStream<AntennaState>(),
      calibrationService: calibrationService);
}
