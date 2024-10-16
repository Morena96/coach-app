import 'package:domain/features/athletes/entities/group_role.dart';
import 'package:domain/features/athletes/entities/member.dart';
import 'package:domain/features/athletes/repositories/members.dart';
import 'package:domain/features/shared/utilities/result.dart';

class UpdateMemberRoleUseCase {
  final Members _membersRepository;

  UpdateMemberRoleUseCase(this._membersRepository);

  Future<Result<Member>> execute(String memberId, GroupRole newRole) async {
    return _membersRepository.updateMemberRole(memberId, newRole);
  }
}