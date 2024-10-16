import 'package:coach_app/features/athletes/presentation/providers/athletes_service_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/groups_service_provider.dart';
import 'package:coach_app/features/athletes/presentation/providers/sports_service_provider.dart';
import 'package:coach_app/features/sessions/infrastructure/data/fake_sessions_data_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:domain/features/sessions/data/sessions_data_service.dart';

part 'sessions_data_service_provider.g.dart';

@Riverpod(keepAlive: true)
SessionsDataService sessionsDataService(SessionsDataServiceRef ref) {
  final athletesService = ref.watch(athletesServiceProvider);
  final groupsService = ref.watch(groupsServiceProvider);
  final sportsService = ref.watch(sportsServiceProvider);

  final service = FakeSessionsDataService(
    athletesService: athletesService,
    groupsService: groupsService,
    sportsService: sportsService,
  );

  Future.microtask(() {
    service.initializeDatabase();
  });

  return service;
}
