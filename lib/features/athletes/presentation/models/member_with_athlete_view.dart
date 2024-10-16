import 'package:domain/features/athletes/entities/member_with_athlete.dart';

import 'package:coach_app/features/athletes/presentation/models/athlete_view.dart';
import 'package:coach_app/features/athletes/presentation/models/member_view.dart';
import 'package:equatable/equatable.dart';

class MemberWithAthleteView extends Equatable {
  final MemberView member;
  final AthleteView athlete;

  const MemberWithAthleteView({required this.member, required this.athlete});

  factory MemberWithAthleteView.fromDomain(
      MemberWithAthlete memberWithAthlete) {
    return MemberWithAthleteView(
      member: MemberView.fromDomain(memberWithAthlete.member),
      athlete: AthleteView.fromDomain(memberWithAthlete.athlete),
    );
  }

  @override
  List<Object?> get props => [member, athlete];
}
