import 'package:domain/features/athletes/entities/group_role.dart';
import 'package:flutter/material.dart';

import 'package:coach_app/l10n.dart';

enum GroupRoleView {
  coach,
  athlete,
  trainer,
  familyMember,
  other,
}

extension GroupRoleViewX on GroupRoleView {
  String title(BuildContext context) {
    switch (this) {
      case GroupRoleView.athlete:
        return context.l10n.athlete;
      case GroupRoleView.coach:
        return context.l10n.coach;
      case GroupRoleView.trainer:
        return context.l10n.trainer;
      case GroupRoleView.familyMember:
        return context.l10n.familyMember;
      case GroupRoleView.other:
        return context.l10n.other;
    }
  }
}

GroupRoleView groupRoleViewFromDomain(GroupRole groupRole) {
  switch (groupRole) {
    case GroupRole.athlete:
      return GroupRoleView.athlete;
    case GroupRole.coach:
      return GroupRoleView.coach;
    case GroupRole.trainer:
      return GroupRoleView.trainer;
    case GroupRole.familyMember:
      return GroupRoleView.familyMember;
    case GroupRole.other:
      return GroupRoleView.other;
  }
}

GroupRole groupRoleFromView(GroupRoleView groupRole) {
  switch (groupRole) {
    case GroupRoleView.athlete:
      return GroupRole.athlete;
    case GroupRoleView.coach:
      return GroupRole.coach;
    case GroupRoleView.trainer:
      return GroupRole.trainer;
    case GroupRoleView.familyMember:
      return GroupRole.familyMember;
    case GroupRoleView.other:
      return GroupRole.other;
  }
}
