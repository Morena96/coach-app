import 'package:args/args.dart';

/// Result of CLI file, used on testing
class CLIResult {
  final ArgResults args;
  final String output;

  CLIResult({
    required this.args,
    required this.output,
  });
}
