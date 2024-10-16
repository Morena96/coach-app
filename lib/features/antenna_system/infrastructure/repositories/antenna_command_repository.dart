import 'dart:typed_data';

import 'package:domain/features/antenna_system/repositories/antenna_command_repository.dart';
import 'package:domain/features/antenna_system/services/serial_port_service.dart';
import 'package:domain/features/logging/repositories/logger.dart';

/// Concrete implementation of the AntennaCommandRepository interface
/// Provides methods to send commands to the antenna system
/// using the SerialPortCommandService
class AntennaCommandRepositoryImpl implements AntennaCommandRepository {
  final SerialPortCommandService _serialPortService;
  final LoggerRepository _loggerRepository;

  AntennaCommandRepositoryImpl(this._serialPortService, this._loggerRepository);

  @override
  Future<void> sendCommandToAll(Uint8List command) async {
    try {
      await _serialPortService.sendCommandToAll(command);
      _loggerRepository.info('Command sent to all ports: $command');
    } catch (e) {
      _loggerRepository.error('Failed to send command to all ports: $command');
      throw AntennaCommandException(
          'Failed to send command to all ports: ${e.toString()}');
    }
  }

  @override
  Future<void> sendCommand(String portName, Uint8List command) async {
    try {
      await _serialPortService.sendCommand(portName, command);
      _loggerRepository.info('Command sent to $portName: $command');
    } catch (e) {
      _loggerRepository.error('Failed to send command to $portName: $command');
      throw AntennaCommandException('Failed to send command: ${e.toString()}');
    }
  }

  @override
  Future<void> closePort(String portName) async {
    try {
      await _serialPortService.closePort(portName);
      _loggerRepository.info('Port $portName closed');
    } catch (e) {
      _loggerRepository
          .error('Failed to close port $portName: ${e.toString()}');
      throw AntennaCommandException(
          'Failed to close port $portName: ${e.toString()}');
    }
  }

  @override
  Future<void> closeAllPorts() async {
    try {
      await _serialPortService.closeAll();
      _loggerRepository.info('All ports closed');
    } catch (e) {
      _loggerRepository.error('Failed to close all ports: ${e.toString()}');
      throw AntennaCommandException(
          'Failed to close all ports: ${e.toString()}');
    }
  }
}

class AntennaCommandException implements Exception {
  final String message;

  AntennaCommandException(this.message);

  @override
  String toString() => 'AntennaCommandException: $message';
}
