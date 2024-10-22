enum RfMode {
  lr125Kbit,
  lr500Kbit,
  lr1Mbit,
  lr2Mbit;

  int toInt() {
    switch (this) {
      case RfMode.lr125Kbit:
        return 0x05;
      case RfMode.lr500Kbit:
        return 0x06;
      case RfMode.lr1Mbit:
        return 0x03;
      case RfMode.lr2Mbit:
        return 0x04;
    }
  }

  factory RfMode.fromInt(int value) {
    switch (value) {
      case 0x05:
        return RfMode.lr125Kbit;
      case 0x06:
        return RfMode.lr500Kbit;
      case 0x03:
        return RfMode.lr1Mbit;
      case 0x04:
        return RfMode.lr2Mbit;
      default:
        throw ArgumentError('Invalid value for RfMode: $value');
    }
  }
}
