import 'package:application/antenna_system/use_cases/put_antenna_into_command_mode_use_case.dart';
import 'package:coach_app/features/antenna_system/presentation/providers/put_antenna_into_command_mode_use_case_provider.dart';
import 'package:coach_app/features/antenna_system/presentation/providers/antenna_state_machine_provider.dart';
import 'package:domain/features/antenna_system/state_machine/antenna_state_machine.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';

@GenerateMocks([AntennaStateMachine])
import 'put_antenna_into_command_mode_use_case_provider_test.mocks.dart';

void main() {
  late MockAntennaStateMachine mockAntennaStateMachine;
  late ProviderContainer container;

  setUp(() {
    mockAntennaStateMachine = MockAntennaStateMachine();

    container = ProviderContainer(
      overrides: [
        antennaStateMachineProvider.overrideWithValue(mockAntennaStateMachine),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('putAntennaIntoCommandModeUseCaseProvider provides PutAntennaIntoCommandModeUseCase', () {
    final useCase = container.read(putAntennaIntoCommandModeUseCaseProvider);
    expect(useCase, isA<PutAntennaIntoCommandModeUseCase>());
  });

  test('PutAntennaIntoCommandModeUseCase is created with the correct AntennaStateMachine', () {
    final useCase = container.read(putAntennaIntoCommandModeUseCaseProvider);
    expect(useCase, isA<PutAntennaIntoCommandModeUseCase>());
    
    // Verify that the use case is created with the mocked AntennaStateMachine
    when(mockAntennaStateMachine.transitionToCommandMode('port1')).thenAnswer((_) async => true);
    useCase.execute('port1');
    verify(mockAntennaStateMachine.transitionToCommandMode('port1')).called(1);
  });
}
