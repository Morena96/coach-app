// Mocks generated by Mockito 5.4.4 from annotations
// in application/test/athletes/application/use_cases/update_group_use_case_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i7;

import 'package:domain/features/athletes/entities/group.dart' as _i8;
import 'package:domain/features/athletes/entities/group_role.dart' as _i11;
import 'package:domain/features/athletes/entities/sport.dart' as _i10;
import 'package:domain/features/athletes/repositories/groups.dart' as _i6;
import 'package:domain/features/athletes/services/group_validation_service.dart'
    as _i12;
import 'package:domain/features/athletes/services/validation_library.dart'
    as _i3;
import 'package:domain/features/athletes/value_objects/groups_filter_criteria.dart'
    as _i9;
import 'package:domain/features/avatars/entities/avatar.dart' as _i5;
import 'package:domain/features/avatars/entities/image_data.dart' as _i14;
import 'package:domain/features/avatars/repositories/avatar_repository.dart'
    as _i13;
import 'package:domain/features/shared/utilities/result.dart' as _i2;
import 'package:domain/features/shared/utilities/validation/validation_result.dart'
    as _i4;
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

class _FakeValidationLibrary_1 extends _i1.SmartFake
    implements _i3.ValidationLibrary {
  _FakeValidationLibrary_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeValidationResult_2 extends _i1.SmartFake
    implements _i4.ValidationResult {
  _FakeValidationResult_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeAvatar_3 extends _i1.SmartFake implements _i5.Avatar {
  _FakeAvatar_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [Groups].
///
/// See the documentation for Mockito's code generation for more information.
class MockGroups extends _i1.Mock implements _i6.Groups {
  MockGroups() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.Future<_i2.Result<List<_i8.Group>>> getAllGroups() => (super.noSuchMethod(
        Invocation.method(
          #getAllGroups,
          [],
        ),
        returnValue: _i7.Future<_i2.Result<List<_i8.Group>>>.value(
            _FakeResult_0<List<_i8.Group>>(
          this,
          Invocation.method(
            #getAllGroups,
            [],
          ),
        )),
      ) as _i7.Future<_i2.Result<List<_i8.Group>>>);

  @override
  _i7.Future<_i2.Result<List<_i8.Group>>> getGroupsByPage(
    int? page,
    int? pageSize, {
    _i9.GroupsFilterCriteria? filterCriteria,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #getGroupsByPage,
          [
            page,
            pageSize,
          ],
          {#filterCriteria: filterCriteria},
        ),
        returnValue: _i7.Future<_i2.Result<List<_i8.Group>>>.value(
            _FakeResult_0<List<_i8.Group>>(
          this,
          Invocation.method(
            #getGroupsByPage,
            [
              page,
              pageSize,
            ],
            {#filterCriteria: filterCriteria},
          ),
        )),
      ) as _i7.Future<_i2.Result<List<_i8.Group>>>);

  @override
  _i7.Future<_i2.Result<_i8.Group>> getGroupById(String? id) =>
      (super.noSuchMethod(
        Invocation.method(
          #getGroupById,
          [id],
        ),
        returnValue:
            _i7.Future<_i2.Result<_i8.Group>>.value(_FakeResult_0<_i8.Group>(
          this,
          Invocation.method(
            #getGroupById,
            [id],
          ),
        )),
      ) as _i7.Future<_i2.Result<_i8.Group>>);

  @override
  _i7.Future<_i2.Result<_i8.Group>> createGroup(
    String? name,
    String? description,
    _i10.Sport? sport,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #createGroup,
          [
            name,
            description,
            sport,
          ],
        ),
        returnValue:
            _i7.Future<_i2.Result<_i8.Group>>.value(_FakeResult_0<_i8.Group>(
          this,
          Invocation.method(
            #createGroup,
            [
              name,
              description,
              sport,
            ],
          ),
        )),
      ) as _i7.Future<_i2.Result<_i8.Group>>);

  @override
  _i7.Future<_i2.Result<_i8.Group>> updateGroup(_i8.Group? group) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateGroup,
          [group],
        ),
        returnValue:
            _i7.Future<_i2.Result<_i8.Group>>.value(_FakeResult_0<_i8.Group>(
          this,
          Invocation.method(
            #updateGroup,
            [group],
          ),
        )),
      ) as _i7.Future<_i2.Result<_i8.Group>>);

  @override
  _i7.Future<_i2.Result<void>> deleteGroup(String? id) => (super.noSuchMethod(
        Invocation.method(
          #deleteGroup,
          [id],
        ),
        returnValue: _i7.Future<_i2.Result<void>>.value(_FakeResult_0<void>(
          this,
          Invocation.method(
            #deleteGroup,
            [id],
          ),
        )),
      ) as _i7.Future<_i2.Result<void>>);

  @override
  _i7.Future<_i2.Result<void>> restoreGroup(String? id) => (super.noSuchMethod(
        Invocation.method(
          #restoreGroup,
          [id],
        ),
        returnValue: _i7.Future<_i2.Result<void>>.value(_FakeResult_0<void>(
          this,
          Invocation.method(
            #restoreGroup,
            [id],
          ),
        )),
      ) as _i7.Future<_i2.Result<void>>);

  @override
  _i7.Future<_i2.Result<List<_i11.GroupRole>>> getAllRoles() =>
      (super.noSuchMethod(
        Invocation.method(
          #getAllRoles,
          [],
        ),
        returnValue: _i7.Future<_i2.Result<List<_i11.GroupRole>>>.value(
            _FakeResult_0<List<_i11.GroupRole>>(
          this,
          Invocation.method(
            #getAllRoles,
            [],
          ),
        )),
      ) as _i7.Future<_i2.Result<List<_i11.GroupRole>>>);
}

/// A class which mocks [GroupValidationService].
///
/// See the documentation for Mockito's code generation for more information.
class MockGroupValidationService extends _i1.Mock
    implements _i12.GroupValidationService {
  MockGroupValidationService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.ValidationLibrary get validationLibrary => (super.noSuchMethod(
        Invocation.getter(#validationLibrary),
        returnValue: _FakeValidationLibrary_1(
          this,
          Invocation.getter(#validationLibrary),
        ),
      ) as _i3.ValidationLibrary);

  @override
  _i4.ValidationResult validateGroupData(Map<String, dynamic>? groupData) =>
      (super.noSuchMethod(
        Invocation.method(
          #validateGroupData,
          [groupData],
        ),
        returnValue: _FakeValidationResult_2(
          this,
          Invocation.method(
            #validateGroupData,
            [groupData],
          ),
        ),
      ) as _i4.ValidationResult);
}

/// A class which mocks [AvatarRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockAvatarRepository extends _i1.Mock implements _i13.AvatarRepository {
  MockAvatarRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.Future<_i5.Avatar> saveAvatar(
    String? id,
    _i14.ImageData? imageData,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #saveAvatar,
          [
            id,
            imageData,
          ],
        ),
        returnValue: _i7.Future<_i5.Avatar>.value(_FakeAvatar_3(
          this,
          Invocation.method(
            #saveAvatar,
            [
              id,
              imageData,
            ],
          ),
        )),
      ) as _i7.Future<_i5.Avatar>);

  @override
  _i7.Future<_i14.ImageData?> getAvatarImage(String? avatarId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAvatarImage,
          [avatarId],
        ),
        returnValue: _i7.Future<_i14.ImageData?>.value(),
      ) as _i7.Future<_i14.ImageData?>);

  @override
  _i7.Future<void> downloadAvatar(
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
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);

  @override
  _i7.Future<void> markAvatarAsSynced(_i5.Avatar? avatar) =>
      (super.noSuchMethod(
        Invocation.method(
          #markAvatarAsSynced,
          [avatar],
        ),
        returnValue: _i7.Future<void>.value(),
        returnValueForMissingStub: _i7.Future<void>.value(),
      ) as _i7.Future<void>);

  @override
  _i7.Future<_i5.Avatar> getAvatar(String? avatarId) => (super.noSuchMethod(
        Invocation.method(
          #getAvatar,
          [avatarId],
        ),
        returnValue: _i7.Future<_i5.Avatar>.value(_FakeAvatar_3(
          this,
          Invocation.method(
            #getAvatar,
            [avatarId],
          ),
        )),
      ) as _i7.Future<_i5.Avatar>);
}
