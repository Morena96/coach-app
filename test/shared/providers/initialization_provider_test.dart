import 'package:domain/features/athletes/data/athletes_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:coach_app/core/app_state.dart';
import 'package:coach_app/features/athletes/presentation/providers/athletes_service_provider.dart';
import 'package:coach_app/shared/providers/initialization_provider.dart';
import 'package:coach_app/shared/providers/riverpod_singletons.dart';
import 'package:coach_app/shared/repositories/connectivity_repository.dart';

// Generate mocks
@GenerateMocks([ConnectivityRepository, AthletesService, AppState])
import 'initialization_provider_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('initializationProvider initializes correctly with mocked dependencies',
      () async {
    // Arrange
    final mockConnectivityRepository = MockConnectivityRepository();
    final mockAthletesService = MockAthletesService();

    when(mockConnectivityRepository.connectivityStream)
        .thenAnswer((_) => Stream.value(true));
    when(mockConnectivityRepository.initialize()).thenAnswer((_) async {});
    when(mockAthletesService.initializeDatabase()).thenAnswer((_) async {});

    final container = ProviderContainer(
      overrides: [
        connectivityRepositoryProvider
            .overrideWithValue(mockConnectivityRepository),
        athletesServiceProvider.overrideWithValue(mockAthletesService),
      ],
    );

    // Act
    await container.read(initializationProvider.future);

    // Assert
    verify(mockConnectivityRepository.initialize()).called(1);
    verify(mockAthletesService.initializeDatabase()).called(1);
  });
}
