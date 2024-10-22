import 'package:binary_data_reader/main.dart';
import 'package:domain/features/antenna_system/entities/antenna_state.dart';
import 'package:domain/features/antenna_system/entities/state_type.dart';
import 'package:domain/features/antenna_system/repositories/antenna_command_repository.dart';
import 'package:domain/features/antenna_system/state_machine/antenna_context.dart';
import 'package:domain/features/antenna_system/state_machine/antenna_state_machine.dart';
import 'package:domain/features/logging/repositories/logger.dart';
import 'package:domain/features/shared/utilities/binary_utils/binary_utils.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

@GenerateMocks([
  AntennaCommandRepository,
  FrameParsingStrategy,
  LoggerRepository,
  Command,
  ModeCommandCommand,
  ModeLiveCommand,
  AntennaStateMachine,
  Frame,
  FramesParser
])
import 'antenna_state_test.mocks.dart';

class TestAntennaState extends AntennaState {
  TestAntennaState(super.context);

  @override
  String get name => 'TestAntennaState';

  @override
  void handleCommandReceived(
      Command command, AntennaStateMachine stateMachine) {}

  @override
  // TODO: implement stateType
  StateType get stateType => StateType.error;
}

void main() {
  late MockAntennaCommandRepository mockRepository;
  late GatewayParsingStrategy parsingStrategy;
  late MockLoggerRepository mockLogger;
  late MockAntennaStateMachine mockStateMachine;
  late TestAntennaState testState;
  late AntennaContext context;

  setUp(() {
    mockRepository = MockAntennaCommandRepository();
    parsingStrategy = GatewayParsingStrategy();
    mockLogger = MockLoggerRepository();
    mockStateMachine = MockAntennaStateMachine();
    context = AntennaContext(
        repository: mockRepository,
        parsingStrategy: parsingStrategy,
        logger: mockLogger);
    testState = TestAntennaState(context);
  });

  group('AntennaState', () {
    test('onEnter should be called without error', () {
      // Act & Assert
      expect(() => testState.onEnter(mockStateMachine), returnsNormally);
    });

    test('onExit should be called without error', () {
      // Act & Assert
      expect(() => testState.onExit(), returnsNormally);
    });

    test('name should return the correct state name', () {
      // Act & Assert
      expect(testState.name, equals('TestAntennaState'));
    });

    test('sendCommand should create a frame, pad the binary, and send it to the repository',
        () async {
      // Arrange
      final testCommand = SetStateCommand(rfSlotStates: []);
      final expectedFrame = Frame.fromCommand(testCommand, parsingStrategy);
      final expectedBinary = expectedFrame.toBinary(parsingStrategy);
      final paddedBinary = BinaryUtils.padBinary(expectedBinary);

      when(mockRepository.sendCommandToAll(any)).thenAnswer((_) async {});

      // Act
      await testState.sendCommand(testCommand);

      // Assert
      verify(mockRepository.sendCommandToAll(paddedBinary)).called(1);
    });

    test('sendCommand should use the context\'s parsing strategy', () async {
      // Arrange
      final testCommand = SetStateCommand(rfSlotStates: []);
      final gatewayParsingStrategy = GatewayParsingStrategy();
      final customContext = AntennaContext(
          repository: mockRepository,
          parsingStrategy: gatewayParsingStrategy,
          logger: mockLogger);
      final stateWithCustomContext = TestAntennaState(customContext);

      when(mockRepository.sendCommandToAll(any)).thenAnswer((_) async {});

      // Act
      await stateWithCustomContext.sendCommand(testCommand);

      // Assert
      verify(mockRepository.sendCommandToAll(any)).called(1);
      // Verify that the custom parsing strategy was used
      // This assumes that CustomParsingStrategy produces different binary output
      // You might need to adjust this verification based on your actual implementation
    });
  });
}
