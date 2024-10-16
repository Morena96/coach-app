import 'package:coach_app/features/athletes/infrastructure/data/hive_members_data_service.dart';
import 'package:coach_app/features/athletes/infrastructure/data/hive_sports_data_service.dart';
import 'package:coach_app/features/athletes/infrastructure/data/models/hive_member.dart';
import 'package:coach_app/features/athletes/infrastructure/data/models/hive_sport.dart';
import 'package:domain/features/athletes/entities/athlete.dart';
import 'package:domain/features/athletes/entities/paginated_athletes.dart';
import 'package:domain/features/athletes/repositories/athletes.dart';
import 'package:coach_app/features/athletes/infrastructure/data/hive_athletes_data_service.dart';
import 'package:coach_app/features/athletes/infrastructure/data/models/hive_athlete.dart';
import 'package:coach_app/features/athletes/infrastructure/repositories/athletes_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:integration_test/integration_test.dart';

import '../test/unit/shared/logger/logger_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late Box<HiveAthlete> athletesBox;
  late Box<HiveSport> sportsBox;
  late Box<HiveMember> membersBox;
  late HiveAthletesDataService dataService;
  late HiveSportsDataService sportsService;
  late HiveMembersDataService membersService;
  late AthletesImpl repository;
  late RealAthletesUseCase useCase;
  late MockLogger logger;

  setUpAll(() async {
    // Initialize Hive for Flutter
    await Hive.initFlutter();
    Hive.registerAdapter(HiveAthleteAdapter());
  });

  setUp(() async {
    // Open a new box for each test
    athletesBox = await Hive.openBox<HiveAthlete>('athletes_test');
    sportsBox = await Hive.openBox('sports_test');
    membersBox = await Hive.openBox<HiveMember>('members_test');

    // Initialize real implementations
    logger = MockLogger();
    sportsService = HiveSportsDataService(sportsBox, logger);
    dataService = HiveAthletesDataService(athletesBox, sportsService,  logger);
    membersService = HiveMembersDataService(membersBox, logger);
    repository = AthletesImpl(dataService, logger, membersService);
    useCase = RealAthletesUseCase(repository);
  });

  tearDown(() async {
    // Close and delete the test box after each test
    await athletesBox.close();
    await Hive.deleteBoxFromDisk('athletes_test');
    await sportsBox.close();
    await Hive.deleteBoxFromDisk('sports_test');
  });

  group('Athletes Integration Tests', () {
    testWidgets('Create, retrieve, and paginate athletes',
        (WidgetTester tester) async {
      // Wrap the test in a MaterialApp for context
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              return ElevatedButton(
                onPressed: () async {
                  // Add athletes using the repository
                  var athlete = const Athlete(id: 'athlete_0', name: 'Athlete 0');
                  final result = await repository.addAthlete(athlete);
                  expect(result.isSuccess, true);

                  // Retrieve paginated athletes using the use case
                  final paginatedResult = await useCase.execute(1, 10);
                  expect(paginatedResult.athletes.length, 1);
                  expect(paginatedResult.totalCount, 1);
                  expect(paginatedResult.currentPage, 1);
                  expect(paginatedResult.pageSize, 10);

                  // Verify the contents of the first page
                  expect(paginatedResult.athletes[0].id, 'athlete_0');
                  expect(paginatedResult.athletes[0].name, 'Athlete 0');

                },
                child: const Text('Run Test'),
              );
            },
          ),
        ),
      ));

      // Trigger the test by tapping the button
      await tester.tap(find.text('Run Test'));
      await tester.pumpAndSettle();
    });

    testWidgets('Update and delete athletes', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (BuildContext context) {
              return ElevatedButton(
                onPressed: () async {
                  // Create a test athlete
                  const athlete =
                      Athlete(id: 'test_athlete', name: 'Test Athlete');
                  await repository.addAthlete(athlete);

                  // Retrieve the athlete
                  final getResult =
                      await repository.getAthleteById('test_athlete');
                  expect(getResult.isSuccess, true);
                  expect(getResult.value!.name, 'Test Athlete');

                  // Update the athlete
                  const updatedAthlete =
                      Athlete(id: 'test_athlete', name: 'Updated Athlete');
                  final updateResult =
                      await repository.updateAthlete(updatedAthlete);
                  expect(updateResult.isSuccess, true);

                  // Verify the update
                  final getUpdatedResult =
                      await repository.getAthleteById('test_athlete');
                  expect(getUpdatedResult.isSuccess, true);
                  expect(getUpdatedResult.value!.name, 'Updated Athlete');

                  // Delete the athlete
                  final deleteResult =
                      await repository.deleteAthlete('test_athlete');
                  expect(deleteResult.isSuccess, true);

                  // Verify the deletion
                  final getDeletedResult =
                      await repository.getAthleteById('test_athlete');
                  expect(getDeletedResult.isFailure, true);
                },
                child: const Text('Run Test'),
              );
            },
          ),
        ),
      ));

      // Trigger the test by tapping the button
      await tester.tap(find.text('Run Test'));
      await tester.pumpAndSettle();
    });

    // Add more tests as needed...
  });
}

class RealAthletesUseCase {
  final Athletes _repository;

  RealAthletesUseCase(this._repository);

  Future<PaginatedAthletes> execute(int page, int pageSize) async {
    final result = await _repository.getAthletesByPage(page, pageSize);
    if (result.isFailure) {
      throw Exception(result.error);
    }
    final totalCountResult = await _repository.getAllAthletes();
    if (totalCountResult.isFailure) {
      throw Exception(totalCountResult.error);
    }
    return PaginatedAthletes(
      athletes: result.value!,
      totalCount: totalCountResult.value!.length,
      currentPage: page,
      pageSize: pageSize,
    );
  }
}
