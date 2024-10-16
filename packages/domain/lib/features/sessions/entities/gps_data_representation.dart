
/// Represents a single GPS data representation stored on disk.
class GpsDataRepresentation {
  /// The path to the GPS data file on disk.
  final String filePath;

  /// The format of the GPS data (e.g., 'csv', 'binary').
  final String format;

  GpsDataRepresentation({
    required this.filePath,
    required this.format
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GpsDataRepresentation &&
          runtimeType == other.runtimeType &&
          filePath == other.filePath &&
          format == other.format;

  @override
  int get hashCode => filePath.hashCode ^ format.hashCode;

  @override
  String toString() {
    return 'GpsDataRepresentation{filePath: $filePath, format: $format}';
  }
}

