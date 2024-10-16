import 'package:coach_app/features/athletes/infrastructure/repositories/groups_impl.dart';
import 'package:coach_app/features/athletes/presentation/providers/athletes_service_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/groups_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/groups_service_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/id_generator_provider.dart';
import 'package:coach_app/shared/providers/logger_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../mocks.mocks.dart';
// Import your necessary files here

void main() {
  test('groupsProvider creates GroupsImpl with correct dependencies', () {
    final mockAthletesService = MockAthletesService();
    final mockGroupsService = MockGroupsService();
    final mockLogger = MockLoggerRepository();
    final mockIdGenerator = MockIdGenerator();

    final container = ProviderContainer(
      overrides: [
        athletesServiceProvider.overrideWithValue(mockAthletesService),
        groupsServiceProvider.overrideWithValue(mockGroupsService),
        loggerProvider.overrideWithValue(mockLogger),
        idGeneratorProvider.overrideWithValue(mockIdGenerator),
      ],
    );

    final groups = container.read(groupsProvider);

    expect(groups, isA<GroupsImpl>());
  });
}
