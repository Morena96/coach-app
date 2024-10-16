// Mocks generated by Mockito 5.4.4 from annotations
// in coach_app/test/unit/antenna_system/antenna_system_service_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;
import 'dart:typed_data' as _i5;

import 'package:domain/features/antenna_system/entities/antenna_info.dart'
    as _i2;
import 'package:domain/features/antenna_system/services/serial_port_service.dart'
    as _i3;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeAntennaInfo_0 extends _i1.SmartFake implements _i2.AntennaInfo {
  _FakeAntennaInfo_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [SerialPortService].
///
/// See the documentation for Mockito's code generation for more information.
class MockSerialPortService extends _i1.Mock implements _i3.SerialPortService {
  MockSerialPortService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  List<_i2.AntennaInfo> getAvailableAntenna() => (super.noSuchMethod(
        Invocation.method(
          #getAvailableAntenna,
          [],
        ),
        returnValue: <_i2.AntennaInfo>[],
      ) as List<_i2.AntennaInfo>);

  @override
  List<String> getAvailablePorts() => (super.noSuchMethod(
        Invocation.method(
          #getAvailablePorts,
          [],
        ),
        returnValue: <String>[],
      ) as List<String>);

  @override
  _i2.AntennaInfo getAntennaInfo(String? portName) => (super.noSuchMethod(
        Invocation.method(
          #getAntennaInfo,
          [portName],
        ),
        returnValue: _FakeAntennaInfo_0(
          this,
          Invocation.method(
            #getAntennaInfo,
            [portName],
          ),
        ),
      ) as _i2.AntennaInfo);

  @override
  _i4.Stream<List<_i2.AntennaInfo>> getAntennaStream() => (super.noSuchMethod(
        Invocation.method(
          #getAntennaStream,
          [],
        ),
        returnValue: _i4.Stream<List<_i2.AntennaInfo>>.empty(),
      ) as _i4.Stream<List<_i2.AntennaInfo>>);
}

/// A class which mocks [SerialPortCommandService].
///
/// See the documentation for Mockito's code generation for more information.
class MockSerialPortCommandService extends _i1.Mock
    implements _i3.SerialPortCommandService {
  MockSerialPortCommandService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<void> sendCommand(
    String? portName,
    _i5.Uint8List? command,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #sendCommand,
          [
            portName,
            command,
          ],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> sendCommandToAll(_i5.Uint8List? command) =>
      (super.noSuchMethod(
        Invocation.method(
          #sendCommandToAll,
          [command],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> closeAll() => (super.noSuchMethod(
        Invocation.method(
          #closeAll,
          [],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> closePort(String? portName) => (super.noSuchMethod(
        Invocation.method(
          #closePort,
          [portName],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
}

/// A class which mocks [SerialPortDataService].
///
/// See the documentation for Mockito's code generation for more information.
class MockSerialPortDataService extends _i1.Mock
    implements _i3.SerialPortDataService {
  MockSerialPortDataService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Stream<_i5.Uint8List> getDataStream(String? portName) =>
      (super.noSuchMethod(
        Invocation.method(
          #getDataStream,
          [portName],
        ),
        returnValue: _i4.Stream<_i5.Uint8List>.empty(),
      ) as _i4.Stream<_i5.Uint8List>);

  @override
  _i4.Future<void> closeAll() => (super.noSuchMethod(
        Invocation.method(
          #closeAll,
          [],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> closePort(String? portName) => (super.noSuchMethod(
        Invocation.method(
          #closePort,
          [portName],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
}
