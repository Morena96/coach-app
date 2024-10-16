import 'package:flutter_test/flutter_test.dart';
import 'package:coach_app/features/athletes/presentation/providers/athlete_validation_service_provider.dart';
import 'package:domain/features/athletes/services/athlete_validation_service.dart';
import 'package:riverpod/riverpod.dart';

void main() {
  group('AthleteValidationServiceProvider', () {
    test('should provide an instance of AthleteValidationService', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final athleteValidationService = container.read(athleteValidationServiceProvider);

      expect(athleteValidationService, isA<AthleteValidationService>());
    });

    test('should always return the same instance', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final firstInstance = container.read(athleteValidationServiceProvider);
      final secondInstance = container.read(athleteValidationServiceProvider);

      expect(identical(firstInstance, secondInstance), isTrue);
    });
  });
}
