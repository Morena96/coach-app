import 'dart:async';

import 'package:domain/features/athletes/data/sports_service.dart';
import 'package:domain/features/athletes/entities/sport.dart' as domain;
import 'package:domain/features/athletes/value_objects/sport_filter_criteria.dart';
import 'package:faker/faker.dart';

/// A mock implementation of the [SportsService] for testing and development purposes.
///
/// This class generates and manages a list of fake sports, simulating
/// database operations with artificial delay to mimic real-world scenarios.
class FakeSportsService extends SportsService {
  /// Internal list to store fake sport data.
  final List<domain.Sport> _sports = [];

  /// Creates a [FakeSportsService] and generates 25 fake sports.
  FakeSportsService() {
    _generateFakeSports(25);
  }

  /// Generates a specified number of fake sports using the Faker package.
  ///
  /// [count] The number of fake sports to generate.
  void _generateFakeSports(int count) {
    final faker = Faker();
    final Set<String> uniqueSportNames = {};
    while (uniqueSportNames.length < count) {
      final sportName = faker.sport.name();
      if (uniqueSportNames.add(sportName)) {
        _sports.add(domain.Sport(
          id: faker.guid.guid(),
          name: sportName,
        ));
      }
    }
    _sports.sort((a, b) => a.name.compareTo(b.name));
  }

  /// Retrieves all sports with a simulated delay.
  ///
  /// Returns a [Future] that completes with a list of all sports after a 300ms delay.
  @override
  Future<List<domain.Sport>> getAllSports(
      {SportFilterCriteria? filterCriteria}) async {
    final searchQuery = filterCriteria?.name;
    return Future.delayed(const Duration(milliseconds: 300), () {
      if (searchQuery == null || searchQuery.isEmpty) {
        return List<domain.Sport>.from(_sports);
      }
      return _sports
          .where((sport) =>
              sport.name.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    });
  }

  @override
  Future<List<domain.Sport>> getSportsByPage(
    int page,
    int pageSize, {
    SportFilterCriteria? filterCriteria,
  }) async {
    if (_sports.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 500));
    }
    List<domain.Sport> filteredSports = List.from(_sports);
    if (filterCriteria != null) {
      filteredSports = filteredSports.where((sport) {
        // Apply name filter
        if (filterCriteria.name != null && filterCriteria.name!.isNotEmpty) {
          if (!sport.name
              .toLowerCase()
              .contains(filterCriteria.name!.toLowerCase())) {
            return false;
          }
        }

        return true;
      }).toList();
    }

    final startIndex = page * pageSize;
    final endIndex = startIndex + pageSize;

    List<domain.Sport> pagedSports = filteredSports
        .sublist(
          startIndex,
          endIndex > filteredSports.length ? filteredSports.length : endIndex,
        )
        .toList();

    return pagedSports;
  }

  /// Retrieves sports by their IDs with a simulated delay.
  ///
  /// [ids] The list of sport IDs to retrieve.
  ///
  /// Returns a [Future] that completes with a list of found sports after a 300ms delay.
  @override
  Future<List<domain.Sport>> getSportsByIds(List<String> ids) async {
    return Future.delayed(const Duration(milliseconds: 300), () {
      return _sports.where((sport) => ids.contains(sport.id)).toList();
    });
  }

  /// Creates a new sport with a simulated delay.
  ///
  /// [sport] The sport to create.
  ///
  /// Returns a [Future] that completes with the created sport after a 300ms delay.
  @override
  Future<domain.Sport> createSport(domain.Sport sport) async {
    _sports.add(sport);
    return Future.delayed(const Duration(milliseconds: 300), () => sport);
  }

  /// Deletes a sport by its ID with a simulated delay.
  ///
  /// [id] The ID of the sport to delete.
  ///
  /// Returns a [Future] that completes after a 300ms delay.
  @override
  Future<void> deleteSport(String id) async {
    _sports.removeWhere((sport) => sport.id == id);
    return Future.delayed(const Duration(milliseconds: 300));
  }

  /// Retrieves a sport by its ID with a simulated delay.
  ///
  /// [id] The ID of the sport to retrieve.
  ///
  /// Returns a [Future] that completes with the found sport after a 300ms delay.
  /// Throws an exception if the sport is not found.
  @override
  Future<domain.Sport> getSportById(String id) async {
    return Future.delayed(const Duration(milliseconds: 300), () {
      final sport = _sports.firstWhere(
        (sport) => sport.id == id,
        orElse: () => throw Exception('Sport not found'),
      );
      return sport;
    });
  }

  /// Updates an existing sport with a simulated delay.
  ///
  /// [sport] The sport with updated information.
  ///
  /// Returns a [Future] that completes with the updated sport after a 300ms delay.
  /// Throws an exception if the sport is not found.
  @override
  Future<domain.Sport> updateSport(domain.Sport sport) async {
    return Future.delayed(const Duration(milliseconds: 300), () {
      final index = _sports.indexWhere((s) => s.id == sport.id);
      if (index == -1) throw Exception('Sport not found');
      _sports[index] = sport;
      return sport;
    });
  }
}
