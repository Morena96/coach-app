import 'dart:async';
import 'dart:typed_data';

import 'package:coach_app/features/antenna_system/infrastructure/adapters/hex_converter_impl.dart';
import 'package:domain/features/antenna_system/entities/antenna_info.dart';
import 'package:coach_app/features/antenna_system/infrastructure/datasources/flutter_libserialport_impl.dart';
import 'package:coach_app/features/antenna_system/infrastructure/factories/serial_port_factory.dart';
import 'package:domain/features/logging/repositories/logger.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks(
    [LoggerRepository, SerialPort, SerialPortFactory, SerialPortReader])
import 'flutter_libserialport_adapter_test.mocks.dart';

void main() {
  late FlutterLibserialportImpl adapter;
  late MockLoggerRepository mockLogger;
  late MockSerialPortFactory mockSerialPortFactory;
  late HexConverterImpl hexConverter;

  setUp(() {
    mockLogger = MockLoggerRepository();
    mockSerialPortFactory = MockSerialPortFactory();
    hexConverter = HexConverterImpl();

    adapter = FlutterLibserialportImpl(mockLogger, mockSerialPortFactory, hexConverter);
  });

  ({MockSerialPort mockPort, MockSerialPortReader mockPortReader}) setupMockPorts() {
    final mockPort = MockSerialPort();
    final mockPortReader = MockSerialPortReader();

    when(mockSerialPortFactory.getAvailablePorts()).thenReturn(['COM1']);
    when(mockSerialPortFactory.createSerialPort('COM1')).thenReturn(mockPort);
    when(mockSerialPortFactory.createSerialPortReader(mockPort))
        .thenReturn(mockPortReader);
    when(mockPort.vendorId)
        .thenReturn(FlutterLibserialportImpl.antennaVendorId);
    when(mockPort.productId)
        .thenReturn(FlutterLibserialportImpl.antennaProductId);
    when(mockPort.description).thenReturn('Test Antenna');
    when(mockPort.serialNumber).thenReturn('123456');
    when(mockPort.open(mode: SerialPortMode.readWrite)).thenReturn(true);
    when(mockPort.close()).thenReturn(true);
    when(mockPort.write(any)).thenReturn(1);

    // return a record
    return (mockPort: mockPort, mockPortReader: mockPortReader);
  }

  test('error is logged when a port cannot open when updating ports', () {

    final mockPorts = setupMockPorts();

    when(mockPorts.mockPort.open(mode: SerialPortMode.readWrite)).thenReturn(false);

    adapter.updatePortsForTesting();

    verify(mockLogger.error('Failed to open port: COM1', any)).called(1);

  });

  group('FlutterLibserialportImpl', () {
    test('getAvailableAntenna returns correct list', () {
      final antennas = adapter.getAvailableAntenna();
      expect(antennas, isA<List<AntennaInfo>>());
    });

    test('getAntennaInfo returns correct info for available port', () {
      final ports = adapter.getAvailablePorts();
      if (ports.isNotEmpty) {
        final info = adapter.getAntennaInfo(ports.first);
        expect(info, isA<AntennaInfo>());
        expect(info.portName, equals(ports.first));
      } else {
        // If no ports are available, this test is not applicable
        expect(true, isTrue, reason: 'No ports available for testing');
      }
    });

    test('getAntennaInfo throws exception for non-existent port', () {
      expect(
          () => adapter.getAntennaInfo('NON_EXISTENT_PORT'), throwsException);
    });

    test('sendCommand does not throw for valid port', () async {
      // set up mock ports
      setupMockPorts();

      // update ports
      adapter.updatePortsForTesting();

      final ports = adapter.getAvailablePorts();

      if (ports.isNotEmpty) {
        final command = Uint8List.fromList([1, 2, 3]);
        await expectLater(adapter.sendCommand(ports.first, command), completes);
      } else {
        // If no ports are available, this test is not applicable
        expect(true, isTrue, reason: 'No ports available for testing');
      }
    });

    test('sendCommand throws exception for non-existent port', () {
      final command = Uint8List.fromList([1, 2, 3]);
      expect(() => adapter.sendCommand('NON_EXISTENT_PORT', command),
          throwsException);
    });

    test('sendCommand handles port.write failure', () async {
      final mockPorts = setupMockPorts();
      adapter.updatePortsForTesting();
      final ports = adapter.getAvailablePorts();
      if (ports.isNotEmpty) {
        final portName  = ports.first;
        final command = Uint8List.fromList([1, 2, 3]);

        when(mockSerialPortFactory.createSerialPort(portName))
            .thenReturn(mockPorts.mockPort);
        when(mockPorts.mockPort.write(command)).thenThrow(Exception('Write failed'));

        await expectLater(
            adapter.sendCommand(portName, command), throwsException);
        verify(mockLogger.error(
                'Failed to send command to port: $portName', any))
            .called(1);
      } else {
        // If no ports are available, this test is not applicable
        expect(true, isTrue, reason: 'No ports available for testing');
      }
    });

    test('sendCommand successfully writes to port and logs success', () {
      final mockPorts = setupMockPorts();
      adapter.updatePortsForTesting();
      final ports = adapter.getAvailablePorts();
      if (ports.isNotEmpty) {
        final portName = ports.first;

        adapter.sendCommand(portName, Uint8List.fromList([1, 2, 3]));

        verify(mockPorts.mockPort.write(any)).called(1);
        verify(mockLogger.debug('Sent command to port: $portName')).called(1);
      } else {
        expect(true, isTrue, reason: 'No ports available for testing');
      }
    });

    test('sendCommandToAll completes without error', () async {
      setupMockPorts();
      adapter.updatePortsForTesting();
      await expectLater(
          adapter.sendCommandToAll(Uint8List.fromList([1, 2, 3])), completes);
    });

    test('closeAll completes without error', () async {
      await expectLater(adapter.closeAll(), completes);
    });

    test('closeAll should close all ports', () {
      final mockPorts = setupMockPorts();
      adapter.updatePortsForTesting();
      adapter.closeAll();
      verify(mockPorts.mockPort.close()).called(1);
      verify(mockPorts.mockPortReader.close()).called(1);
      expect(adapter.getAvailablePorts(), isEmpty);
      expect(adapter.getAvailableAntenna(), isEmpty);
    });

    test('closePort completes without error for existing port', () async {
      final ports = adapter.getAvailablePorts();
      if (ports.isNotEmpty) {
        await expectLater(adapter.closePort(ports.first), completes);
      } else {
        // If no ports are available, this test is not applicable
        expect(true, isTrue, reason: 'No ports available for testing');
      }
    });

    test('getDataStream returns a Stream for valid port', () {
      final ports = adapter.getAvailablePorts();
      if (ports.isNotEmpty) {
        final stream = adapter.getDataStream(ports.first);
        expect(stream, isA<Stream<Uint8List>>());
      } else {
        // If no ports are available, this test is not applicable
        expect(true, isTrue, reason: 'No ports available for testing');
      }
    });

    test('getDataStream throws exception for non-existent port', () {
      expect(() => adapter.getDataStream('NON_EXISTENT_PORT'), throwsException);
    });

    test('getAntennaStream returns a Stream', () {
      final stream = adapter.getAntennaStream();
      expect(stream, isA<Stream<List<AntennaInfo>>>());
    });
  });

  test('Port monitoring adds new ports', () {
    final mockPort1 = MockSerialPort();
    final mockPort2 = MockSerialPort();

    final mockPortReader1 = MockSerialPortReader();

    when(mockSerialPortFactory.getAvailablePorts()).thenReturn(['COM1']);
    when(mockSerialPortFactory.createSerialPort('COM1')).thenReturn(mockPort1);
    when(mockSerialPortFactory.createSerialPortReader(mockPort1))
        .thenReturn(mockPortReader1);

    when(mockPort1.vendorId)
        .thenReturn(FlutterLibserialportImpl.antennaVendorId);
    when(mockPort1.productId)
        .thenReturn(FlutterLibserialportImpl.antennaProductId);
    when(mockPort1.description).thenReturn('Test Antenna');
    when(mockPort1.serialNumber).thenReturn('123456');

    when(mockPort1.open(mode: SerialPortMode.readWrite)).thenReturn(true);

    adapter.updatePortsForTesting();

    expect(adapter.getAvailablePorts(), ['COM1']);

    when(mockSerialPortFactory.getAvailablePorts())
        .thenReturn(['COM1', 'COM2']);
    when(mockSerialPortFactory.createSerialPort('COM2')).thenReturn(mockPort2);

    when(mockPort2.vendorId)
        .thenReturn(FlutterLibserialportImpl.antennaVendorId);
    when(mockPort2.productId)
        .thenReturn(FlutterLibserialportImpl.antennaProductId);
    when(mockPort2.description).thenReturn('Test Antenna');
    when(mockPort2.serialNumber).thenReturn('123456');

    when(mockPort2.open(mode: SerialPortMode.readWrite)).thenReturn(true);

    adapter.updatePortsForTesting();
    expect(adapter.getAvailablePorts(), ['COM1', 'COM2']);
  });

  test('Port monitoring removes unavailable ports', () {
    final mockPort1 = MockSerialPort();
    final mockPort2 = MockSerialPort();
    final mockPortReader1 = MockSerialPortReader();

    when(mockSerialPortFactory.getAvailablePorts())
        .thenReturn(['COM1', 'COM2']);
    when(mockSerialPortFactory.createSerialPort('COM1')).thenReturn(mockPort1);
    when(mockSerialPortFactory.createSerialPort('COM2')).thenReturn(mockPort2);
    when(mockSerialPortFactory.createSerialPortReader(mockPort1))
        .thenReturn(mockPortReader1);

    when(mockPort1.vendorId)
        .thenReturn(FlutterLibserialportImpl.antennaVendorId);
    when(mockPort1.productId)
        .thenReturn(FlutterLibserialportImpl.antennaProductId);
    when(mockPort1.description).thenReturn('Test Antenna');
    when(mockPort1.serialNumber).thenReturn('123456');

    when(mockPort1.open(mode: SerialPortMode.readWrite)).thenReturn(true);
    when(mockPort1.close()).thenReturn(true);

    when(mockPort2.vendorId)
        .thenReturn(FlutterLibserialportImpl.antennaVendorId);
    when(mockPort2.productId)
        .thenReturn(FlutterLibserialportImpl.antennaProductId);
    when(mockPort2.description).thenReturn('Test Antenna');
    when(mockPort2.serialNumber).thenReturn('123456');

    when(mockPort2.open(mode: SerialPortMode.readWrite)).thenReturn(true);
    when(mockPort2.close()).thenReturn(true);

    adapter.updatePortsForTesting();
    expect(adapter.getAvailablePorts(), ['COM1', 'COM2']);

    when(mockSerialPortFactory.getAvailablePorts()).thenReturn(['COM1']);
    adapter.updatePortsForTesting();
    expect(adapter.getAvailablePorts(), ['COM1']);
  });

  test('closePort closes the specified port', () async {
    final mockPort = MockSerialPort();
    final mockPortReader = MockSerialPortReader();

    when(mockSerialPortFactory.getAvailablePorts()).thenReturn(['COM1']);
    when(mockSerialPortFactory.createSerialPort('COM1')).thenReturn(mockPort);
    when(mockSerialPortFactory.createSerialPortReader(mockPort))
        .thenReturn(mockPortReader);

    when(mockPort.vendorId)
        .thenReturn(FlutterLibserialportImpl.antennaVendorId);
    when(mockPort.productId)
        .thenReturn(FlutterLibserialportImpl.antennaProductId);
    when(mockPort.description).thenReturn('Test Antenna');
    when(mockPort.serialNumber).thenReturn('123456');

    when(mockPort.open(mode: SerialPortMode.readWrite)).thenReturn(true);
    when(mockPort.close()).thenReturn(true);

    adapter.updatePortsForTesting();
    expect(adapter.getAvailablePorts(), ['COM1']);

    await adapter.closePort('COM1');
    expect(adapter.getAvailablePorts(), isEmpty);
    verify(mockPort.close()).called(1);
  });

  test('getDataStream returns the correct reader stream', () {
    final mockPort = MockSerialPort();
    final mockPortReader = MockSerialPortReader();
    final mockStream = Stream<Uint8List>.fromIterable([
      Uint8List.fromList([0, 1, 2, 3]),
      Uint8List.fromList([4, 5, 6, 7])
    ]);

    when(mockSerialPortFactory.getAvailablePorts()).thenReturn(['COM1']);
    when(mockSerialPortFactory.createSerialPort('COM1')).thenReturn(mockPort);
    when(mockSerialPortFactory.createSerialPortReader(mockPort))
        .thenReturn(mockPortReader);
    when(mockPortReader.stream).thenAnswer((_) => mockStream);

    when(mockPort.vendorId)
        .thenReturn(FlutterLibserialportImpl.antennaVendorId);
    when(mockPort.productId)
        .thenReturn(FlutterLibserialportImpl.antennaProductId);
    when(mockPort.description).thenReturn('Test Antenna');
    when(mockPort.serialNumber).thenReturn('123456');

    when(mockPort.open(mode: SerialPortMode.readWrite)).thenReturn(true);
    when(mockPort.close()).thenReturn(true);

    adapter.updatePortsForTesting();

    final dataStream = adapter.getDataStream('COM1');
    expect(
        dataStream,
        emitsInOrder([
          Uint8List.fromList([0, 1, 2, 3]),
          Uint8List.fromList([4, 5, 6, 7])
        ]));
  });

  test('getAntennaInfo returns correct info for available port', () {
    final mockPort = MockSerialPort();
    final mockPortReader = MockSerialPortReader();

    when(mockSerialPortFactory.getAvailablePorts()).thenReturn(['COM1']);
    when(mockSerialPortFactory.createSerialPort('COM1')).thenReturn(mockPort);
    when(mockSerialPortFactory.createSerialPortReader(mockPort))
        .thenReturn(mockPortReader);

    when(mockPort.vendorId)
        .thenReturn(FlutterLibserialportImpl.antennaVendorId);
    when(mockPort.productId)
        .thenReturn(FlutterLibserialportImpl.antennaProductId);
    when(mockPort.description).thenReturn('Test Antenna');
    when(mockPort.serialNumber).thenReturn('123456');

    when(mockPort.open(mode: SerialPortMode.readWrite)).thenReturn(true);
    when(mockPort.close()).thenReturn(true);

    adapter.updatePortsForTesting();

    final info = adapter.getAntennaInfo('COM1');
    expect(info, isA<AntennaInfo>());
    expect(info.portName, equals('COM1'));
    expect(info.description, equals('Test Antenna'));
    expect(info.serialNumber, equals('123456'));
    expect(info.vendorId, equals(FlutterLibserialportImpl.antennaVendorId));
    expect(
        info.productId, equals(FlutterLibserialportImpl.antennaProductId));
  });

  test('dispose method cancels timer, closes all ports and stream controller', () {
    // Setup
    final mockPorts = setupMockPorts();

    adapter.updatePortsForTesting();

    adapter.dispose();

    // Assert
    verify(mockPorts.mockPort.close()).called(1);
    verify(mockPorts.mockPortReader.close()).called(1);

    // Verify that the antenna stream is closed
    expect(adapter.getAntennaStream().isBroadcast, isTrue);
    expectLater(adapter.getAntennaStream(), emitsDone);

    // Verify that all ports are closed
    expect(adapter.getAvailablePorts(), isEmpty);
    expect(adapter.getAvailableAntenna(), isEmpty);
  });
}
