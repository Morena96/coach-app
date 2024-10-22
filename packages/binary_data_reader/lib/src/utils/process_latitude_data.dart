import 'dart:math' as math;

List<double> processLatitudeData(List<int> data, double firstLatitudeValue) {
  List<double> fullLatitudeValues = List.filled(10, 0);
  List<int> latitudeDiffs = List.filled(9, 0);

  fullLatitudeValues[0] = firstLatitudeValue; // 511 in decimal

  // Bitwise operations to fill in the latitudeDiffs array which is part
  // of the protocol for parsing gps data from our 10 bit packet for latitude
  latitudeDiffs[0] = ((data[1] & 0x03) << 8) | (data[0] & 0xFF);
  latitudeDiffs[1] = ((data[2] & 0x0F) << 6) | ((data[1] >> 2) & 0x3F);
  latitudeDiffs[2] = ((data[3] & 0x3F) << 4) | ((data[2] >> 4) & 0x0F);
  latitudeDiffs[3] = ((data[4] & 0xFF) << 2) | ((data[3] >> 6) & 0x03);

  latitudeDiffs[4] = ((data[6] & 0x03) << 8) | (data[5] & 0xFF);
  latitudeDiffs[5] = ((data[7] & 0x0F) << 6) | ((data[6] >> 2) & 0x3F);
  latitudeDiffs[6] = ((data[8] & 0x3F) << 4) | ((data[7] >> 4) & 0x0F);
  latitudeDiffs[7] = ((data[9] & 0xFF) << 2) | ((data[8] >> 6) & 0x03);

  latitudeDiffs[8] = ((data[11] & 0x03) << 8) | (data[10] & 0xFF);
  
  // latitudeDiffs.forEach((diff) {
  //   print(diff.toRadixString(16));
  // });

  for (int i = 0; i < 9; i++) {
    if (latitudeDiffs[i] == 0x3FF) {
      fullLatitudeValues[i + 1] = math.pow(10, -7) as double;
    } else {

      // Mask the sign bit
      if (((latitudeDiffs[i] >> 9) & 0x01) == 1) {
        fullLatitudeValues[i + 1] = fullLatitudeValues[i] -
            (((latitudeDiffs[i] & 0x1FF) * 2) * math.pow(10, -7));
      } else {
        fullLatitudeValues[i + 1] = fullLatitudeValues[i] +
            (((latitudeDiffs[i] & 0x1FF) * 2) * math.pow(10, -7));
      }
    }
  }


  return fullLatitudeValues.toList();
}
