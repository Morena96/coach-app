import 'dart:typed_data';

extension SpeedDiffCalculator on Uint8List {
  List<double> calculateSpeedDiffs() {
    if (this.length != 9) {
      throw ArgumentError('The list must contain exactly 9 elements.');
    }

    return List<double>.generate(9, (i) {
      int byteValue = this[i];
      byteValue &= 0xFF;
      bool isMSBOne = (byteValue & 0x80) != 0;
      if (isMSBOne) {
        // Remove the leftmost bit by performing a bitwise AND with 0x7F (0111 1111),
        // which clears the MSB, and then return the negative of the result.
        // result should be rounded to 3 decimal places.

        return ((byteValue & 0x7F) * -0.1);
      } else {
        // If the MSB is 0, return the byte as it is.
        return byteValue * 0.1;
      }
    });
  }
}