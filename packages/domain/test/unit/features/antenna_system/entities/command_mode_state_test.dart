import 'package:binary_data_reader/main.dart';
import 'package:domain/features/antenna_system/entities/command_mode_state.dart';
import 'package:domain/features/antenna_system/entities/state_type.dart';
import 'package:domain/features/antenna_system/repositories/antenna_command_repository.dart';
import 'package:domain/features/antenna_system/state_machine/antenna_context.dart';
import 'package:domain/features/antenna_system/state_machine/antenna_state_machine.dart';
import 'package:domain/features/logging/repositories/logger.dart';
import 'package:test/test.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks(
    [AntennaCommandRepository, LoggerRepository, AntennaStateMachine])
import 'command_mode_state_test.mocks.dart';

void main() {
  late CommandModeState commandModeState;
  late MockAntennaCommandRepository mockRepository;
  late GatewayParsingStrategy mockParsingStrategy;
  late MockLoggerRepository mockLogger;
  late AntennaContext context;
  late MockAntennaStateMachine mockStateMachine;

  setUp(() {
    mockRepository = MockAntennaCommandRepository();
    mockParsingStrategy = GatewayParsingStrategy();
    mockLogger = MockLoggerRepository();
    context = AntennaContext(
      repository: mockRepository,
      parsingStrategy: mockParsingStrategy,
      logger: mockLogger,
    );
    commandModeState = CommandModeState(context);
    mockStateMachine = MockAntennaStateMachine();
  });

  group('CommandModeState', () {
    test('should have the correct name', () {
      expect(commandModeState.name, equals('Command Mode'));
    });

    test('stateType getter returns StateType.commandMode', () {
      expect(commandModeState.stateType, equals(StateType.commandMode));
    });

    test('handleCommandReceived does nothing', () {
      // Arrange
      final command = ModeCommandCommand();

      // Act & Assert
      expect(
        () => commandModeState.handleCommandReceived(command, mockStateMachine),
        returnsNormally,
      );
    });

  });
}
