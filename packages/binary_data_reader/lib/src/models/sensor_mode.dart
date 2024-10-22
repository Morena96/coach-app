enum SensorMode {
  standBy,
  live,
  order,
  transport,
  download,

  unused; // Placeholder for unused slots

  // Helper methods to convert enum to corresponding command value
  int get value {
    switch (this) {
      case standBy:
        return 0x00;
      case live:
        return 0x01;
      case order:
        return 0x02;
      case transport:
        return 0x03;
      case download:
        return 0x04;
      default:
        return 0xFF; // Indicate unused or invalid
    }
  }

  // Convert from command value to enum
  static SensorMode fromValue(int value) {
    switch (value) {
      case 0x00:
        return SensorMode.standBy;
      case 0x01:
        return SensorMode.live;
      case 0x02:
        return SensorMode.order;
      case 0x03:
        return SensorMode.transport;
      case 0x04:
        return SensorMode.download;
      default:
        return SensorMode.unused;
    }
  }
}
