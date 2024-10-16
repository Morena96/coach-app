// Mocks generated by Mockito 5.4.4 from annotations
// in application/test/athletes/application/use_cases/get_members_for_group_paginated_use_case_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:domain/features/athletes/entities/athlete.dart' as _i8;
import 'package:domain/features/athletes/entities/group_role.dart' as _i6;
import 'package:domain/features/athletes/entities/member.dart' as _i5;
import 'package:domain/features/athletes/repositories/athletes.dart' as _i7;
import 'package:domain/features/athletes/repositories/members.dart' as _i3;
import 'package:domain/features/athletes/value_objects/athlete_filter_criteria.dart'
    as _i10;
import 'package:domain/features/athletes/value_objects/athlete_sort_criteria.dart'
    as _i11;
import 'package:domain/features/shared/utilities/result.dart' as _i2;
import 'package:domain/features/shared/value_objects/filter_criteria.dart'
    as _i9;
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

/// A class which mocks [Members].
///
/// See the documentation for Mockito's code generation for more information.
class MockMembers extends _i1.Mock implements _i3.Members {
  MockMembers() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Result<List<_i5.Member>>> getMembersForGroup(
          String? groupId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getMembersForGroup,
          [groupId],
        ),
        returnValue: _i4.Future<_i2.Result<List<_i5.Member>>>.value(
            _FakeResult_0<List<_i5.Member>>(
          this,
          Invocation.method(
            #getMembersForGroup,
            [groupId],
          ),
        )),
      ) as _i4.Future<_i2.Result<List<_i5.Member>>>);

  @override
  _i4.Future<_i2.Result<_i5.Member?>> getMemberByAthleteAndGroup(
    String? athleteId,
    String? groupId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #getMemberByAthleteAndGroup,
          [
            athleteId,
            groupId,
          ],
        ),
        returnValue: _i4.Future<_i2.Result<_i5.Member?>>.value(
            _FakeResult_0<_i5.Member?>(
          this,
          Invocation.method(
            #getMemberByAthleteAndGroup,
            [
              athleteId,
              groupId,
            ],
          ),
        )),
      ) as _i4.Future<_i2.Result<_i5.Member?>>);

  @override
  _i4.Future<_i2.Result<_i5.Member>> addMemberToGroup(
    String? athleteId,
    String? groupId,
    _i6.GroupRole? role,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #addMemberToGroup,
          [
            athleteId,
            groupId,
            role,
          ],
        ),
        returnValue:
            _i4.Future<_i2.Result<_i5.Member>>.value(_FakeResult_0<_i5.Member>(
          this,
          Invocation.method(
            #addMemberToGroup,
            [
              athleteId,
              groupId,
              role,
            ],
          ),
        )),
      ) as _i4.Future<_i2.Result<_i5.Member>>);

  @override
  _i4.Future<_i2.Result<_i5.Member>> updateMemberRole(
    String? memberId,
    _i6.GroupRole? newRole,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateMemberRole,
          [
            memberId,
            newRole,
          ],
        ),
        returnValue:
            _i4.Future<_i2.Result<_i5.Member>>.value(_FakeResult_0<_i5.Member>(
          this,
          Invocation.method(
            #updateMemberRole,
            [
              memberId,
              newRole,
            ],
          ),
        )),
      ) as _i4.Future<_i2.Result<_i5.Member>>);

  @override
  _i4.Future<_i2.Result<void>> removeMemberFromGroup(
    String? groupId,
    String? memberIds,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #removeMemberFromGroup,
          [
            groupId,
            memberIds,
          ],
        ),
        returnValue: _i4.Future<_i2.Result<void>>.value(_FakeResult_0<void>(
          this,
          Invocation.method(
            #removeMemberFromGroup,
            [
              groupId,
              memberIds,
            ],
          ),
        )),
      ) as _i4.Future<_i2.Result<void>>);

  @override
  _i4.Future<_i2.Result<List<_i5.Member>>> getGroupsForAthlete(
          String? athleteId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getGroupsForAthlete,
          [athleteId],
        ),
        returnValue: _i4.Future<_i2.Result<List<_i5.Member>>>.value(
            _FakeResult_0<List<_i5.Member>>(
          this,
          Invocation.method(
            #getGroupsForAthlete,
            [athleteId],
          ),
        )),
      ) as _i4.Future<_i2.Result<List<_i5.Member>>>);

  @override
  _i4.Future<_i2.Result<bool>> isAthleteMemberOfGroup(
    String? athleteId,
    String? groupId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #isAthleteMemberOfGroup,
          [
            athleteId,
            groupId,
          ],
        ),
        returnValue: _i4.Future<_i2.Result<bool>>.value(_FakeResult_0<bool>(
          this,
          Invocation.method(
            #isAthleteMemberOfGroup,
            [
              athleteId,
              groupId,
            ],
          ),
        )),
      ) as _i4.Future<_i2.Result<bool>>);

  @override
  _i4.Future<_i2.Result<int>> getMemberCountForGroup(String? groupId) =>
      (super.noSuchMethod(
        Invocation.method(
          #getMemberCountForGroup,
          [groupId],
        ),
        returnValue: _i4.Future<_i2.Result<int>>.value(_FakeResult_0<int>(
          this,
          Invocation.method(
            #getMemberCountForGroup,
            [groupId],
          ),
        )),
      ) as _i4.Future<_i2.Result<int>>);

  @override
  _i4.Future<_i2.Result<List<_i5.Member>>> getMembersForGroupPaginated(
    String? groupId,
    int? page,
    int? pageSize,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #getMembersForGroupPaginated,
          [
            groupId,
            page,
            pageSize,
          ],
        ),
        returnValue: _i4.Future<_i2.Result<List<_i5.Member>>>.value(
            _FakeResult_0<List<_i5.Member>>(
          this,
          Invocation.method(
            #getMembersForGroupPaginated,
            [
              groupId,
              page,
              pageSize,
            ],
          ),
        )),
      ) as _i4.Future<_i2.Result<List<_i5.Member>>>);

  @override
  _i4.Future<_i2.Result<List<_i5.Member>>> searchMembersInGroup(
    String? groupId,
    String? searchTerm,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #searchMembersInGroup,
          [
            groupId,
            searchTerm,
          ],
        ),
        returnValue: _i4.Future<_i2.Result<List<_i5.Member>>>.value(
            _FakeResult_0<List<_i5.Member>>(
          this,
          Invocation.method(
            #searchMembersInGroup,
            [
              groupId,
              searchTerm,
            ],
          ),
        )),
      ) as _i4.Future<_i2.Result<List<_i5.Member>>>);

  @override
  _i4.Future<_i2.Result<List<_i5.Member>>> batchAddMembersToGroup(
    String? groupId,
    List<String>? athleteIds,
    _i6.GroupRole? role,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #batchAddMembersToGroup,
          [
            groupId,
            athleteIds,
            role,
          ],
        ),
        returnValue: _i4.Future<_i2.Result<List<_i5.Member>>>.value(
            _FakeResult_0<List<_i5.Member>>(
          this,
          Invocation.method(
            #batchAddMembersToGroup,
            [
              groupId,
              athleteIds,
              role,
            ],
          ),
        )),
      ) as _i4.Future<_i2.Result<List<_i5.Member>>>);

  @override
  _i4.Future<_i2.Result<void>> batchRemoveMembersFromGroup(
    String? groupId,
    List<String>? memberIds,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #batchRemoveMembersFromGroup,
          [
            groupId,
            memberIds,
          ],
        ),
        returnValue: _i4.Future<_i2.Result<void>>.value(_FakeResult_0<void>(
          this,
          Invocation.method(
            #batchRemoveMembersFromGroup,
            [
              groupId,
              memberIds,
            ],
          ),
        )),
      ) as _i4.Future<_i2.Result<void>>);

  @override
  _i4.Future<_i2.Result<Map<String, bool>>> areAthletesMembersOfGroup(
    List<String>? athleteIds,
    String? groupId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #areAthletesMembersOfGroup,
          [
            athleteIds,
            groupId,
          ],
        ),
        returnValue: _i4.Future<_i2.Result<Map<String, bool>>>.value(
            _FakeResult_0<Map<String, bool>>(
          this,
          Invocation.method(
            #areAthletesMembersOfGroup,
            [
              athleteIds,
              groupId,
            ],
          ),
        )),
      ) as _i4.Future<_i2.Result<Map<String, bool>>>);
}

/// A class which mocks [Athletes].
///
/// See the documentation for Mockito's code generation for more information.
class MockAthletes extends _i1.Mock implements _i7.Athletes {
  MockAthletes() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.Result<List<_i8.Athlete>>> getAllAthletes() =>
      (super.noSuchMethod(
        Invocation.method(
          #getAllAthletes,
          [],
        ),
        returnValue: _i4.Future<_i2.Result<List<_i8.Athlete>>>.value(
            _FakeResult_0<List<_i8.Athlete>>(
          this,
          Invocation.method(
            #getAllAthletes,
            [],
          ),
        )),
      ) as _i4.Future<_i2.Result<List<_i8.Athlete>>>);

  @override
  _i4.Future<_i2.Result<List<_i8.Athlete>>> getAthletesByFilterCriteria(
          _i9.FilterCriteria? filterCriteria) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAthletesByFilterCriteria,
          [filterCriteria],
        ),
        returnValue: _i4.Future<_i2.Result<List<_i8.Athlete>>>.value(
            _FakeResult_0<List<_i8.Athlete>>(
          this,
          Invocation.method(
            #getAthletesByFilterCriteria,
            [filterCriteria],
          ),
        )),
      ) as _i4.Future<_i2.Result<List<_i8.Athlete>>>);

  @override
  _i4.Future<_i2.Result<List<_i8.Athlete>>> getAthletesByPage(
    int? page,
    int? pageSize, {
    _i10.AthleteFilterCriteria? filterCriteria,
    _i11.AthleteSortCriteria? sortCriteria,
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
        returnValue: _i4.Future<_i2.Result<List<_i8.Athlete>>>.value(
            _FakeResult_0<List<_i8.Athlete>>(
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
      ) as _i4.Future<_i2.Result<List<_i8.Athlete>>>);

  @override
  _i4.Future<_i2.Result<_i8.Athlete>> getAthleteById(String? id) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAthleteById,
          [id],
        ),
        returnValue: _i4.Future<_i2.Result<_i8.Athlete>>.value(
            _FakeResult_0<_i8.Athlete>(
          this,
          Invocation.method(
            #getAthleteById,
            [id],
          ),
        )),
      ) as _i4.Future<_i2.Result<_i8.Athlete>>);

  @override
  _i4.Future<_i2.Result<_i8.Athlete>> addAthlete(_i8.Athlete? athlete) =>
      (super.noSuchMethod(
        Invocation.method(
          #addAthlete,
          [athlete],
        ),
        returnValue: _i4.Future<_i2.Result<_i8.Athlete>>.value(
            _FakeResult_0<_i8.Athlete>(
          this,
          Invocation.method(
            #addAthlete,
            [athlete],
          ),
        )),
      ) as _i4.Future<_i2.Result<_i8.Athlete>>);

  @override
  _i4.Future<_i2.Result<void>> updateAthlete(_i8.Athlete? athlete) =>
      (super.noSuchMethod(
        Invocation.method(
          #updateAthlete,
          [athlete],
        ),
        returnValue: _i4.Future<_i2.Result<void>>.value(_FakeResult_0<void>(
          this,
          Invocation.method(
            #updateAthlete,
            [athlete],
          ),
        )),
      ) as _i4.Future<_i2.Result<void>>);

  @override
  _i4.Future<_i2.Result<void>> deleteAthlete(String? id) => (super.noSuchMethod(
        Invocation.method(
          #deleteAthlete,
          [id],
        ),
        returnValue: _i4.Future<_i2.Result<void>>.value(_FakeResult_0<void>(
          this,
          Invocation.method(
            #deleteAthlete,
            [id],
          ),
        )),
      ) as _i4.Future<_i2.Result<void>>);

  @override
  _i4.Future<_i2.Result<List<_i8.Athlete>>> getAthletesByIds(
          List<String>? ids) =>
      (super.noSuchMethod(
        Invocation.method(
          #getAthletesByIds,
          [ids],
        ),
        returnValue: _i4.Future<_i2.Result<List<_i8.Athlete>>>.value(
            _FakeResult_0<List<_i8.Athlete>>(
          this,
          Invocation.method(
            #getAthletesByIds,
            [ids],
          ),
        )),
      ) as _i4.Future<_i2.Result<List<_i8.Athlete>>>);

  @override
  _i4.Future<_i2.Result<void>> restoreAthlete(String? id) =>
      (super.noSuchMethod(
        Invocation.method(
          #restoreAthlete,
          [id],
        ),
        returnValue: _i4.Future<_i2.Result<void>>.value(_FakeResult_0<void>(
          this,
          Invocation.method(
            #restoreAthlete,
            [id],
          ),
        )),
      ) as _i4.Future<_i2.Result<void>>);
}