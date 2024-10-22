import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:domain/features/antenna_system/state_machine/antenna_state_machine.dart';
import 'package:application/antenna_system/use_cases/put_antenna_into_command_mode_use_case.dart';

@GenerateMocks([AntennaStateMachine])
import 'put_antenna_into_command_mode_use_case_test.mocks.dart';

void main() {
  group('PutAntennaIntoCommandModeUseCase', () {
    late MockAntennaStateMachine mockStateMachine;
    late PutAntennaIntoCommandModeUseCase useCase;

    setUp(() {
      mockStateMachine = MockAntennaStateMachine();
      useCase = PutAntennaIntoCommandModeUseCase(mockStateMachine);
    });

    test('should call transitionToCommandMode on state machine', () async {
      when(mockStateMachine.transitionToCommandMode('port1')).thenAnswer((_) async => true);

      final result = await useCase.execute('port1');

      expect(result, true);
      verify(mockStateMachine.transitionToCommandMode('port1')).called(1);
    });

    test('should return false when transition fails', () async {
      when(mockStateMachine.transitionToCommandMode('port1')).thenAnswer((_) async => false);

      final result = await useCase.execute('port1');

      expect(result, false);
      verify(mockStateMachine.transitionToCommandMode('port1')).called(1);
    });
  });
}
