import 'package:binary_data_reader/main.dart';
import 'package:domain/features/antenna_system/entities/error_state.dart';
import 'package:domain/features/antenna_system/entities/state_type.dart';
import 'package:domain/features/antenna_system/entities/timeout_state.dart';
import 'package:domain/features/antenna_system/repositories/antenna_command_repository.dart';
import 'package:domain/features/antenna_system/state_machine/antenna_context.dart';
import 'package:domain/features/antenna_system/state_machine/antenna_state_machine.dart';
import 'package:domain/features/logging/repositories/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

@GenerateMocks(
    [AntennaCommandRepository, AntennaStateMachine, LoggerRepository])
import 'timeout_state_test.mocks.dart';

class TestTimeoutState extends TimeoutState {
  TestTimeoutState(super.context,
      {required super.timeout, required super.maxRetries});

  @override
  String get name => 'TestTimeoutState';

  @override
  void handleCommandReceived(
      Command command, AntennaStateMachine stateMachine) {}

  @override
  StateType get stateType => throw UnimplementedError();
}

void main() {
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
    context = AntennaContext(
      repository: mockRepository,
      parsingStrategy: parsingStrategy,
      logger: mockLogger,
    );
  });

  group('TimeoutState', () {
    test('should start timer on startTimer call', () {
      final timeoutState = TestTimeoutState(
        context,
        timeout: const Duration(seconds: 5),
        maxRetries: 3,
      );
      timeoutState.startTimer(mockStateMachine);
      expect(timeoutState.timeout, equals(const Duration(seconds: 5)));
    });

    test('should cancel timer on cancelTimer call', () {
      final timeoutState = TestTimeoutState(
        context,
        timeout: const Duration(seconds: 5),
        maxRetries: 3,
      );
      timeoutState.startTimer(mockStateMachine);
      timeoutState.cancelTimer();
      // We can't directly test if the timer is cancelled, but we can test that calling cancelTimer doesn't throw an error
      expect(() => timeoutState.cancelTimer(), returnsNormally);
    });

    test('should transition to ErrorState on timeout', () async {
      final timeoutState = TestTimeoutState(
        context,
        timeout: const Duration(milliseconds: 100),
        maxRetries: 3,
      );

      timeoutState.startTimer(mockStateMachine);

      // Wait for the timeout to occur (after 3 retries)
      await Future.delayed(const Duration(milliseconds: 100));
      expect(timeoutState.isTimerActive(), true);
      await Future.delayed(const Duration(milliseconds: 100));
      expect(timeoutState.isTimerActive(), true);
      await Future.delayed(const Duration(milliseconds: 100));
      expect(timeoutState.isTimerActive(), true);
      await Future.delayed(const Duration(milliseconds: 100));
      expect(timeoutState.isTimerActive(), false);

      verify(mockStateMachine.setState(argThat(isA<ErrorState>()))).called(1);
    });

    test('should cancel timer on onExit', () {
      final timeoutState = TestTimeoutState(
        context,
        timeout: const Duration(seconds: 5),
        maxRetries: 3,
      );
      timeoutState.startTimer(mockStateMachine);
      timeoutState.onExit();
      expect(timeoutState.isTimerActive(), isFalse);
      expect(() => timeoutState.startTimer(mockStateMachine), returnsNormally);
    });

    test('should retry maxRetries times before transitioning to ErrorState',
        () async {
      final timeoutState = TestTimeoutState(
        context,
        timeout: const Duration(milliseconds: 100),
        maxRetries: 3,
      );

      timeoutState.startTimer(mockStateMachine);

      // Wait for 3 retries and the final timeout
      for (int i = 0; i < 4; i++) {
        await Future.delayed(const Duration(milliseconds: 110));
      }

      verify(mockStateMachine.setState(argThat(isA<ErrorState>()))).called(1);
    });

    test('should reset retry count on onEnter', () async {
      final timeoutState = TestTimeoutState(
        context,
        timeout: const Duration(milliseconds: 100),
        maxRetries: 3,
      );

      timeoutState.startTimer(mockStateMachine);

      // Wait for 2 retries
      for (int i = 0; i < 2; i++) {
        await Future.delayed(const Duration(milliseconds: 110));
      }

      // Simulate exiting and re-entering the state
      timeoutState.onExit();
      timeoutState.onEnter(mockStateMachine);

      // Wait for 3 more retries and the final timeout
      for (int i = 0; i < 4; i++) {
        await Future.delayed(const Duration(milliseconds: 110));
      }

      // Verify that ErrorState is set only once, after all retries
      verify(mockStateMachine.setState(argThat(isA<ErrorState>()))).called(1);
    });

    test('should not transition to ErrorState if successful before maxRetries',
        () async {
      final timeoutState = TestTimeoutState(
        context,
        timeout: const Duration(milliseconds: 100),
        maxRetries: 3,
      );

      timeoutState.startTimer(mockStateMachine);

      // Wait for 2 retries
      for (int i = 0; i < 2; i++) {
        await Future.delayed(const Duration(milliseconds: 110));
      }

      // Simulate successful operation
      timeoutState.cancelTimer();

      // Wait for what would have been the final timeout
      await Future.delayed(const Duration(milliseconds: 110));

      verifyNever(mockStateMachine.setState(argThat(isA<ErrorState>())));
    });
  });
}
