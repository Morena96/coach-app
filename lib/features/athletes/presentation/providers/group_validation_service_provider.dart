import 'package:coach_app/features/athletes/infrastructure/adapters/form_validators_adapter.dart';
import 'package:coach_app/features/athletes/infrastructure/services/groups_validation_service_impl.dart';
import 'package:domain/features/athletes/services/group_validation_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'group_validation_service_provider.g.dart';

@riverpod
GroupValidationService groupValidationService(GroupValidationServiceRef ref) {
  return GroupsValidationServiceImpl(FormValidatorsAdapter());
}
