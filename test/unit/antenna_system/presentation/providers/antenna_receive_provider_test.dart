import 'package:application/antenna_system/use_cases/get_antenna_data_stream.dart';
import 'package:coach_app/features/antenna_system/presentation/providers/antenna_receive_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';

@GenerateMocks([GetAntennaDataStreamUseCase])
import 'antenna_receive_provider_test.mocks.dart';

void main() {
  late MockGetAntennaDataStreamUseCase mockGetAntennaDataStreamUseCase;
  late ProviderContainer container;

  setUp(() {
    mockGetAntennaDataStreamUseCase = MockGetAntennaDataStreamUseCase();

    container = ProviderContainer(
      overrides: [
        getAntennaDataStreamUseCaseProvider.overrideWithValue(mockGetAntennaDataStreamUseCase),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

    test('getAntennaDataStreamUseCaseProvider provides GetAntennaDataStreamUseCase', () {
      final useCase = container.read(getAntennaDataStreamUseCaseProvider);
      expect(useCase, isA<GetAntennaDataStreamUseCase>());
    });

  test('antennaDataStream provides Stream of List<String>', () async {
    const portName = 'COM3';
    final messages = [
      'message1',
      'message2', 
      'message3',
    ];
    final testStream = Stream.fromIterable(messages);

    when(mockGetAntennaDataStreamUseCase.call(portName)).thenAnswer((_) => testStream);

    container.read(antennaDataStreamProvider(portName).future);

    completion(messages);
  });
}
