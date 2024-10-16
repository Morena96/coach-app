import 'dart:convert';
import 'dart:math';

import 'package:coach_app/features/athletes/infrastructure/services/avatar_generator_service.dart';
import 'package:coach_app/features/avatars/infrastructure/models/memory_image_data.dart';
import 'package:domain/features/athletes/data/athletes_service.dart';
import 'package:domain/features/athletes/data/sports_service.dart';
import 'package:domain/features/athletes/entities/athlete.dart';
import 'package:domain/features/athletes/entities/sport.dart';
import 'package:domain/features/athletes/value_objects/athlete_filter_criteria.dart';
import 'package:domain/features/athletes/value_objects/athlete_sort_criteria.dart';
import 'package:domain/features/avatars/repositories/avatar_repository.dart';
import 'package:domain/features/shared/value_objects/filter_criteria.dart';
import 'package:domain/features/shared/value_objects/sort_order.dart';
import 'package:faker/faker.dart' hide Sport;

/// A mock implementation of the [AthletesService] for testing and development purposes.
///
/// This class generates and manages a list of fake athletes, simulating
/// database operations with artificial delay to mimic real-world scenarios.
class FakeAthletesService extends AthletesService {
  /// Internal list to store fake athlete data.
  final List<Athlete> _athletes = [];
  final SportsService sportsService;
  final AvatarGeneratorService avatarGeneratorService;
  final AvatarRepository avatarRepository;
  final Map<String, List<String>> _athleteGroupIds = {};

  /// Creates a [FakeAthletesService] and generates 1000 fake athletes.
  FakeAthletesService(
      this.sportsService, this.avatarGeneratorService, this.avatarRepository);

  /// Generates a specified number of fake athletes using the Faker package.
  ///
  /// [count] The number of fake athletes to generate.
  // You might also want to modify _generateFakeAthletes to use real sports:
  Future<void> _generateFakeAthletes(int count) async {
    final faker = Faker();
    final allSports = await sportsService.getAllSports();
    final random = Random();
    for (int i = 0; i < count; i++) {
      final generatedAvatar = avatarGeneratorService.generateAvatar();
      final id = faker.guid.guid();
      final avatar = await avatarRepository.saveAvatar(
        id,
        MemoryImageData(
          utf8.encode(generatedAvatar),
        ),
      );

      _athletes.add(
        Athlete(
          id: faker.guid.guid(),
          name: faker.person.name(),
          sports: getRandomSports(allSports, random.nextInt(3)),
          avatarId: avatar.id,
          archived: random.nextBool(), // Randomly set archived to true or false
        ),
      );
    }
  }

  /// Adds a group membership for an athlete
  void addGroupMembership(String athleteId, String groupId) {
    _athleteGroupIds.putIfAbsent(athleteId, () => []).add(groupId);
  }

  @override
  Future<void> initializeDatabase() async {
    await resetAndRefreshDatabase(count: 1000);
  }

  /// Resets the database and generates a new set of fake athletes.
  ///
  /// [count] The number of fake athletes to generate.
  ///
  /// Returns a [Future] that completes with the updated athlete after a 500ms delay.
  @override
  Future<void> resetAndRefreshDatabase({int count = 100}) async {
    _athletes.clear();
    await _generateFakeAthletes(count);
  }

  List<Sport> getRandomSports(List<Sport> allSports, int count) {
    allSports.shuffle();
    return allSports.take(count).toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  /// Retrieves all athletes with a simulated delay.
  ///
  /// Returns a [Future] that completes with a list of all athletes after a 500ms delay.
  @override
  Future<List<Athlete>> getAllAthletes() async {
    return Future.delayed(const Duration(milliseconds: 500), () => _athletes);
  }

  @override
  Future<List<Athlete>> getAthletesByIds(List<String> ids) async {
    return Future.delayed(const Duration(milliseconds: 500),
        () => _athletes.where((athlete) => ids.contains(athlete.id)).toList());
  }

  /// Retrieves a paginated list of athletes with a simulated delay.
  ///
  /// [page] The page number (0-based).
  /// [pageSize] The number of items per page.
  ///
  /// Returns a [Future] that completes with a sublist of athletes for the specified page after a 500ms delay.
  @override
  Future<List<Athlete>> getAthletesByPage(int page, int pageSize,
      {AthleteFilterCriteria? filterCriteria,
      AthleteSortCriteria? sortCriteria}) async {
    if (_athletes.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 500));
    }
    List<Athlete> filteredAthletes = List.from(_athletes);
    if (filterCriteria != null) {
      filteredAthletes = filteredAthletes.where((athlete) {
        // Apply name filter
        if (filterCriteria.name != null && filterCriteria.name!.isNotEmpty) {
          if (!athlete.name
              .toLowerCase()
              .contains(filterCriteria.name!.toLowerCase())) {
            return false;
          }
        }

        // Apply sport filter
        if (filterCriteria.sports != null &&
            filterCriteria.sports!.isNotEmpty) {
          if (!athlete.sports!.any((athleteSport) => filterCriteria.sports!
              .any((filterSportId) => athleteSport.id == filterSportId))) {
            return false;
          }
        }

        // Apply isArchived filter
        if (filterCriteria.isArchived != null) {
          if (athlete.archived != filterCriteria.isArchived) {
            return false;
          }
        }

        return true;
      }).toList();
    }

    if (sortCriteria != null && sortCriteria.field != null) {
      filteredAthletes.sort((a, b) {
        int comparison;
        switch (sortCriteria.field) {
          case 'name':
            comparison = a.name.compareTo(b.name);
            break;
          default:
            comparison = 0;
        }
        return sortCriteria.order == SortOrder.descending
            ? -comparison
            : comparison;
      });
    }

    final startIndex = page * pageSize;
    final endIndex = startIndex + pageSize;

    List<Athlete> pagedAthletes = filteredAthletes
        .sublist(
          startIndex,
          endIndex > filteredAthletes.length
              ? filteredAthletes.length
              : endIndex,
        )
        .map((athlete) => athlete.copyWith(
              groups: _athleteGroupIds[athlete.id] ?? [],
            ))
        .toList();

    return pagedAthletes;
  }

  /// Retrieves athletes based on filter criteria with a simulated delay.
  ///
  /// Note: This implementation currently ignores the filter criteria and returns all athletes.
  ///
  /// [filterCriteria] The criteria to filter athletes (currently unused).
  ///
  /// Returns a [Future] that completes with all athletes after a 500ms delay.
  @override
  Future<List<Athlete>> getAthletesByFilterCriteria(
      FilterCriteria filterCriteria) async {
    return Future.delayed(const Duration(milliseconds: 500), () {
      return _athletes;
    });
  }

  /// Retrieves an athlete by their ID with a simulated delay.
  ///
  /// [id] The ID of the athlete to retrieve.
  ///
  /// Returns a [Future] that completes with the found athlete after a 500ms delay.
  /// Throws an exception if the athlete is not found.
  @override
  Future<Athlete> getAthleteById(String id) async {
    return Future.delayed(const Duration(milliseconds: 500), () {
      return _athletes.firstWhere((athlete) => athlete.id == id);
    });
  }

  /// Creates a new athlete with a simulated delay.
  ///
  /// [athlete] The athlete to create.
  ///
  /// Returns a [Future] that completes with the created athlete after a 500ms delay.
  @override
  Future<Athlete> createAthlete(Athlete athlete) async {
    final newAthlete = athlete.copyWith(id: faker.guid.guid());
    _athletes.add(newAthlete);
    return Future.delayed(
      const Duration(milliseconds: 500),
      () => newAthlete,
    );
  }

  /// Updates an existing athlete with a simulated delay.
  ///
  /// [athlete] The athlete with updated information.
  ///
  /// Returns a [Future] that completes with the updated athlete after a 500ms delay.
  /// Throws an exception if the athlete is not found.
  @override
  Future<Athlete> updateAthlete(Athlete athlete) async {
    final index = _athletes.indexWhere((a) => a.id == athlete.id);
    if (index == -1) throw Exception('Athlete not found');
    _athletes[index] = athlete;
    return Future.delayed(const Duration(milliseconds: 500), () => athlete);
  }

  /// Archives an athlete by their ID with a simulated delay.
  ///
  /// [id] The ID of the athlete to archive.
  ///
  /// Returns a [Future] that completes after a 500ms delay.
  @override
  Future<void> deleteAthlete(String id) async {
    final index = _athletes.indexWhere((athlete) => athlete.id == id);
    if (index != -1) {
      _athletes[index] = _athletes[index].copyWith(archived: true);
    }
    return Future.delayed(const Duration(milliseconds: 500));
  }

  /// Restores an archived athlete by their ID with a simulated delay.
  ///
  /// [id] The ID of the athlete to restore.
  ///
  /// Returns a [Future] that completes with the restored athlete after a 500ms delay.
  /// Throws an exception if the athlete is not found.
  @override
  Future<Athlete> restoreAthlete(String id) async {
    return Future.delayed(const Duration(milliseconds: 500), () {
      final index = _athletes.indexWhere((athlete) => athlete.id == id);
      if (index == -1) throw Exception('Athlete not found');
      final restoredAthlete = _athletes[index].copyWith(archived: false);
      _athletes[index] = restoredAthlete;
      return restoredAthlete;
    });
  }
}
