import 'package:domain/features/athletes/entities/member_with_athlete.dart';
import 'package:domain/features/athletes/repositories/athletes.dart';
import 'package:domain/features/athletes/repositories/members.dart';
import 'package:domain/features/shared/utilities/result.dart';

class GetMembersForGroupPaginatedUseCase {
  final Members _membersRepository;
  final Athletes _athletesRepository;

  GetMembersForGroupPaginatedUseCase(this._membersRepository, this._athletesRepository);

  Future<Result<List<MemberWithAthlete>>> execute(String groupId, int page, int pageSize) async {
    final membersResult = await _membersRepository.getMembersForGroupPaginated(groupId, page, pageSize);

    if (membersResult.isFailure) {
      return Result.failure(membersResult.error);
    }

    final members = membersResult.value!;

    if (members.isEmpty) {
      return Result.success([]);
    }

    final athleteIds = members.map((member) => member.athleteId).toList();
    final athletesResult = await _athletesRepository.getAthletesByIds(athleteIds);
    
    if (athletesResult.isFailure) {
      return Result.failure(athletesResult.error);
    }
    
    final athletes = athletesResult.value!;
    final athleteMap = Map.fromIterable(athletes, key: (athlete) => athlete.id);
    
    final membersWithAthletes = members.map((member) {
      final athlete = athleteMap[member.athleteId];
      if (athlete == null) {
        throw Exception('Failed to fetch athlete for member ${member.id}');
      }
      return MemberWithAthlete(member: member, athlete: athlete);
    }).toList();

    return Result.success(membersWithAthletes);
  }
}