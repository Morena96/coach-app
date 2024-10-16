// Mocks generated by Mockito 5.4.4 from annotations
// in application/test/athletes/application/use_cases/set_athlete_avatar_use_case.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:domain/features/athletes/entities/athlete.dart' as _i6;
import 'package:domain/features/athletes/repositories/athletes.dart' as _i4;
import 'package:domain/features/athletes/value_objects/athlete_filter_criteria.dart'
    as _i8;
import 'package:domain/features/athletes/value_objects/athlete_sort_criteria.dart'
    as _i9;
import 'package:domain/features/avatars/entities/avatar.dart' as _i3;
import 'package:domain/features/avatars/entities/image_data.dart' as _i11;
import 'package:domain/features/avatars/repositories/avatar_repository.dart'
    as _i10;
import 'package:domain/features/logging/entities/log_entry.dart' as _i13;
import 'package:domain/features/logging/repositories/logger.dart' as _i12;
import 'package:domain/features/shared/utilities/result.dart' as _i2;
import 'package:domain/features/shared/value_objects/filter_criteria.dart'
    as _i7;
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

class _FakeAvatar_1 extends _i1.SmartFake implements _i3.Avatar {
  _FakeAvatar_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [Athletes].
///
/// See the documentation for Mockito's code generation for more information.
class MockAthletes extends _i1.Mock implements _i4.Athletes {
  MockAthletes() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Future<_i2.Result<List<_i6.Athlete>>> getAllAthletes() =>
      (super.noSuchMethod(
        Invocation.method(
          #getAllAthletes,
          [],
        ),
        returnValue: _i5.Future<_i2.Result<List<_i6.Athlete>>>.value(
            _FakeResult_0<List<_i6.Athlete>>(
          this,
          Invocation.method(
            #getAllAthletes,
            [],
          ),
        )),
      ) as _i5.Future<_i2.Result<List<_i6.Athlete>>>);

  @override
  _i5.Future<_i2.Result<List<_i6.Athlete>>> getAthletesByFilterCriteria(
          _i7.FilterCriteria? filterCriteria) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAthletesByFilterCriteria,
          [filterCriteria],
        ),
        returnValue: _i5.Future<_i2.Result<List<_i6.Athlete>>>.value(
            _FakeResult_0<List<_i6.Athlete>>(
          this,
          Invocation.method(
            #getAthletesByFilterCriteria,
            [filterCriteria],
          ),
        )),
      ) as _i5.Future<_i2.Result<List<_i6.Athlete>>>);

  @override
  _i5.Future<_i2.Result<List<_i6.Athlete>>> getAthletesByPage(
    int? page,
    int? pageSize, {
    _i8.AthleteFilterCriteria? filterCriteria,
    _i9.AthleteSortCriteria? sortCriteria,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAthletesByPage,
          [
            page,
            pageSize,
          ],
          {
            #filterCriteria: filterCriteria,
            #sortCriteria: sortCriteria,
          },
        ),
        returnValue: _i5.Future<_i2.Result<List<_i6.Athlete>>>.value(
            _FakeResult_0<List<_i6.Athlete>>(
          this,
          Invocation.method(
            #getAthletesByPage,
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
      ) as _i5.Future<_i2.Result<List<_i6.Athlete>>>);

  @override
  _i5.Future<_i2.Result<_i6.Athlete>> getAthleteById(String? id) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAthleteById,
          [id],
        ),
        returnValue: _i5.Future<_i2.Result<_i6.Athlete>>.value(
            _FakeResult_0<_i6.Athlete>(
          this,
          Invocation.method(
            #getAthleteById,
            [id],
          ),
        )),
      ) as _i5.Future<_i2.Result<_i6.Athlete>>);

  @override
  _i5.Future<_i2.Result<_i6.Athlete>> addAthlete(_i6.Athlete? athlete) =>
      (super.noSuchMethod(
        Invocation.method(
          #addAthlete,
          [athlete],
        ),
        returnValue: _i5.Future<_i2.Result<_i6.Athlete>>.value(
            _FakeResult_0<_i6.Athlete>(
          this,
          Invocation.method(
            #addAthlete,
            [athlete],
          ),
        )),
      ) as _i5.Future<_i2.Result<_i6.Athlete>>);

  @override
  _i5.Future<_i2.Result<void>> updateAthlete(_i6.Athlete? athlete) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateAthlete,
          [athlete],
        ),
        returnValue: _i5.Future<_i2.Result<void>>.value(_FakeResult_0<void>(
          this,
          Invocation.method(
            #updateAthlete,
            [athlete],
          ),
        )),
      ) as _i5.Future<_i2.Result<void>>);

  @override
  _i5.Future<_i2.Result<void>> deleteAthlete(String? id) => (super.noSuchMethod(
        Invocation.method(
          #deleteAthlete,
          [id],
        ),
        returnValue: _i5.Future<_i2.Result<void>>.value(_FakeResult_0<void>(
          this,
          Invocation.method(
            #deleteAthlete,
            [id],
          ),
        )),
      ) as _i5.Future<_i2.Result<void>>);

  @override
  _i5.Future<_i2.Result<List<_i6.Athlete>>> getAthletesByIds(
          List<String>? ids) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAthletesByIds,
          [ids],
        ),
        returnValue: _i5.Future<_i2.Result<List<_i6.Athlete>>>.value(
            _FakeResult_0<List<_i6.Athlete>>(
          this,
          Invocation.method(
            #getAthletesByIds,
            [ids],
          ),
        )),
      ) as _i5.Future<_i2.Result<List<_i6.Athlete>>>);

  @override
  _i5.Future<_i2.Result<void>> restoreAthlete(String? id) =>
      (super.noSuchMethod(
        Invocation.method(
          #restoreAthlete,
          [id],
        ),
        returnValue: _i5.Future<_i2.Result<void>>.value(_FakeResult_0<void>(
          this,
          Invocation.method(
            #restoreAthlete,
            [id],
          ),
        )),
      ) as _i5.Future<_i2.Result<void>>);
}

/// A class which mocks [AvatarRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockAvatarRepository extends _i1.Mock implements _i10.AvatarRepository {
  MockAvatarRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Future<_i3.Avatar> saveAvatar(
    String? id,
    _i11.ImageData? imageData,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #saveAvatar,
          [
            id,
            imageData,
          ],
        ),
        returnValue: _i5.Future<_i3.Avatar>.value(_FakeAvatar_1(
          this,
          Invocation.method(
            #saveAvatar,
            [
              id,
              imageData,
            ],
          ),
        )),
      ) as _i5.Future<_i3.Avatar>);

  @override
  _i5.Future<_i11.ImageData?> getAvatarImage(String? avatarId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAvatarImage,
          [avatarId],
        ),
        returnValue: _i5.Future<_i11.ImageData?>.value(),
      ) as _i5.Future<_i11.ImageData?>);

  @override
  _i5.Future<void> downloadAvatar(
    String? avatarId,
    String? remoteUrl,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #downloadAvatar,
          [
            avatarId,
            remoteUrl,
          ],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<void> markAvatarAsSynced(_i3.Avatar? avatar) =>
      (super.noSuchMethod(
        Invocation.method(
          #markAvatarAsSynced,
          [avatar],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<_i3.Avatar> getAvatar(String? avatarId) => (super.noSuchMethod(
        Invocation.method(
          #getAvatar,
          [avatarId],
        ),
        returnValue: _i5.Future<_i3.Avatar>.value(_FakeAvatar_1(
          this,
          Invocation.method(
            #getAvatar,
            [avatarId],
          ),
        )),
      ) as _i5.Future<_i3.Avatar>);
}

/// A class which mocks [LoggerRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockLoggerRepository extends _i1.Mock implements _i12.LoggerRepository {
  MockLoggerRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Stream<_i13.LogEntry> get logStream => (super.noSuchMethod(
        Invocation.getter(#logStream),
        returnValue: _i5.Stream<_i13.LogEntry>.empty(),
      ) as _i5.Stream<_i13.LogEntry>);

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