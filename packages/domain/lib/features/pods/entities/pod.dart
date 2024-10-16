class Pod {
  final String id;
  final int number;
  final String? athleteId;
  final int rfSlot;

  Pod({
    required this.id,
    required this.number,
    this.athleteId,
    required this.rfSlot
  });

  Pod copyWith({
    String? athleteId,
  }) {
    return Pod(
      id: id,
      number: number,
      athleteId: athleteId,
      rfSlot: rfSlot,
    );
  }
}