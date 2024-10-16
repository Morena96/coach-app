class CalibrationResult {
  final Map<int, List<int>> rssiMap;

  CalibrationResult(Map<int, List<int>> rssiMap)
      : rssiMap = rssiMap.map((key, value) => MapEntry(key, List<int>.from(value)));
}