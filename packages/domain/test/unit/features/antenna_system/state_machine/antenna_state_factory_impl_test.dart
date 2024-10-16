import 'package:domain/features/antenna_system/entities/command_mode_state.dart';
import 'package:domain/features/antenna_system/entities/error_state.dart';
import 'package:domain/features/antenna_system/entities/idle_state.dart';
import 'package:domain/features/antenna_system/entities/live_mode_state.dart';
import 'package:domain/features/antenna_system/entities/pending_command_mode_state.dart';
import 'package:domain/features/antenna_system/entities/pending_live_mode_state.dart';
import 'package:domain/features/antenna_system/entities/state_type.dart';
import 'package:domain/features/antenna_system/state_machine/antenna_context.dart';
import 'package:domain/features/antenna_system/state_machine/antenna_state_factory_impl.dart';
import 'package:test/test.dart';
import 'package:mockito/annotations.dart';

import 'antenna_state_factory_impl_test.mocks.dart';

@GenerateMocks([AntennaContext])
void main() {
  group('AntennaStateFactoryImpl', () {
    late AntennaStateFactoryImpl factory;
    late MockAntennaContext mockContext;

    setUp(() {
      mockContext = MockAntennaContext();
      factory = AntennaStateFactoryImpl(mockContext);
    });

    test('createState returns IdleState for StateType.idle', () {
      final state = factory.createState(StateType.idle, mockContext);
      expect(state, isA<IdleState>());
    });

    test('createState returns PendingCommandModeState for StateType.pendingCommandMode', () {
      final state = factory.createState(StateType.pendingCommandMode, mockContext);
      expect(state, isA<PendingCommandModeState>());
    });

    test('createState returns CommandModeState for StateType.commandMode', () {
      final state = factory.createState(StateType.commandMode, mockContext);
      expect(state, isA<CommandModeState>());
    });

    test('createState returns PendingLiveModeState for StateType.pendingLiveMode', () {
      final state = factory.createState(StateType.pendingLiveMode, mockContext);
      expect(state, isA<PendingLiveModeState>());
    });

    test('createState returns LiveModeState for StateType.liveMode', () {
      final state = factory.createState(StateType.liveMode, mockContext);
      expect(state, isA<LiveModeState>());
    });

    test('createState returns ErrorState for StateType.error', () {
      final state = factory.createState(StateType.error, mockContext);
      expect(state, isA<ErrorState>());
    });

    test('createState throws ArgumentError for unknown StateType', () {
      expect(() => factory.createState(StateType.values.last, mockContext), throwsArgumentError);
    });
  });
}

