# GPS Data Processing Framework

This framework provides a set of tools for processing streams of GPS data and performing various calculations on them. It is built around two core abstract classes, `Calculator` and `GPSDataProcessor<T, U>`, which can be extended to create custom processing and calculation functionalities.

## Getting Started

To use this framework, you'll need to extend the abstract classes provided by the package to implement your custom processing logic.

### Prerequisites

Ensure you have Dart installed on your system. This package is compatible with Dart 2.x.

### Installation

Add the package to your project's `pubspec.yaml` file:


## Usage

### Processors

A `GPSDataProcessor` is a class that processes a stream of GPS data. It is parameterized by the type of the input data and the type of the output data. To create a custom processor, extend the `GPSDataProcessor` class and implement the `process` method:

```dart
class SpeedFilterProcessor extends GPSDataProcessor<GPSData, GPSData> {
  final double speedThreshold;

  SpeedFilterProcessor(this.speedThreshold);

  @override
  Stream<GPSData> process(Stream<GPSData> inputStream) {
    return inputStream.where((data) => data.speed >= speedThreshold);
  }
}
```

### Calculators
A `Calculator` is a class that performs a calculation on a stream of GPS data. To create a custom calculator, extend the `Calculator` class and implement the `calculate` method:

```dart
class AverageSpeedCalculator extends Calculator {
  @override
  Stream<double> calculate(Stream<GPSData> gpsDataStream) {
    return gpsDataStream
        .map((data) => data.speed)
        .reduce((a, b) => a + b)
        .asStream()
        .map((sum) => sum / gpsDataStream.length);
  }
}
```

### Built In Processors

#### Velocity Smoothing
- KalmanSmoothingProcessor
- MovingAverageSmoothingProcessor

#### Acceleration
- AddAccelerationFromVelocityDerivativeProcessor
- AddAccelerationProcessor
- MedianFilterProcessor

####
- AddDistanceToStreamProcessorUsingTrapezoid

#### 
- SignalQualityIndicator

### Built-In Calculators

- MaxVelocityCalculator
- InstantaneousVelocityCalculator
- MaxAccelerationCalculator
- MaxVelocityCalculator
- PeriodAccelerationCalculator
- PlayerLoadCalculator
- SessionDurationCalculator
- TimeInSpeedZonesCalculator
- HeartRateCalculator

### CLI
The provided library comes with a command line tool to process csv data files and run them through various calculators
and processors. The tool can be run using the following command:

```bash
dart cli.dart  -p ./csv/2seconds.csv -t AddAccelerationProcessor,AddAccelerationFromDerivativeProcessor -c MaxAccelerationCalculator -v
```


## Contributing
- PRs are welcome
- Your branch should be named `trello-ticket-slug`