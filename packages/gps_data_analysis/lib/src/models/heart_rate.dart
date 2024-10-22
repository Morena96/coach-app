/// A class representing heart rate values including average, minimum, and maximum heart rates.
class HeartRate {
  final double average;
  final double min;
  final double max;

  /// Average heart rate as a percentage of the maximum heart rate
  final double averagePercentage;

  const HeartRate({
    required this.average,
    required this.min,
    required this.max,
    required this.averagePercentage,
  });

  factory HeartRate.empty() => const HeartRate(average: 0, min: double.infinity, max: 0, averagePercentage: 0);

  @override
  String toString() {
    return 'HeartRate(average: $average, min: $min, max: $max, averagePercentage: $averagePercentage)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! HeartRate) return false;
    return other.average == average && other.min == min && other.max == max && other.averagePercentage == averagePercentage;
  }

  @override
  int get hashCode {
    return Object.hash(average, min, max, averagePercentage);
  }
}
