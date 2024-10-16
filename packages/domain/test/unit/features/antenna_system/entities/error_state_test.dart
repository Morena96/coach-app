import 'package:domain/features/antenna_system/entities/state_type.dart';
import 'package:domain/features/antenna_system/state_machine/antenna_context.dart';
import 'package:test/test.dart';

import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:binary_data_reader/main.dart';
import 'package:domain/features/antenna_system/entities/error_state.dart';
import 'package:domain/features/antenna_system/repositories/antenna_command_repository.dart';
import 'package:domain/features/antenna_system/state_machine/antenna_state_machine.dart';
import 'package:domain/features/logging/repositories/logger.dart';

@GenerateMocks(
    [AntennaCommandRepository, AntennaStateMachine, LoggerRepository, Command])
import 'error_state_test.mocks.dart';

void main() {
  late ErrorState errorState;
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
    errorState = ErrorState(context, 'Test error message');
  });

  group('ErrorState', () {
    test('should log error message on enter', () {
      errorState.onEnter(mockStateMachine);
      verify(mockLogger.error('Test error message')).called(1);
    });

    test('stateType getter returns StateType.error', () {
      expect(errorState.stateType, equals(StateType.error));
    });

    test('should have correct name', () {
      expect(errorState.name, equals('ErrorState'));
    });

    test('should handle command received', () {
      final mockCommand = MockCommand();
      errorState.handleCommandReceived(mockCommand, mockStateMachine);
      // Add assertions here if you implement error recovery logic
    });

    test('should initialize with correct error message', () {
      expect(errorState.errorMessage, equals('Test error message'));
    });
  });
}
