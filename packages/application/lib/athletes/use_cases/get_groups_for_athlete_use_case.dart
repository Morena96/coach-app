import 'package:domain/features/athletes/entities/member.dart';
import 'package:domain/features/athletes/repositories/members.dart';
import 'package:domain/features/shared/utilities/result.dart';

class GetGroupsForAthleteUseCase {
  final Members _membersRepository;

  GetGroupsForAthleteUseCase(this._membersRepository);

  Future<Result<List<Member>>> execute(String athleteId) async {
    return _membersRepository.getGroupsForAthlete(athleteId);
  }
}