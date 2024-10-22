import 'package:collection/collection.dart';
import 'package:dart_console/dart_console.dart';
import 'package:gps_data_analysis/src/models/gps_data.dart';

/// Logger class for logging messages and formatted GPS data tables.
/// The Logger class uses a console to print messages with different levels of verbosity and formatting.

class Logger {
  final List<String> tableHeaders = <String>['Timestamp   ', 'Latitude  ', 'Longitude  ', 'Velocity', 'Avg Acc X', 'Avg Acc Y', 'Avg Acc Z', 'Avg Acc'];
  List<int>? tableHeaderWidths;

  final Console console = Console()..setForegroundColor(ConsoleColor.blue);

  /// Logs a message to the console.
  ///
  /// [message] is the main message to be logged.
  /// [verboseMessage] is an optional verbose message to be logged if verbose mode is enabled.
  void log(String message, {String? verboseMessage}) {}

  /// Logs an error message to the console in red color.
  ///
  /// [message] is the error message to be logged.
  void error(String message) {
    console.setForegroundColor(ConsoleColor.red);
    if (message.isNotEmpty) print(message);
  }

  /// Logs the table header for displaying GPS data.
  ///
  /// [calculator] is an optional calculator name to be included in the header.
  void logTableHeader(String? calculator) {
    final String headerStr = _tableHeader(calculator);
    print('─' * headerStr.length);
    print(headerStr);
    print('─' * headerStr.length);
  }

  /// Logs a row of GPS data.
  ///
  /// [data] is the GPS data to be logged.
  /// [calc] is an optional calculated value to be included in the row.
  void logTableData(GpsData data, {dynamic calc}) {
    print('│ ${_tableRow(data, calc: calc)} │');
  }

  String _tableHeader(String? calculator) {
    final List<String> headers = <String>[...tableHeaders, if (calculator != null) calculator];
    tableHeaderWidths = headers.map((String e) => e.length).toList();
    return '│ ${headers.join(' │ ')} │';
  }

  String _tableRow(GpsData data, {dynamic calc}) {
    final List<String> row = <String>[
      (data.timestamp ~/ 1000).toString(),
      data.latitude.toStringAsFixed(7),
      data.longitude.toStringAsFixed(7),
      data.velocity.toStringAsFixed(2),
      _logAcc(data.accelerationX),
      _logAcc(data.accelerationY),
      _logAcc(data.accelerationZ),
      _logAcc(data.acceleration),
      if (calc != null) calc is double ? calc.toStringAsFixed(2) : calc.toString(),
    ];
    return row.mapIndexed((int index, String e) => e.padRight(tableHeaderWidths?[index] ?? 0)).join(' │ ');
  }

  String _logAcc(List<double> acceleration) {
    return acceleration.isEmpty ? '-' : (acceleration.reduce((double a, double b) => a + b) / acceleration.length).toStringAsFixed(2);
  }

  String get output => '';
}

///
class TestLogger extends Logger {
  StringBuffer buffer = StringBuffer();

  @override
  String get output => buffer.toString();

  @override
  void logTableHeader(String? calculator) {
    final String headerStr = _tableHeader(calculator);
    buffer
      ..writeln('─' * headerStr.length)
      ..writeln(headerStr)
      ..writeln('─' * headerStr.length);
  }

  @override
  void logTableData(GpsData data, {dynamic calc}) {
    buffer.writeln('│ ${_tableRow(data, calc: calc)} │');
  }

  @override
  void error(String message) {
    if (message.isNotEmpty) buffer.writeln(message);
  }

  @override
  void log(String message, {String? verboseMessage}) {
    if (message.isNotEmpty) buffer.writeln(message);
    if ((verboseMessage ?? '').isNotEmpty) buffer.writeln(verboseMessage);
  }
}

class VerboseLogger extends Logger {
  @override
  void log(String message, {String? verboseMessage}) {
    console.setForegroundColor(ConsoleColor.blue);
    // Only log if verbose mode is enabled
    if (message.isNotEmpty) print(message);
    if ((verboseMessage ?? '').isNotEmpty) print(verboseMessage);
  }
}

class SimpleLogger extends Logger {
  @override
  void log(String message, {String? verboseMessage}) {
    console.setForegroundColor(ConsoleColor.blue);
    // Only log if verbose mode is enabled
    if (message.isNotEmpty) print(message);
  }
}
