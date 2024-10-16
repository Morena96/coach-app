import 'package:coach_app/features/athletes/infrastructure/adapters/form_validators_adapter.dart';
import 'package:coach_app/features/athletes/infrastructure/services/athletes_validation_service_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:domain/features/athletes/services/athlete_validation_service.dart';

part 'athlete_validation_service_provider.g.dart';

@riverpod
AthleteValidationService athleteValidationService(AthleteValidationServiceRef ref) {
  return AthleteValidationServiceImpl(FormValidatorsAdapter());
}
