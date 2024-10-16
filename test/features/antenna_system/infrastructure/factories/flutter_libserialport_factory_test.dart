import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:coach_app/features/antenna_system/infrastructure/factories/flutter_libserialport_factory.dart';

import 'flutter_libserialport_factory_test.mocks.dart';

@GenerateMocks([SerialPortWrapper, SerialPort, SerialPortReader])
void main() {
  group('FlutterLibSerialPortFactory', () {
    late FlutterLibSerialPortFactory factory;
    late MockSerialPortWrapper mockWrapper;

    setUp(() {
      mockWrapper = MockSerialPortWrapper();
      factory = FlutterLibSerialPortFactory(wrapper: mockWrapper);
    });

    test('getAvailablePorts returns correct list of ports', () {
      // Arrange
      when(mockWrapper.getAvailablePorts())
          .thenReturn(['COM1', 'COM2', 'COM3']);

      // Act
      final result = factory.getAvailablePorts();

      // Assert
      expect(result, equals(['COM1', 'COM2', 'COM3']));
      verify(mockWrapper.getAvailablePorts()).called(1);
    });

    test('createSerialPort returns a SerialPort instance', () {
      // Arrange
      const portName = 'COM1';
      final mockPort = MockSerialPort();
      when(mockWrapper.createSerialPort(portName)).thenReturn(mockPort);

      // Act
      final result = factory.createSerialPort(portName);

      // Assert
      expect(result, equals(mockPort));
      verify(mockWrapper.createSerialPort(portName)).called(1);
    });

    test('createSerialPortReader returns a SerialPortReader instance', () {
      // Arrange
      final mockPort = MockSerialPort();
      final mockReader = MockSerialPortReader();
      when(mockWrapper.createSerialPortReader(mockPort)).thenReturn(mockReader);

      // Act
      final result = factory.createSerialPortReader(mockPort);

      // Assert
      expect(result, equals(mockReader));
      verify(mockWrapper.createSerialPortReader(mockPort)).called(1);
    });
  });
}
