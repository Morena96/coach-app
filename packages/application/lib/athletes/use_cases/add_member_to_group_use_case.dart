import 'package:domain/features/athletes/entities/group_role.dart';
import 'package:domain/features/athletes/entities/member.dart';
import 'package:domain/features/athletes/repositories/members.dart';
import 'package:domain/features/shared/utilities/result.dart';

class AddMemberToGroupUseCase {
  final Members _membersRepository;

  AddMemberToGroupUseCase(this._membersRepository);

  Future<Result<Member>> execute(String athleteId, String groupId, GroupRole role) async {
    return _membersRepository.addMemberToGroup(athleteId, groupId, role);
  }
}