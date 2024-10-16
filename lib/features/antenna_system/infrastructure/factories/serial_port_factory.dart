import 'package:flutter_libserialport/flutter_libserialport.dart';

abstract class SerialPortFactory {
  List<String> getAvailablePorts();

  SerialPort createSerialPort(String portName);

  SerialPortReader createSerialPortReader(SerialPort port);
}


