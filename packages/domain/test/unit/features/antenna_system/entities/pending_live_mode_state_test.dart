import 'package:binary_data_reader/main.dart';
import 'package:domain/features/antenna_system/entities/pending_live_mode_state.dart';
import 'package:domain/features/antenna_system/entities/state_type.dart';
import 'package:domain/features/antenna_system/repositories/antenna_command_repository.dart';
import 'package:domain/features/antenna_system/state_machine/antenna_context.dart';
import 'package:domain/features/antenna_system/state_machine/antenna_state_machine.dart';
import 'package:domain/features/logging/repositories/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:test/test.dart';

@GenerateMocks(
    [AntennaCommandRepository, LoggerRepository, AntennaStateMachine, Command])
import 'pending_live_mode_state_test.mocks.dart';

void main() {
  late PendingLiveModeState pendingLiveModeState;
  late MockAntennaCommandRepository mockRepository;
  late GatewayParsingStrategy mockParsingStrategy;
  late MockLoggerRepository mockLogger;
  late AntennaContext context;

  setUp(() {
    mockRepository = MockAntennaCommandRepository();
    mockParsingStrategy = GatewayParsingStrategy();
    mockLogger = MockLoggerRepository();
    context = AntennaContext(
      repository: mockRepository,
      parsingStrategy: mockParsingStrategy,
      logger: mockLogger,
    );
    pendingLiveModeState = PendingLiveModeState(context);
  });

  group('PendingLiveModeState', () {
    test('should have the correct name', () {
      expect(pendingLiveModeState.name, equals('PendingLiveModeState'));
    });

    test('stateType getter returns StateType.pendingLiveMode', () {
      expect(pendingLiveModeState.stateType, equals(StateType.pendingLiveMode));
    });
  });
}
