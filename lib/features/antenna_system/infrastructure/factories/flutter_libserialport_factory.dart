import 'package:flutter_libserialport/flutter_libserialport.dart';

import 'package:coach_app/features/antenna_system/infrastructure/factories/serial_port_factory.dart';

class FlutterLibSerialPortFactory implements SerialPortFactory {
  final SerialPortWrapper _wrapper;

  FlutterLibSerialPortFactory({SerialPortWrapper? wrapper})
      : _wrapper = wrapper ?? SerialPortWrapper();

  @override
  List<String> getAvailablePorts() {
    return _wrapper.getAvailablePorts();
  }

  @override
  SerialPort createSerialPort(String portName) {
    return _wrapper.createSerialPort(portName);
  }

  @override
  SerialPortReader createSerialPortReader(SerialPort port) {
    return _wrapper.createSerialPortReader(port);
  }
}

class SerialPortWrapper {
  /// Returns a list of available serial ports
  List<String> getAvailablePorts() {
    return SerialPort.availablePorts;
  }

  /// Creates a new SerialPort instance
  SerialPort createSerialPort(String portName) {
    return SerialPort(portName);
  }

  /// Creates a new SerialPortReader instance
  SerialPortReader createSerialPortReader(SerialPort port) {
    return SerialPortReader(port);
  }
}
