import 'package:domain/features/pods/entities/pod.dart';
import 'package:hive/hive.dart';

part 'hive_pod.g.dart';

@HiveType(typeId: 1) // Make sure this typeId is unique across your Hive types
class HivePod extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  int number;

  @HiveField(2)
  String? athleteId;

  @HiveField(3)
  int rfSlot;

  HivePod({
    required this.id,
    required this.number,
    this.athleteId,
    required this.rfSlot,
  });

  Pod toDomain() {
    return Pod(
      id: id,
      number: number,
      athleteId: athleteId,
      rfSlot: rfSlot,
    );
  }

  factory HivePod.fromDomain(Pod pod) {
    return HivePod(
      id: pod.id,
      number: pod.number,
      athleteId: pod.athleteId,
      rfSlot: pod.rfSlot,
    );
  }
}
