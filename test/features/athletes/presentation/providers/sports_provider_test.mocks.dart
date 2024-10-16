// Mocks generated by Mockito 5.4.4 from annotations
// in coach_app/test/features/athletes/presentation/providers/sports_provider_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:domain/features/athletes/data/sports_service.dart' as _i3;
import 'package:domain/features/athletes/entities/sport.dart' as _i2;
import 'package:domain/features/athletes/value_objects/sport_filter_criteria.dart'
    as _i5;
import 'package:domain/features/logging/entities/log_entry.dart' as _i7;
import 'package:domain/features/logging/repositories/logger.dart' as _i6;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeSport_0 extends _i1.SmartFake implements _i2.Sport {
  _FakeSport_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [SportsService].
///
/// See the documentation for Mockito's code generation for more information.
class MockSportsService extends _i1.Mock implements _i3.SportsService {
  MockSportsService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<List<_i2.Sport>> getAllSports(
          {_i5.SportFilterCriteria? filterCriteria}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAllSports,
          [],
          {#filterCriteria: filterCriteria},
        ),
        returnValue: _i4.Future<List<_i2.Sport>>.value(<_i2.Sport>[]),
      ) as _i4.Future<List<_i2.Sport>>);

  @override
  _i4.Future<List<_i2.Sport>> getSportsByPage(
    int? page,
    int? pageSize, {
    _i5.SportFilterCriteria? filterCriteria,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getSportsByPage,
          [
            page,
            pageSize,
          ],
          {#filterCriteria: filterCriteria},
        ),
        returnValue: _i4.Future<List<_i2.Sport>>.value(<_i2.Sport>[]),
      ) as _i4.Future<List<_i2.Sport>>);

  @override
  _i4.Future<List<_i2.Sport>> getSportsByIds(List<String>? ids) =>
      (super.noSuchMethod(
        Invocation.method(
          #getSportsByIds,
          [ids],
        ),
        returnValue: _i4.Future<List<_i2.Sport>>.value(<_i2.Sport>[]),
      ) as _i4.Future<List<_i2.Sport>>);

  @override
  _i4.Future<_i2.Sport> createSport(_i2.Sport? sport) => (super.noSuchMethod(
        Invocation.method(
          #createSport,
          [sport],
        ),
        returnValue: _i4.Future<_i2.Sport>.value(_FakeSport_0(
          this,
          Invocation.method(
            #createSport,
            [sport],
          ),
        )),
      ) as _i4.Future<_i2.Sport>);

  @override
  _i4.Future<void> deleteSport(String? id) => (super.noSuchMethod(
        Invocation.method(
          #deleteSport,
          [id],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<_i2.Sport> getSportById(String? id) => (super.noSuchMethod(
        Invocation.method(
          #getSportById,
          [id],
        ),
        returnValue: _i4.Future<_i2.Sport>.value(_FakeSport_0(
          this,
          Invocation.method(
            #getSportById,
            [id],
          ),
        )),
      ) as _i4.Future<_i2.Sport>);

  @override
  _i4.Future<_i2.Sport> updateSport(_i2.Sport? sport) => (super.noSuchMethod(
        Invocation.method(
          #updateSport,
          [sport],
        ),
        returnValue: _i4.Future<_i2.Sport>.value(_FakeSport_0(
          this,
          Invocation.method(
            #updateSport,
            [sport],
          ),
        )),
      ) as _i4.Future<_i2.Sport>);
}

/// A class which mocks [LoggerRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockLoggerRepository extends _i1.Mock implements _i6.LoggerRepository {
  MockLoggerRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Stream<_i7.LogEntry> get logStream => (super.noSuchMethod(
        Invocation.getter(#logStream),
        returnValue: _i4.Stream<_i7.LogEntry>.empty(),
      ) as _i4.Stream<_i7.LogEntry>);

  @override
  void debug(String? message) => super.noSuchMethod(
        Invocation.method(
          #debug,
          [message],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void info(String? message) => super.noSuchMethod(
        Invocation.method(
          #info,
          [message],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void warning(String? message) => super.noSuchMethod(
        Invocation.method(
          #warning,
          [message],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void error(
    String? message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) =>
      super.noSuchMethod(
        Invocation.method(
          #error,
          [
            message,
            error,
            stackTrace,
          ],
        ),
        returnValueForMissingStub: null,
      );
}
