import 'dart:math' as math;

List<double> processLongitudeData(List<int> data, double firstLongitudeValue) {
  List<double> fullLongitudeValues = List.filled(10, 0);
  List<int> longitudeDiffs = List.filled(9, 0);
  int ix = 0;

  fullLongitudeValues[0] = firstLongitudeValue;

  longitudeDiffs[0] = (data[ix + 1] & 0x0F) << 6 | (data[ix] >> 2) & 0x3F;
  longitudeDiffs[1] = (data[ix + 2] & 0x3F) << 4 | (data[ix + 1] >> 4) & 0x0F;
  longitudeDiffs[2] = (data[ix + 3] & 0xFF) << 2 | (data[ix + 2] >> 6) & 0x03;
  longitudeDiffs[3] = (data[ix + 5] & 0x03) << 8 | (data[ix + 4]) & 0xFF;
  longitudeDiffs[4] = (data[ix + 6] & 0x0F) << 6 | (data[ix + 5] >> 2) & 0x3F;
  longitudeDiffs[5] = (data[ix + 7] & 0x3F) << 4 | (data[ix + 6] >> 4) & 0x0F;
  longitudeDiffs[6] = (data[ix + 8] & 0xFF) << 2 | (data[ix + 7] >> 6) & 0x03;
  longitudeDiffs[7] = (data[ix + 10] & 0x03) << 8 | (data[ix + 9]) & 0xFF;
  longitudeDiffs[8] = (data[ix + 11] & 0x0F) << 6 | (data[ix + 10] >> 2) & 0x3F;

  // longitudeDiffs.forEach((diff) {
  //   print(diff.toRadixString(16));
  // });

  // process to longitudeDiffs to return fullLongitudeValues
  for (int i = 0; i < 9; i++) {
    // if the value is 0x3FF, then the value is 0
    if (longitudeDiffs[i] == 0x3FF) {
      fullLongitudeValues[i + 1] = math.pow(10, -7) as double;
    } else {
      // Mask the sign bit
      if (((longitudeDiffs[i] >> 9) & 0x01) == 1) {
        fullLongitudeValues[i + 1] = fullLongitudeValues[i] -
            (((longitudeDiffs[i] & 0x1FF) * 2) * math.pow(10, -7));
      } else {
        fullLongitudeValues[i + 1] = fullLongitudeValues[i] +
            (((longitudeDiffs[i] & 0x1FF) * 2) * math.pow(10, -7));
      }
    }
  }

  return fullLongitudeValues.toList();
}
