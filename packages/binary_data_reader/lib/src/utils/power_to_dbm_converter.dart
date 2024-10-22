class PowerToDbmConverter {
  static const Map<int, int> _powerToDbm = {
    0xD8: -40,
    0xEC: -20,
    0xF4: -16,
    0xF8: -12,
    0xFC: -4,
    0x00: 0,
    0x02: 2,
    0x03: 3,
    0x04: 4,
    0x05: 5,
    0x06: 6,
    0x07: 7,
    0x08: 8,
  };

  static int toDbm(int powerValue) {
    final int? value = _powerToDbm[powerValue];

    if (value == null) {
      throw ArgumentError("Invalid power value: $powerValue");
    }

    return value;
  }

  static int fromDbm(int dbmValue) {
    final MapEntry<int, int> value = _powerToDbm.entries.firstWhere(
        (entry) => entry.value == dbmValue,
        orElse: () => throw ArgumentError("Invalid dBm value: $dbmValue"));

    return value.key;
  }
}
