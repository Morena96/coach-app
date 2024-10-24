// Mocks generated by Mockito 5.4.4 from annotations
// in application/test/sessions/use_cases/delete_session_use_case_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:domain/features/sessions/entities/gps_data_representation.dart'
    as _i8;
import 'package:domain/features/sessions/entities/session.dart' as _i5;
import 'package:domain/features/sessions/repositories/sessions_repository.dart'
    as _i3;
import 'package:domain/features/sessions/value_objects/sessions_filter_criteria.dart'
    as _i6;
import 'package:domain/features/sessions/value_objects/sessions_sort_criteria.dart'
    as _i7;
import 'package:domain/features/shared/utilities/result.dart' as _i2;
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

class _FakeResult_0<T> extends _i1.SmartFake implements _i2.Result<T> {
  _FakeResult_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [SessionsRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockSessionsRepository extends _i1.Mock
    implements _i3.SessionsRepository {
  MockSessionsRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Result<List<_i5.Session>>> getAllSessions() =>
      (super.noSuchMethod(
        Invocation.method(
          #getAllSessions,
          [],
        ),
        returnValue: _i4.Future<_i2.Result<List<_i5.Session>>>.value(
            _FakeResult_0<List<_i5.Session>>(
          this,
          Invocation.method(
            #getAllSessions,
            [],
          ),
        )),
      ) as _i4.Future<_i2.Result<List<_i5.Session>>>);

  @override
  _i4.Future<_i2.Result<List<_i5.Session>>> getSessionsByFilterCriteria(
          _i6.SessionsFilterCriteria? filterCriteria) =>
      (super.noSuchMethod(
        Invocation.method(
          #getSessionsByFilterCriteria,
          [filterCriteria],
        ),
        returnValue: _i4.Future<_i2.Result<List<_i5.Session>>>.value(
            _FakeResult_0<List<_i5.Session>>(
          this,
          Invocation.method(
            #getSessionsByFilterCriteria,
            [filterCriteria],
          ),
        )),
      ) as _i4.Future<_i2.Result<List<_i5.Session>>>);

  @override
  _i4.Future<_i2.Result<List<_i5.Session>>> getSessionsByPage(
    int? page,
    int? pageSize, {
    _i6.SessionsFilterCriteria? filterCriteria,
    _i7.SessionsSortCriteria? sortCriteria,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getSessionsByPage,
          [
            page,
            pageSize,
          ],
          {
            #filterCriteria: filterCriteria,
            #sortCriteria: sortCriteria,
          },
        ),
        returnValue: _i4.Future<_i2.Result<List<_i5.Session>>>.value(
            _FakeResult_0<List<_i5.Session>>(
          this,
          Invocation.method(
            #getSessionsByPage,
            [
              page,
              pageSize,
            ],
            {
              #filterCriteria: filterCriteria,
              #sortCriteria: sortCriteria,
            },
          ),
        )),
      ) as _i4.Future<_i2.Result<List<_i5.Session>>>);

  @override
  _i4.Future<_i2.Result<_i5.Session>> getSessionById(String? id) =>
      (super.noSuchMethod(
        Invocation.method(
          #getSessionById,
          [id],
        ),
        returnValue: _i4.Future<_i2.Result<_i5.Session>>.value(
            _FakeResult_0<_i5.Session>(
          this,
          Invocation.method(
            #getSessionById,
            [id],
          ),
        )),
      ) as _i4.Future<_i2.Result<_i5.Session>>);

  @override
  _i4.Future<_i2.Result<_i5.Session>> addSession(_i5.Session? session) =>
      (super.noSuchMethod(
        Invocation.method(
          #addSession,
          [session],
        ),
        returnValue: _i4.Future<_i2.Result<_i5.Session>>.value(
            _FakeResult_0<_i5.Session>(
          this,
          Invocation.method(
            #addSession,
            [session],
          ),
        )),
      ) as _i4.Future<_i2.Result<_i5.Session>>);

  @override
  _i4.Future<_i2.Result<void>> updateSession(_i5.Session? session) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateSession,
          [session],
        ),
        returnValue: _i4.Future<_i2.Result<void>>.value(_FakeResult_0<void>(
          this,
          Invocation.method(
            #updateSession,
            [session],
          ),
        )),
      ) as _i4.Future<_i2.Result<void>>);

  @override
  _i4.Future<_i2.Result<void>> deleteSession(String? id) => (super.noSuchMethod(
        Invocation.method(
          #deleteSession,
          [id],
        ),
        returnValue: _i4.Future<_i2.Result<void>>.value(_FakeResult_0<void>(
          this,
          Invocation.method(
            #deleteSession,
            [id],
          ),
        )),
      ) as _i4.Future<_i2.Result<void>>);

  @override
  _i4.Future<_i2.Result<List<_i5.Session>>> getSessionsByIds(
          List<String>? ids) =>
      (super.noSuchMethod(
        Invocation.method(
          #getSessionsByIds,
          [ids],
        ),
        returnValue: _i4.Future<_i2.Result<List<_i5.Session>>>.value(
            _FakeResult_0<List<_i5.Session>>(
          this,
          Invocation.method(
            #getSessionsByIds,
            [ids],
          ),
        )),
      ) as _i4.Future<_i2.Result<List<_i5.Session>>>);

  @override
  _i4.Future<_i2.Result<List<_i5.Session>>> getSessionsForGroup(
          String? groupId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getSessionsForGroup,
          [groupId],
        ),
        returnValue: _i4.Future<_i2.Result<List<_i5.Session>>>.value(
            _FakeResult_0<List<_i5.Session>>(
          this,
          Invocation.method(
            #getSessionsForGroup,
            [groupId],
          ),
        )),
      ) as _i4.Future<_i2.Result<List<_i5.Session>>>);

  @override
  _i4.Future<_i2.Result<List<_i5.Session>>> getSessionsForAthlete(
          String? athleteId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getSessionsForAthlete,
          [athleteId],
        ),
        returnValue: _i4.Future<_i2.Result<List<_i5.Session>>>.value(
            _FakeResult_0<List<_i5.Session>>(
          this,
          Invocation.method(
            #getSessionsForAthlete,
            [athleteId],
          ),
        )),
      ) as _i4.Future<_i2.Result<List<_i5.Session>>>);

  @override
  _i4.Future<_i2.Result<void>> addGpsDataRepresentationToSession(
    String? sessionId,
    _i8.GpsDataRepresentation? gpsDataRepresentation,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #addGpsDataRepresentationToSession,
          [
            sessionId,
            gpsDataRepresentation,
          ],
        ),
        returnValue: _i4.Future<_i2.Result<void>>.value(_FakeResult_0<void>(
          this,
          Invocation.method(
            #addGpsDataRepresentationToSession,
            [
              sessionId,
              gpsDataRepresentation,
            ],
          ),
        )),
      ) as _i4.Future<_i2.Result<void>>);

  @override
  _i4.Future<_i2.Result<void>> removeGpsDataRepresentationFromSession(
    String? sessionId,
    String? gpsDataRepresentationId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #removeGpsDataRepresentationFromSession,
          [
            sessionId,
            gpsDataRepresentationId,
          ],
        ),
        returnValue: _i4.Future<_i2.Result<void>>.value(_FakeResult_0<void>(
          this,
          Invocation.method(
            #removeGpsDataRepresentationFromSession,
            [
              sessionId,
              gpsDataRepresentationId,
            ],
          ),
        )),
      ) as _i4.Future<_i2.Result<void>>);
}
