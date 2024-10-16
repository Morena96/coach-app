import 'package:binary_data_reader/main.dart';
import 'package:domain/features/antenna_system/entities/pending_command_mode_state.dart';
import 'package:domain/features/antenna_system/entities/state_type.dart';
import 'package:domain/features/antenna_system/repositories/antenna_command_repository.dart';
import 'package:domain/features/antenna_system/state_machine/antenna_context.dart';
import 'package:domain/features/antenna_system/state_machine/antenna_state_machine.dart';
import 'package:domain/features/logging/repositories/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

@GenerateMocks(
    [AntennaCommandRepository, LoggerRepository, AntennaStateMachine, Command])
import 'pending_command_mode_state_test.mocks.dart';

void main() {
  late PendingCommandModeState pendingCommandModeState;
  late MockAntennaCommandRepository mockRepository;
  late GatewayParsingStrategy mockParsingStrategy;
  late MockLoggerRepository mockLogger;
  late MockAntennaStateMachine stateMachine;
  late AntennaContext context;

  setUp(() {
    mockRepository = MockAntennaCommandRepository();
    mockParsingStrategy = GatewayParsingStrategy();
    mockLogger = MockLoggerRepository();
    stateMachine = MockAntennaStateMachine();
    context = AntennaContext(
      repository: mockRepository,
      parsingStrategy: mockParsingStrategy,
      logger: mockLogger,
    );
    pendingCommandModeState = PendingCommandModeState(context);
  });

  group('PendingCommandModeState', () {
    test('should have the correct name', () {
      expect(pendingCommandModeState.name, equals('PendingCommandModeState'));
    });

    test('stateType getter returns StateType.pendingCommandMode', () {
      expect(pendingCommandModeState.stateType,
          equals(StateType.pendingCommandMode));
    });

    test('onEnter should log info', () {
      // Act
      pendingCommandModeState.onEnter(stateMachine);

      // Assert
      verify(mockLogger.info('Entering PendingCommandModeState')).called(1);
    });
  });
}
