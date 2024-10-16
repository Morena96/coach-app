import 'package:domain/features/athletes/entities/group_role.dart';
import 'package:flutter/material.dart';

import 'package:coach_app/l10n.dart';

extension GroupRoleX on GroupRole {
  String title(BuildContext context) {
    switch (this) {
      case GroupRole.athlete:
        return context.l10n.athlete;
      case GroupRole.coach:
        return context.l10n.coach;
      case GroupRole.familyMember:
        return context.l10n.familyMember;
      case GroupRole.trainer:
        return context.l10n.trainer;
      case GroupRole.other:
        return context.l10n.other;
    }
  }
}
