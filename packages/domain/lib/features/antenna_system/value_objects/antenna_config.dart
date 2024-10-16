class AntennaConfig {
  int masterId;
  int frequency;
  int mainFrequency;
  bool isMain;
  int clubId;

  AntennaConfig(
      {required this.masterId,
      required this.frequency,
      required this.mainFrequency,
      required this.isMain,
      required this.clubId});
}
