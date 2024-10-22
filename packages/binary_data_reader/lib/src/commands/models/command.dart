import 'dart:typed_data';

abstract class Command {
  int get commandId;
  // Implementation specific to SpecificCommand
  // Converts the Dart object's properties (like someValue) into bytes
  Uint8List serialize();
}
