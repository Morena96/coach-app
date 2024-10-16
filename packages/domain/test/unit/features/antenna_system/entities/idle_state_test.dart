import 'package:domain/features/antenna_system/state_machine/antenna_context.dart';
import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:binary_data_reader/main.dart';
import 'package:domain/features/antenna_system/entities/idle_state.dart';
import 'package:domain/features/antenna_system/repositories/antenna_command_repository.dart';
import 'package:domain/features/antenna_system/state_machine/antenna_state_machine.dart';
import 'package:domain/features/logging/repositories/logger.dart';

@GenerateMocks([AntennaCommandRepository, AntennaStateMachine, LoggerRepository, Command])
import 'idle_state_test.mocks.dart';

void main() {
  late IdleState idleState;
  late MockAntennaCommandRepository mockRepository;
  late MockAntennaStateMachine mockStateMachine;
  late MockLoggerRepository mockLogger;
  late FrameParsingStrategy parsingStrategy;
  late AntennaContext context;

  setUp(() {
    mockRepository = MockAntennaCommandRepository();
    mockStateMachine = MockAntennaStateMachine();
    mockLogger = MockLoggerRepository();
    parsingStrategy = GatewayParsingStrategy();
    context = AntennaContext(repository: mockRepository, parsingStrategy: parsingStrategy, logger: mockLogger);
    idleState = IdleState(context);
  });

  group('IdleState', () {
    test('should have correct name', () {
      expect(idleState.name, equals('Idle State'));
    });

    test('should handle command received', () {
      final mockCommand = MockCommand();
      idleState.handleCommandReceived(mockCommand, mockStateMachine);
      // Add assertions here for how IdleState should handle commands
    });

    // Add more tests specific to IdleState behavior
  });
}
