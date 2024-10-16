import 'dart:async';

import 'package:binary_data_reader/main.dart';
import 'package:domain/features/antenna_system/calibration/calibration_manager.dart';
import 'package:domain/features/antenna_system/entities/antenna_state.dart';
import 'package:domain/features/antenna_system/entities/calibration_state.dart';
import 'package:domain/features/antenna_system/entities/command_mode_state.dart';
import 'package:domain/features/antenna_system/entities/idle_state.dart';
import 'package:domain/features/antenna_system/entities/live_mode_state.dart';
import 'package:domain/features/antenna_system/repositories/antenna_command_repository.dart';
import 'package:domain/features/antenna_system/state_machine/antenna_context.dart';
import 'package:domain/features/antenna_system/state_machine/antenna_state_machine.dart';
import 'package:domain/features/antenna_system/value_objects/antenna_config.dart';
import 'package:domain/features/logging/repositories/logger.dart';
import 'package:domain/features/shared/utilities/reactive_stream.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

@GenerateMocks([
  AntennaCommandRepository,
  AntennaStateMachine,
  AntennaState,
  ModeCommandCommand,
  ModeLiveCommand,
  CalibrationManager,
  CalibrationState,
  LoggerRepository,
  ReactiveStream<AntennaState>
])
import 'antenna_system_state_machine_test.mocks.dart';

class IsAntennaState extends Matcher {
  @override
  bool matches(item, Map matchState) => item is AntennaState;

  @override
  Description describe(Description description) =>
      description.add('is an AntennaState');
}

void main() {
  late MockAntennaCommandRepository mockRepository;
  late StreamController<Command> commandStreamController;
  late AntennaStateMachine stateMachine;
  late CalibrationManager mockCalibrationService;
  late MockReactiveStream<AntennaState> mockStateStream;
  late AntennaContext context;
  late MockLoggerRepository mockLogger;

  setUp(() {
    mockRepository = MockAntennaCommandRepository();
    mockCalibrationService = MockCalibrationManager();
    mockLogger = MockLoggerRepository();
    context = AntennaContext(
        parsingStrategy: GatewayParsingStrategy(),
        repository: mockRepository,
        logger: mockLogger);
    mockStateStream = MockReactiveStream<AntennaState>();
    commandStreamController = StreamController<Command>();
    stateMachine = AntennaStateMachine(
        context, commandStreamController.stream, mockStateStream,
        calibrationService: mockCalibrationService);
  });

  group('AntennaStateMachine tests', () {
    test('AntennaStateMachine initializes with IdleState', () {
      expect(stateMachine.currentState, isA<IdleState>());
    });

    test('AntennaStateMachine changes state correctly', () {
      final newState = MockAntennaState();
      when(newState.name).thenReturn('MockState');
      stateMachine.setState(newState);
      expect(stateMachine.currentState, equals(newState));
    });

    test('AntennaStateMachine handles received commands', () async {
      final mockCommand = MockModeCommandCommand();
      final mockState = MockAntennaState();

      when(mockState.name).thenReturn('MockState');

      stateMachine.setState(mockState);

      commandStreamController.add(mockCommand);

      // Wait for the event to be processed
      await Future.delayed(Duration.zero);

      verify(mockState.handleCommandReceived(mockCommand, stateMachine))
          .called(1);
    });

    test('AntennaStateMachine sends commands correctly', () {
      final mockCommand = MockModeCommandCommand();
      final mockState = MockAntennaState();
      when(mockState.name).thenReturn('MockState');
      stateMachine.setState(mockState);

      stateMachine.sendCommand(mockCommand);

      verify(mockState.sendCommand(mockCommand)).called(1);
    });

    group('CalibrationState tests', () {
      test(
          'startCalibration transitions to CalibrationState when calibration service is provided',
          () async {
        var streamController = StreamController<Command>();

        when(mockCalibrationService.startCalibration())
            .thenAnswer((_) => Future.value());

        stateMachine = AntennaStateMachine(
            context, streamController.stream, mockStateStream,
            calibrationService: mockCalibrationService);

        stateMachine.startCalibration();

        expect(stateMachine.currentState, isA<CalibrationState>());
      });

      test(
          'startCalibration throws StateError when calibration service is not provided',
          () async {
        var streamController = StreamController<Command>();

        stateMachine = AntennaStateMachine(
            context, streamController.stream, mockStateStream);

        expect(
            () => stateMachine.startCalibration(), throwsA(isA<StateError>()));
      });

      test(
          'dispose cancels the command subscription and closes the state stream',
          () async {
        var streamController = StreamController<Command>();

        stateMachine = AntennaStateMachine(
            context, streamController.stream, mockStateStream,
            calibrationService: mockCalibrationService);

        // Dispose the state machine
        stateMachine.dispose();

        // Verify that the subscription is cancelled
        verify(mockStateStream.close()).called(1);
      });
    });

    group('transitionToCommandMode', () {
      test('should transition to command mode successfully', () async {
        var streamController = StreamController<Command>.broadcast();
        stateMachine = AntennaStateMachine(
            context, streamController.stream, mockStateStream,
            calibrationService: mockCalibrationService);

        when(mockRepository.sendCommandToAll(any)).thenAnswer((_) async {});
        when(mockStateStream.add(any)).thenAnswer((_) async {});

        // Set initial state to IdleState
        stateMachine.setState(IdleState(context));

        // Simulate the command response
        streamController.add(ModeCommandCommand());

        final result = await stateMachine.transitionToCommandMode();

        expect(result, isTrue);
        expect(stateMachine.currentState, isA<CommandModeState>());
        verify(mockRepository.sendCommandToAll(any)).called(1);
      });

      test('should fail to transition to command mode', () async {
        var streamController = StreamController<Command>.broadcast();
        stateMachine = AntennaStateMachine(
            context, streamController.stream, mockStateStream,
            calibrationService: mockCalibrationService,
            commandTimeout: const Duration(milliseconds: 1));

        when(mockRepository.sendCommandToAll(any)).thenAnswer((_) async {});
        when(mockStateStream.add(any)).thenAnswer((_) async {});

        // Don't add any command to the stream to simulate a timeout

        final result = await stateMachine.transitionToCommandMode();

        expect(result, isFalse);
        expect(stateMachine.currentState, isA<IdleState>());
        verify(mockRepository.sendCommandToAll(any)).called(1);
      });
    });

    group('Should transition to live mode', () {
      test('should transition to live mode successfully', () async {
        var streamController = StreamController<Command>.broadcast();
        stateMachine = AntennaStateMachine(
            context, streamController.stream, mockStateStream,
            calibrationService: mockCalibrationService);

        when(mockRepository.sendCommandToAll(any)).thenAnswer((_) async {});
        when(mockStateStream.add(any)).thenAnswer((_) async {});

        // Set initial state to CommandModeState
        stateMachine.setState(CommandModeState(context));

        // Simulate the command response
        streamController.add(ModeLiveCommand());

        final result = await stateMachine.transitionToLiveMode();

        expect(result, isTrue);
        expect(stateMachine.currentState, isA<LiveModeState>());
        verify(mockRepository.sendCommandToAll(any)).called(1);
      });

      test('should fail to transition to live mode', () async {
        var streamController = StreamController<Command>.broadcast();
        stateMachine = AntennaStateMachine(
            context, streamController.stream, mockStateStream,
            calibrationService: mockCalibrationService,
            commandTimeout: const Duration(milliseconds: 1));

        when(mockRepository.sendCommandToAll(any)).thenAnswer((_) async {});
        when(mockStateStream.add(any)).thenAnswer((_) async {});

        // Don't add any command to the stream to simulate a timeout

        final result = await stateMachine.transitionToLiveMode();

        expect(result, isFalse);
        expect(stateMachine.currentState, isA<CommandModeState>());
        verify(mockRepository.sendCommandToAll(any)).called(1);
      });
    });

    group('Can set config', () {
      test('should set config successfully', () async {
        var streamController = StreamController<Command>.broadcast();
        stateMachine = AntennaStateMachine(
            context, streamController.stream, mockStateStream,
            calibrationService: mockCalibrationService,
            commandTimeout: const Duration(milliseconds: 1));

        when(mockRepository.sendCommandToAll(any)).thenAnswer((_) async {});
        when(mockStateStream.add(any)).thenAnswer((_) async {});

        // Set initial state to CommandModeState
        stateMachine.setState(CommandModeState(context));

        // Simulate the command response
        streamController.add(SetConfigCommand(
          masterId: 1,
          frequency: 2,
          mainFrequency: 1,
          isMain: true,
          clubId: 1,
        ));

        final result = await stateMachine.setConfig(AntennaConfig(
            masterId: 1,
            frequency: 3,
            mainFrequency: 4,
            isMain: true,
            clubId: 1));

        expect(result, isTrue);
        verify(mockRepository.sendCommandToAll(any)).called(1);
      });

      test('should fail to set config due to timeout', () async {
        var streamController = StreamController<Command>.broadcast();
        stateMachine = AntennaStateMachine(
            context, streamController.stream, mockStateStream,
            calibrationService: mockCalibrationService,
            commandTimeout: const Duration(milliseconds: 1));

        when(mockRepository.sendCommandToAll(any)).thenAnswer((_) async {});
        when(mockStateStream.add(any)).thenAnswer((_) async {});

        stateMachine.setState(CommandModeState(context));

        // Don't add any command to the stream to simulate a timeout

        final result = await stateMachine.setConfig(AntennaConfig(
            masterId: 1,
            frequency: 3,
            mainFrequency: 4,
            isMain: true,
            clubId: 1));

        expect(result, isFalse);
        verify(mockRepository.sendCommandToAll(any)).called(1);
      });

      test('should fail to set config when not in CommandModeState', () async {
        var streamController = StreamController<Command>.broadcast();
        stateMachine = AntennaStateMachine(
            context, streamController.stream, mockStateStream,
            calibrationService: mockCalibrationService);

        // Set initial state to LiveModeState
        stateMachine.setState(LiveModeState(context));

        final result = await stateMachine.setConfig(AntennaConfig(
            masterId: 1,
            frequency: 3,
            mainFrequency: 4,
            isMain: true,
            clubId: 1));

        expect(result, isFalse);
        verifyNever(mockRepository.sendCommandToAll(any));
      });
    });

    group('Can set all pods to live mode', () {
      test('should set all pods to live mode when in LiveModeState', () {
        var streamController = StreamController<Command>.broadcast();
        stateMachine = AntennaStateMachine(
            context, streamController.stream, mockStateStream,
            calibrationService: mockCalibrationService);

        // Set initial state to LiveModeState
        stateMachine.setState(LiveModeState(context));

        stateMachine.setAllPodsToLive();

        verify(mockRepository.sendCommandToAll(any)).called(1);
      });

      test('should not set pods to live mode when not in LiveModeState', () {
        var streamController = StreamController<Command>.broadcast();
        stateMachine = AntennaStateMachine(
            context, streamController.stream, mockStateStream,
            calibrationService: mockCalibrationService);

        // Set initial state to CommandModeState
        stateMachine.setState(CommandModeState(context));

        stateMachine.setAllPodsToLive();

        verifyNever(mockRepository.sendCommandToAll(any));
      });
    });
  });
}
