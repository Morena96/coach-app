import 'package:application/pods/use_cases/save_pod_use_case.dart';
import 'package:application/pods/use_cases/update_pod_use_case.dart';
import 'package:domain/features/pods/entities/pod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';
import 'package:domain/features/pods/repositories/pods.dart';
import 'package:coach_app/features/pods/presentation/providers/pods_providers.dart';
import 'package:coach_app/features/pods/presentation/providers/pods_use_case_providers.dart';
import 'package:application/pods/use_cases/get_all_pods_use_case.dart';
import 'package:application/pods/use_cases/get_pod_by_id_use_case.dart';

@GenerateMocks([Pods])
import 'pods_use_case_providers_test.mocks.dart';

void main() {
  late ProviderContainer container;
  late MockPods mockPods;

  setUp(() {
    mockPods = MockPods();
    container = ProviderContainer(
      overrides: [
        podsProvider.overrideWithValue(mockPods),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('PodsUseCaseProviders', () {
    test('getAllPodsUseCaseProvider returns a GetAllPodsUseCase', () {
      final useCase = container.read(getAllPodsUseCaseProvider);
      expect(useCase, isA<GetAllPodsUseCase>());
    });

    test('getPodByIdUseCaseProvider returns a GetPodByIdUseCase', () {
      final useCase = container.read(getPodByIdUseCaseProvider);
      expect(useCase, isA<GetPodByIdUseCase>());
    });

    test('updatePodUseCaseProvider returns an UpdatePodUseCase', () {
      final useCase = container.read(updatePodUseCaseProvider);
      expect(useCase, isA<UpdatePodUseCase>());
    });

    test('savePodUseCaseProvider returns a SavePodUseCase', () {
      final useCase = container.read(savePodUseCaseProvider);
      expect(useCase, isA<SavePodUseCase>());
    });

    test('use cases are created with the correct Pods instance', () {
      final getAllPodsUseCase = container.read(getAllPodsUseCaseProvider);
      final getPodByIdUseCase = container.read(getPodByIdUseCaseProvider);
      final updatePodUseCase = container.read(updatePodUseCaseProvider);
      final savePodUseCase = container.read(savePodUseCaseProvider);

      when(mockPods.getAllPods()).thenAnswer((_) async => []);
      when(mockPods.getPodById('test_id')).thenAnswer((_) async => Pod(id: 'test_id', number: 1, rfSlot: 1));
      when(mockPods.updatePod(any)).thenAnswer((_) async {});
      when(mockPods.savePod(any)).thenAnswer((_) async {});

      // Verify that each use case is created with the mocked Pods instance
      getAllPodsUseCase.execute();
      getPodByIdUseCase.execute('test_id');
      updatePodUseCase.execute(Pod(id: '1', number: 1, rfSlot: 1));
      savePodUseCase.execute(Pod(id: '1', number: 1, rfSlot: 1));

      verify(mockPods.getAllPods()).called(1);
      verify(mockPods.getPodById('test_id')).called(1);
      verify(mockPods.updatePod(any)).called(1);
      verify(mockPods.savePod(any)).called(1);
    });
  });
}
