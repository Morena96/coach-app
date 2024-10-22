import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:rxdart/rxdart.dart';

import 'package:gps_data_analysis/src/calculators/calculator.dart';
import 'package:gps_data_analysis/src/calculators/collision_calculator.dart';
import 'package:gps_data_analysis/src/calculators/instantaneous_velocity_calculator.dart';
import 'package:gps_data_analysis/src/calculators/max_acceleration_calculator.dart';
import 'package:gps_data_analysis/src/calculators/max_velocity_calculator.dart';
import 'package:gps_data_analysis/src/calculators/period_acceleration_calculator.dart';
import 'package:gps_data_analysis/src/calculators/player_load_calculator.dart';
import 'package:gps_data_analysis/src/calculators/session_duration_calculator.dart';
import 'package:gps_data_analysis/src/calculators/sprint_calculator.dart';
import 'package:gps_data_analysis/src/calculators/time_in_speed_zones_calculator.dart';
import 'package:gps_data_analysis/src/cli/cli_result.dart';
import 'package:gps_data_analysis/src/cli/logger.dart';
import 'package:gps_data_analysis/src/models/gps_data.dart';
import 'package:gps_data_analysis/src/processors/acceleration/add_acceleration_from_velocity_derivative_processor.dart';
import 'package:gps_data_analysis/src/processors/acceleration/add_acceleration_processor.dart';
import 'package:gps_data_analysis/src/processors/acceleration/median_filter_processor.dart';
import 'package:gps_data_analysis/src/processors/distance/add_distance_to_stream_processor_using_trapezoid.dart';
import 'package:gps_data_analysis/src/processors/error_handling/error_filter_processor.dart';
import 'package:gps_data_analysis/src/processors/signal/add_signal_quality_indicator.dart';
import 'package:gps_data_analysis/src/processors/velocity_smoothing/kalman_smoothing_processor.dart';
import 'package:gps_data_analysis/src/processors/velocity_smoothing/moving_average_smoothing_processor.dart';
import 'package:gps_data_analysis/src/utils/csv_reader.dart';

late Logger logger;

/// CLI for reading CSV files
void main(List<String> arguments) {
  DartCLI().run(arguments);
}

/// A command-line interface (CLI) application for reading and processing GPS data from CSV files.
/// The DartCLI class provides methods to parse command-line arguments, read CSV files, apply a series of transformations to the data,
/// and compute various statistics using different calculators.
///
/// Example usage:
/// ```bash
/// dart run lib/cli.dart --path /path/to/csv --transformers MedianFilterProcessor,AddAccelerationProcessor --calculator MaxVelocityCalculator --verbose
/// ```
class DartCLI {
  late ArgResults args;
  List<String> transformers = <String>[];
  late String? calculator;
  final bool testMode;

  DartCLI({this.testMode = false});

  /// Returns ArgResults and output for testability
  CLIResult run(List<String> arguments) {
    final ArgParser parser = _setupArgParser();
    args = parser.parse(arguments);

    logger = testMode
        ? TestLogger()
        : args['verbose'] as bool
            ? VerboseLogger()
            : SimpleLogger();

    if (args['help'] as bool) {
      logger.log(parser.usage);
    } else {
      final String? path = args['path'] as String?;
      if ((path ?? '').isEmpty) {
        logger
          ..log('Please provide a path to a CSV file or directory.')
          ..log(parser.usage);
      } else {
        transformers = (args['transformers'] as String? ?? '').replaceAll(' ', '').split(',').where((String t) => t.isNotEmpty).toList();
        calculator = args['calculator'] as String?;
        _processPath(path!);
      }
    }
    return CLIResult(args: args, output: logger.output);
  }

  ArgParser _setupArgParser() {
    final ArgParser parser = ArgParser()
      ..addOption('path', abbr: 'p', help: 'Path to a CSV file or a directory of CSV files')
      ..addOption('transformers', abbr: 't', help: 'Comma-separated list of processors to apply (e.g., MedianFilterProcessor,AddAccelerationProcessor)')
      ..addOption('calculator', abbr: 'c', help: 'Calculator to apply (e.g., MaxVelocityCalculator). Will be applied after transformers (if any)')
      ..addFlag('verbose', abbr: 'v', negatable: false, help: 'Enable verbose output')
      ..addFlag('help', abbr: 'h', negatable: false, help: '');
    return parser;
  }

  Future<void> _processPath(String path) async {
    final FileSystemEntityType entity = FileSystemEntity.typeSync(path);

    if (entity == FileSystemEntityType.directory) {
      await _processDirectory(Directory(path));
    } else if (entity == FileSystemEntityType.file && _isCSV(path)) {
      await _readCSV(path);
    } else {
      logger.error('Invalid path provided.');
      return;
    }
  }

  Future<void> _processDirectory(Directory directory) async {
    logger.log('', verboseMessage: 'Processing directory ${directory.path}');
    await for (final FileSystemEntity entity in directory.list()) {
      if (entity is File) {
        if (_isCSV(entity.path)) await _readCSV(entity.path);
      } else if (entity is Directory) {
        await _processDirectory(entity);
      }
    }
  }

  bool _isCSV(String path) => path.toLowerCase().endsWith('.csv');
  Future<void> _readCSV(String path) async {
    logger.log('Reading $path:');
    try {
      final CsvReader reader = CsvReader(filePath: path);
      final Stream<GpsData> dataStream = _applyProcessors(reader.readAsGPSData()).asBroadcastStream();

      if (calculator != null) {
        final Stream<dynamic> calculatorStream = _applyCalculator(dataStream);
        logger.logTableHeader(calculator);
        final Stream<(GpsData, dynamic)> combinedStream = ZipStream<dynamic, (GpsData, dynamic)>(
          <Stream<dynamic>>[dataStream, calculatorStream],
          (List<dynamic> values) => (values[0], values[1]),
        );
        combinedStream.listen(((GpsData, dynamic) data) => logger.logTableData(data.$1, calc: data.$2));
      } else {
        logger.logTableHeader(calculator);
        dataStream.listen((GpsData data) => logger.logTableData(data));
      }
    } catch (e, s) {
      logger
        ..error('Error reading CSV file: $path')
        ..log('Error:\n$e\n\nStackTrace:\n$s');
    }
  }

  Stream<GpsData> _applyProcessors(Stream<GpsData> stream) {
    if (transformers.isEmpty) return stream;
    final String transformer = transformers.first;
    transformers.removeAt(0);
    return _applyProcessors(_transform(stream, transformer));
  }

  Stream<dynamic> _applyCalculator(Stream<GpsData> stream) {
    if (_calculatorMap.containsKey(calculator)) {
      logger.log('', verboseMessage: 'Calculator: $calculator');
      return _calculatorMap[calculator]!.calculate(stream);
    } else {
      logger.error('Unknown calculator: $calculator');
      return stream;
    }
  }

  Stream<GpsData> _transform(Stream<GpsData> stream, String transformer) {
    if (_transformerMap.containsKey(transformer)) {
      logger.log('', verboseMessage: 'Transformer: $transformer');
      return stream.transform(_transformerMap[transformer]!);
    } else {
      logger.error('Unknown transformer: $transformer');
      return stream;
    }
  }

  final Map<String, StreamTransformer<GpsData, GpsData>> _transformerMap = <String, StreamTransformer<GpsData, GpsData>>{
    AddAccelerationFromDerivativeProcessor.name: AddAccelerationFromDerivativeProcessor(),
    AddAccelerationProcessor.name: AddAccelerationProcessor(),
    MedianFilterProcessor.name: MedianFilterProcessor(),
    AddDistanceToStreamUsingTrapezoidProcessor.name: AddDistanceToStreamUsingTrapezoidProcessor(),
    ErrorFilterProcessor.name: ErrorFilterProcessor(),
    AddSignalQualityToStream.name: AddSignalQualityToStream(),
    KalmanSmoothingProcessor.name: KalmanSmoothingProcessor(),
    MovingAverageSmoothingProcessor.name: MovingAverageSmoothingProcessor(10),
  };
  final Map<String, Calculator<dynamic>> _calculatorMap = <String, Calculator<dynamic>>{
    CollisionCalculator.name: CollisionCalculator(initialThreshold: 80),
    InstantaneousVelocityCalculator.name: InstantaneousVelocityCalculator(),
    MaxAccelerationCalculator.name: MaxAccelerationCalculator(),
    MaxVelocityCalculator.name: MaxVelocityCalculator(),
    PeriodAccelerationCalculator.name: PeriodAccelerationCalculator(accelerationThreshold: 5, minDuration: 1),
    PlayerLoadCalculator.name: PlayerLoadCalculator(),
    SessionDurationCalculator.name: SessionDurationCalculator(),
    TimeInSpeedZonesCalculator.name: TimeInSpeedZonesCalculator(),
    SprintCalculator.name: SprintCalculator(),
  };
}
