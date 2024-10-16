import 'package:coach_app/features/athletes/presentation/models/group_role_view.dart';
import 'package:domain/features/athletes/entities/group_role.dart';
import 'package:domain/features/athletes/entities/member.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:coach_app/features/athletes/presentation/models/member_view.dart';

void main() {
  group('MemberView', () {
    test('should create a MemberView instance', () {
      const memberView = MemberView(
        id: '1',
        athleteId: 'athlete1',
        groupId: 'group1',
        role: GroupRoleView.athlete,
      );

      expect(memberView.id, '1');
      expect(memberView.athleteId, 'athlete1');
      expect(memberView.groupId, 'group1');
      expect(memberView.role, GroupRoleView.athlete);
    });

    test('should create MemberView from Member using fromDomain', () {
      const member = Member(
        id: '2',
        athleteId: 'athlete2',
        groupId: 'group2',
        role: GroupRole.trainer,
      );

      final memberView = MemberView.fromDomain(member);

      expect(memberView.id, member.id);
      expect(memberView.athleteId, member.athleteId);
      expect(memberView.groupId, member.groupId);
    });

    test('should be equal when all properties are the same', () {
      const memberView1 = MemberView(
        id: '3',
        athleteId: 'athlete3',
        groupId: 'group3',
        role: GroupRoleView.athlete,
      );

      const memberView2 = MemberView(
        id: '3',
        athleteId: 'athlete3',
        groupId: 'group3',
        role: GroupRoleView.athlete,
      );

      expect(memberView1, memberView2);
    });

    test('should not be equal when any property is different', () {
      const memberView1 = MemberView(
        id: '4',
        athleteId: 'athlete4',
        groupId: 'group4',
        role: GroupRoleView.athlete,
      );

      const memberView2 = MemberView(
        id: '4',
        athleteId: 'athlete4',
        groupId: 'group4',
        role: GroupRoleView.trainer,
      );

      expect(memberView1, isNot(memberView2));
    });

    test('props should contain all properties', () {
      const memberView = MemberView(
        id: '5',
        athleteId: 'athlete5',
        groupId: 'group5',
        role: GroupRoleView.athlete,
      );

      expect(memberView.props, [
        memberView.id,
        memberView.athleteId,
        memberView.groupId,
        memberView.role,
      ]);
    });
  });
}
