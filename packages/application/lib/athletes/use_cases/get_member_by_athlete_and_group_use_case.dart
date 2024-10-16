import 'package:domain/features/athletes/entities/member.dart';
import 'package:domain/features/athletes/repositories/members.dart';
import 'package:domain/features/shared/utilities/result.dart';

class GetMemberByAthleteAndGroupUseCase {
  final Members _membersRepository;

  GetMemberByAthleteAndGroupUseCase(this._membersRepository);

  Future<Result<Member?>> execute(String athleteId, String groupId) async {
    return _membersRepository.getMemberByAthleteAndGroup(athleteId, groupId);
  }
}