import 'dart:typed_data';

import 'package:binary_data_reader/src/commands/command_registry.dart';
import 'package:binary_data_reader/src/commands/models/command.dart';

class CommandProducer {
  Command createCommandFromBinary(int commandId, Uint8List data) {
    final factory = CommandRegistry.factories[commandId];
    if (factory == null) {
      throw UnimplementedError('Factory for $commandId not found');
    }
    return factory.fromBinary(data);
  }

  T createCommandFromProperties<T extends Command>(
      int commandId, Map<String, dynamic> properties) {
    final factory = CommandRegistry.factories[commandId];
    if (factory == null) {
      throw UnimplementedError('Factory for $commandId not found');
    }
    return factory.fromProperties(properties) as T;
  }

  Command createBLECommandFromBinary(int commandId, Uint8List data) {
    final factory = CommandRegistry.bleFactories[commandId];
    if (factory == null) {
      throw UnimplementedError('BLE Factory for $commandId not found');
    }
    return factory.fromBinary(data);
  }

  T createBLECommandFromProperties<T extends Command>(
      int commandId, Map<String, dynamic> properties) {
    final factory = CommandRegistry.bleFactories[commandId];
    if (factory == null) {
      throw UnimplementedError('BLE Factory for $commandId not found');
    }
    return factory.fromProperties(properties) as T;
  }
}
