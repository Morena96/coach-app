// Mocks generated by Mockito 5.4.4 from annotations
// in coach_app/test/unit/athletes/infrastructure/fake_groups_service_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:coach_app/features/athletes/infrastructure/services/avatar_generator_service.dart'
    as _i7;
import 'package:domain/features/athletes/data/sports_service.dart' as _i4;
import 'package:domain/features/athletes/entities/sport.dart' as _i2;
import 'package:domain/features/athletes/value_objects/sport_filter_criteria.dart'
    as _i6;
import 'package:domain/features/avatars/entities/avatar.dart' as _i3;
import 'package:domain/features/avatars/entities/image_data.dart' as _i10;
import 'package:domain/features/avatars/repositories/avatar_repository.dart'
    as _i9;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i8;

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

class _FakeAvatar_1 extends _i1.SmartFake implements _i3.Avatar {
  _FakeAvatar_1(
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
class MockSportsService extends _i1.Mock implements _i4.SportsService {
  MockSportsService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Future<List<_i2.Sport>> getAllSports(
          {_i6.SportFilterCriteria? filterCriteria}) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAllSports,
          [],
          {#filterCriteria: filterCriteria},
        ),
        returnValue: _i5.Future<List<_i2.Sport>>.value(<_i2.Sport>[]),
      ) as _i5.Future<List<_i2.Sport>>);

  @override
  _i5.Future<List<_i2.Sport>> getSportsByPage(
    int? page,
    int? pageSize, {
    _i6.SportFilterCriteria? filterCriteria,
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
        returnValue: _i5.Future<List<_i2.Sport>>.value(<_i2.Sport>[]),
      ) as _i5.Future<List<_i2.Sport>>);

  @override
  _i5.Future<List<_i2.Sport>> getSportsByIds(List<String>? ids) =>
      (super.noSuchMethod(
        Invocation.method(
          #getSportsByIds,
          [ids],
        ),
        returnValue: _i5.Future<List<_i2.Sport>>.value(<_i2.Sport>[]),
      ) as _i5.Future<List<_i2.Sport>>);

  @override
  _i5.Future<_i2.Sport> createSport(_i2.Sport? sport) => (super.noSuchMethod(
        Invocation.method(
          #createSport,
          [sport],
        ),
        returnValue: _i5.Future<_i2.Sport>.value(_FakeSport_0(
          this,
          Invocation.method(
            #createSport,
            [sport],
          ),
        )),
      ) as _i5.Future<_i2.Sport>);

  @override
  _i5.Future<void> deleteSport(String? id) => (super.noSuchMethod(
        Invocation.method(
          #deleteSport,
          [id],
        ),
        returnValue: _i5.Future<void>.value(),
        returnValueForMissingStub: _i5.Future<void>.value(),
      ) as _i5.Future<void>);

  @override
  _i5.Future<_i2.Sport> getSportById(String? id) => (super.noSuchMethod(
        Invocation.method(
          #getSportById,
          [id],
        ),
        returnValue: _i5.Future<_i2.Sport>.value(_FakeSport_0(
          this,
          Invocation.method(
            #getSportById,
            [id],
          ),
        )),
      ) as _i5.Future<_i2.Sport>);

  @override
  _i5.Future<_i2.Sport> updateSport(_i2.Sport? sport) => (super.noSuchMethod(
        Invocation.method(
          #updateSport,
          [sport],
        ),
        returnValue: _i5.Future<_i2.Sport>.value(_FakeSport_0(
          this,
          Invocation.method(
            #updateSport,
            [sport],
          ),
        )),
      ) as _i5.Future<_i2.Sport>);
}

/// A class which mocks [AvatarGeneratorService].
///
/// See the documentation for Mockito's code generation for more information.
class MockAvatarGeneratorService extends _i1.Mock
    implements _i7.AvatarGeneratorService {
  MockAvatarGeneratorService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String generateAvatar() => (super.noSuchMethod(
        Invocation.method(
          #generateAvatar,
          [],
        ),
        returnValue: _i8.dummyValue<String>(
          this,
          Invocation.method(
            #generateAvatar,
            [],
          ),
        ),
      ) as String);
}

/// A class which mocks [AvatarRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockAvatarRepository extends _i1.Mock implements _i9.AvatarRepository {
  MockAvatarRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Future<_i3.Avatar> saveAvatar(
    String? id,
    _i10.ImageData? imageData,
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
  _i5.Future<_i10.ImageData?> getAvatarImage(String? avatarId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAvatarImage,
          [avatarId],
        ),
        returnValue: _i5.Future<_i10.ImageData?>.value(),
      ) as _i5.Future<_i10.ImageData?>);

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
