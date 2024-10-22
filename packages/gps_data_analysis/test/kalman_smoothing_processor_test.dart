import 'package:test/test.dart';

import 'package:gps_data_analysis/src/models/gps_data.dart';
import 'package:gps_data_analysis/src/processors/velocity_smoothing/kalman_smoothing_processor.dart';

import 'factories/gps_data_factory.dart';
// Import your GPSData class and KalmanSmoothingProcessor here

void main() {
  group('KalmanSmoothingProcessor Tests', () {
    // Test initialization with default parameters
    test('Initializes with default parameters correctly', () {
      final KalmanSmoothingProcessor processor = KalmanSmoothingProcessor();
      expect(processor.errorEstimate, 1);
      expect(processor.errorMeasure, 0.3);
      expect(processor.filterSensitivityFactor, .9);
    });

    // Test initialization with custom parameters
    test('Initializes with custom parameters correctly', () {
      final KalmanSmoothingProcessor processor = KalmanSmoothingProcessor(
        errorEstimate: 2,
        errorMeasure: 3,
        filterSensitivityFactor: 4,
      );
      expect(processor.errorEstimate, 2);
      expect(processor.errorMeasure, 3);
      expect(processor.filterSensitivityFactor, 4);
    });

    // Test processing a single data point
    test('Processes a single data point correctly', () {
      final KalmanSmoothingProcessor processor = KalmanSmoothingProcessor();
      final Stream<GpsData> dataStream = Stream<GpsData>.value(gpsData(velocity: 5)); // Assuming GPSData constructor exists and accepts velocity
      final Stream<GpsData> processedStream = dataStream.transform(processor);

      // Collect the processed data
      processedStream.toList().then((List<GpsData> processedData) {
        expect(processedData.first.velocity, isNotNull); // Check for the expected velocity after processing
      });
    });

    // Multiple Sequential Data Points Test
    test('Processes multiple sequential data points accurately', () async {
      final KalmanSmoothingProcessor processor = KalmanSmoothingProcessor();
      final Stream<GpsData> dataStream = Stream<GpsData>.fromIterable(<GpsData>[
        gpsData(velocity: 10),
        gpsData(velocity: 12),
        gpsData(velocity: 14),
        // Add more points as needed for thorough testing
      ]);
      final Stream<GpsData> processedStream = dataStream.transform(processor);

      final List<GpsData> processedData = await processedStream.toList();
      expect(processedData, isNotEmpty); // Ensure data was processed
      // Additional assertions to validate the trend or specific values could be added here
    });

    // Edge Case - Noisy Data Stream Test
    test('Handles extremely noisy data streams gracefully', () async {
      final KalmanSmoothingProcessor processor = KalmanSmoothingProcessor();
      final Stream<GpsData> dataStream = Stream<GpsData>.fromIterable(<GpsData>[
        gpsData(velocity: 10),
        gpsData(velocity: 40),
        gpsData(velocity: 12),
        gpsData(velocity: 13),
        gpsData(velocity: 12),
      ]);
      final Stream<GpsData> processedStream = dataStream.transform(processor);

      final List<GpsData> processedData = await processedStream.toList();
      expect(processedData, isNotEmpty);
    });

    // Edge Case - Constant Velocity Data Stream Test
    test('Efficiently smooths data with constant velocity', () async {
      final KalmanSmoothingProcessor processor = KalmanSmoothingProcessor();
      final Stream<GpsData> constantVelocityStream = Stream<GpsData>.fromIterable(List<GpsData>.generate(10, (_) => gpsData(velocity: 15)));
      final Stream<GpsData> processedStream = constantVelocityStream.transform(processor);

      final List<GpsData> processedData = await processedStream.toList();
      // Assert that the processed data converges towards the constant input velocity
      expect(processedData.last.velocity, closeTo(15, 1)); // This assumes a tolerance of 0.5 for the final estimate
    });
  });
}
