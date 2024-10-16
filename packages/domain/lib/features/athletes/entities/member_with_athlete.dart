import 'package:domain/features/athletes/entities/athlete.dart';
import 'package:domain/features/athletes/entities/member.dart';

class MemberWithAthlete {
  final Member member;
  final Athlete athlete;

  MemberWithAthlete({required this.member, required this.athlete});
}