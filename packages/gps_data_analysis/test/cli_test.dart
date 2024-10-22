import 'package:test/test.dart';

import 'package:gps_data_analysis/src/cli/cli.dart';
import 'package:gps_data_analysis/src/cli/cli_result.dart';

void main() {
  group('CLI', () {
    final DartCLI cli = DartCLI(testMode: true);
    test('Should handle verbose flag correctly', () {
      final CLIResult result = cli.run(<String>['-p', 'csv/2seconds.csv', '-v']);
      expect(result.args['verbose'], true);
    });

    test('Should handle help flag correctly', () {
      final CLIResult result = cli.run(<String>['-h']);
      expect(result.args['help'], true);
      expect(result.args['verbose'], false);
      expect(result.args['path'], null);
      expect(result.output.contains('Path to a CSV file or a directory of CSV files'), true);
    });

    test('Should handle path correctly', () {
      final CLIResult result = cli.run(<String>['-p', 'csv/2seconds.csv']);
      expect(result.args['path'], 'csv/2seconds.csv');
      expect(result.args['verbose'], false);
    });

    test('Should handle empty path', () {
      final CLIResult result = cli.run(<String>['-v']);
      expect(result.output.contains('Please provide a path to a CSV file or directory'), true);
    });

    test('Should handle incorrect path', () {
      final CLIResult result = cli.run(<String>['--path', 'as.']);
      expect(result.output.contains('Invalid path provided'), true);
    });

    test('Should handle directory', () {
      final CLIResult result = cli.run(<String>['--path', 'csv']);
      expect(result.output.contains('Processing directory csv'), true);
    });

    test('Should parse transformers', () {
      final CLIResult result = cli.run(<String>['-p', 'csv/2seconds.csv', '-t', 'AddAccelerationFromDerivativeProcessor,AddDistanceToStreamUsingTrapezoidProcessor']);
      expect(result.output.contains('AddAccelerationFromDerivativeProcessor'), true);
      expect(result.output.contains('AddDistanceToStreamUsingTrapezoidProcessor'), true);
    });

    test('Should handle incorrect transformer', () {
      final CLIResult result = cli.run(<String>['-p', 'csv/2seconds.csv', '-t', 'FakeTransformer']);
      expect(result.output.contains('Unknown transformer: FakeTransformer'), true);
    });

    test('Should parse calculator', () {
      final CLIResult result = cli.run(<String>['-p', 'csv/2seconds.csv', '-c', 'MaxVelocityCalculator']);
      expect(result.output.contains('MaxVelocityCalculator'), true);
    });

    test('Should handle incorrect calculator', () {
      final CLIResult result = cli.run(<String>['-p', 'csv/2seconds.csv', '-c', 'FakeCalculator']);
      expect(result.output.contains('Unknown calculator: FakeCalculator'), true);
    });
  });
}
