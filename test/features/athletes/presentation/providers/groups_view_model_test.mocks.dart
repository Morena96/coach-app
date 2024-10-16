// Mocks generated by Mockito 5.4.4 from annotations
// in coach_app/test/features/athletes/presentation/providers/groups_view_model_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:application/athletes/use_cases/create_group_use_case.dart'
    as _i11;
import 'package:application/athletes/use_cases/delete_group_use_case.dart'
    as _i8;
import 'package:application/athletes/use_cases/get_all_groups_by_page_use_case.dart'
    as _i4;
import 'package:application/athletes/use_cases/get_group_use_case.dart' as _i10;
import 'package:application/athletes/use_cases/restore_group_use_case.dart'
    as _i9;
import 'package:application/athletes/use_cases/update_group_use_case.dart'
    as _i14;
import 'package:domain/features/athletes/entities/group.dart' as _i6;
import 'package:domain/features/athletes/entities/sport.dart' as _i12;
import 'package:domain/features/athletes/repositories/groups.dart' as _i3;
import 'package:domain/features/athletes/value_objects/groups_filter_criteria.dart'
    as _i7;
import 'package:domain/features/avatars/entities/image_data.dart' as _i13;
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

class _FakeGroups_1 extends _i1.SmartFake implements _i3.Groups {
  _FakeGroups_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [GetAllGroupsByPageUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetAllGroupsByPageUseCase extends _i1.Mock
    implements _i4.GetAllGroupsByPageUseCase {
  MockGetAllGroupsByPageUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Future<_i2.Result<List<_i6.Group>>> execute(
    int? page,
    int? pageSize, {
    _i7.GroupsFilterCriteria? filterCriteria,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #execute,
          [
            page,
            pageSize,
          ],
          {#filterCriteria: filterCriteria},
        ),
        returnValue: _i5.Future<_i2.Result<List<_i6.Group>>>.value(
            _FakeResult_0<List<_i6.Group>>(
          this,
          Invocation.method(
            #execute,
            [
              page,
              pageSize,
            ],
            {#filterCriteria: filterCriteria},
          ),
        )),
      ) as _i5.Future<_i2.Result<List<_i6.Group>>>);
}

/// A class which mocks [DeleteGroupUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockDeleteGroupUseCase extends _i1.Mock
    implements _i8.DeleteGroupUseCase {
  MockDeleteGroupUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Groups get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeGroups_1(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i3.Groups);

  @override
  _i5.Future<_i2.Result<void>> execute(String? groupId) => (super.noSuchMethod(
        Invocation.method(
          #execute,
          [groupId],
        ),
        returnValue: _i5.Future<_i2.Result<void>>.value(_FakeResult_0<void>(
          this,
          Invocation.method(
            #execute,
            [groupId],
          ),
        )),
      ) as _i5.Future<_i2.Result<void>>);
}

/// A class which mocks [RestoreGroupUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockRestoreGroupUseCase extends _i1.Mock
    implements _i9.RestoreGroupUseCase {
  MockRestoreGroupUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Groups get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeGroups_1(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i3.Groups);

  @override
  _i5.Future<_i2.Result<void>> execute(String? groupId) => (super.noSuchMethod(
        Invocation.method(
          #execute,
          [groupId],
        ),
        returnValue: _i5.Future<_i2.Result<void>>.value(_FakeResult_0<void>(
          this,
          Invocation.method(
            #execute,
            [groupId],
          ),
        )),
      ) as _i5.Future<_i2.Result<void>>);
}

/// A class which mocks [GetGroupByIdUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetGroupByIdUseCase extends _i1.Mock
    implements _i10.GetGroupByIdUseCase {
  MockGetGroupByIdUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Groups get repository => (super.noSuchMethod(
        Invocation.getter(#repository),
        returnValue: _FakeGroups_1(
          this,
          Invocation.getter(#repository),
        ),
      ) as _i3.Groups);

  @override
  _i5.Future<_i2.Result<_i6.Group>> execute(String? groupId) =>
      (super.noSuchMethod(
        Invocation.method(
          #execute,
          [groupId],
        ),
        returnValue:
            _i5.Future<_i2.Result<_i6.Group>>.value(_FakeResult_0<_i6.Group>(
          this,
          Invocation.method(
            #execute,
            [groupId],
          ),
        )),
      ) as _i5.Future<_i2.Result<_i6.Group>>);
}

/// A class which mocks [CreateGroupUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockCreateGroupUseCase extends _i1.Mock
    implements _i11.CreateGroupUseCase {
  MockCreateGroupUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Future<_i2.Result<_i6.Group>> execute(
    Map<String, dynamic>? groupData,
    String? name,
    String? description,
    _i12.Sport? sport, {
    _i13.ImageData? avatarImage,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #execute,
          [
            groupData,
            name,
            description,
            sport,
          ],
          {#avatarImage: avatarImage},
        ),
        returnValue:
            _i5.Future<_i2.Result<_i6.Group>>.value(_FakeResult_0<_i6.Group>(
          this,
          Invocation.method(
            #execute,
            [
              groupData,
              name,
              description,
              sport,
            ],
            {#avatarImage: avatarImage},
          ),
        )),
      ) as _i5.Future<_i2.Result<_i6.Group>>);
}

/// A class which mocks [UpdateGroupUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockUpdateGroupUseCase extends _i1.Mock
    implements _i14.UpdateGroupUseCase {
  MockUpdateGroupUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Future<_i2.Result<void>> execute(
    _i6.Group? group,
    Map<String, dynamic>? groupData,
    _i13.ImageData? avatar,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #execute,
          [
            group,
            groupData,
            avatar,
          ],
        ),
        returnValue: _i5.Future<_i2.Result<void>>.value(_FakeResult_0<void>(
          this,
          Invocation.method(
            #execute,
            [
              group,
              groupData,
              avatar,
            ],
          ),
        )),
      ) as _i5.Future<_i2.Result<void>>);
}
