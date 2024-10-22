// Mocks generated by Mockito 5.4.4 from annotations
// in coach_app/test/unit/antenna_system/flutter_libserialport_adapter_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;
import 'dart:typed_data' as _i7;

import 'package:coach_app/features/antenna_system/infrastructure/factories/serial_port_factory.dart'
    as _i8;
import 'package:domain/features/logging/entities/log_entry.dart' as _i6;
import 'package:domain/features/logging/repositories/logger.dart' as _i4;
import 'package:flutter_libserialport/flutter_libserialport.dart' as _i3;
import 'package:libserialport/src/config.dart' as _i2;
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

class _FakeSerialPortConfig_0 extends _i1.SmartFake
    implements _i2.SerialPortConfig {
  _FakeSerialPortConfig_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeSerialPort_1 extends _i1.SmartFake implements _i3.SerialPort {
  _FakeSerialPort_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeSerialPortReader_2 extends _i1.SmartFake
    implements _i3.SerialPortReader {
  _FakeSerialPortReader_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [LoggerRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockLoggerRepository extends _i1.Mock implements _i4.LoggerRepository {
  MockLoggerRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i5.Stream<_i6.LogEntry> get logStream => (super.noSuchMethod(
        Invocation.getter(#logStream),
        returnValue: _i5.Stream<_i6.LogEntry>.empty(),
      ) as _i5.Stream<_i6.LogEntry>);

  @override
  void debug(String? message) => super.noSuchMethod(
        Invocation.method(
          #debug,
          [message],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void info(String? message) => super.noSuchMethod(
        Invocation.method(
          #info,
          [message],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void warning(String? message) => super.noSuchMethod(
        Invocation.method(
          #warning,
          [message],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void error(
    String? message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) =>
      super.noSuchMethod(
        Invocation.method(
          #error,
          [
            message,
            error,
            stackTrace,
          ],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i5.Future<List<_i6.LogEntry>> getLogsByPage(
    int? page,
    int? pageSize,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #getLogsByPage,
          [
            page,
            pageSize,
          ],
        ),
        returnValue: _i5.Future<List<_i6.LogEntry>>.value(<_i6.LogEntry>[]),
      ) as _i5.Future<List<_i6.LogEntry>>);
}

/// A class which mocks [SerialPort].
///
/// See the documentation for Mockito's code generation for more information.
class MockSerialPort extends _i1.Mock implements _i3.SerialPort {
  MockSerialPort() {
    _i1.throwOnMissingStub(this);
  }

  @override
  int get address => (super.noSuchMethod(
        Invocation.getter(#address),
        returnValue: 0,
      ) as int);

  @override
  bool get isOpen => (super.noSuchMethod(
        Invocation.getter(#isOpen),
        returnValue: false,
      ) as bool);

  @override
  int get transport => (super.noSuchMethod(
        Invocation.getter(#transport),
        returnValue: 0,
      ) as int);

  @override
  _i2.SerialPortConfig get config => (super.noSuchMethod(
        Invocation.getter(#config),
        returnValue: _FakeSerialPortConfig_0(
          this,
          Invocation.getter(#config),
        ),
      ) as _i2.SerialPortConfig);

  @override
  set config(_i2.SerialPortConfig? config) => super.noSuchMethod(
        Invocation.setter(
          #config,
          config,
        ),
        returnValueForMissingStub: null,
      );

  @override
  int get bytesAvailable => (super.noSuchMethod(
        Invocation.getter(#bytesAvailable),
        returnValue: 0,
      ) as int);

  @override
  int get bytesToWrite => (super.noSuchMethod(
        Invocation.getter(#bytesToWrite),
        returnValue: 0,
      ) as int);

  @override
  int get signals => (super.noSuchMethod(
        Invocation.getter(#signals),
        returnValue: 0,
      ) as int);

  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  bool open({required int? mode}) => (super.noSuchMethod(
        Invocation.method(
          #open,
          [],
          {#mode: mode},
        ),
        returnValue: false,
      ) as bool);

  @override
  bool openRead() => (super.noSuchMethod(
        Invocation.method(
          #openRead,
          [],
        ),
        returnValue: false,
      ) as bool);

  @override
  bool openWrite() => (super.noSuchMethod(
        Invocation.method(
          #openWrite,
          [],
        ),
        returnValue: false,
      ) as bool);

  @override
  bool openReadWrite() => (super.noSuchMethod(
        Invocation.method(
          #openReadWrite,
          [],
        ),
        returnValue: false,
      ) as bool);

  @override
  bool close() => (super.noSuchMethod(
        Invocation.method(
          #close,
          [],
        ),
        returnValue: false,
      ) as bool);

  @override
  _i7.Uint8List read(
    int? bytes, {
    int? timeout = -1,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #read,
          [bytes],
          {#timeout: timeout},
        ),
        returnValue: _i7.Uint8List(0),
      ) as _i7.Uint8List);

  @override
  int write(
    _i7.Uint8List? bytes, {
    int? timeout = -1,
  }) =>
      (super.noSuchMethod(
        Invocation.method(
          #write,
          [bytes],
          {#timeout: timeout},
        ),
        returnValue: 0,
      ) as int);

  @override
  void flush([int? buffers = 3]) => super.noSuchMethod(
        Invocation.method(
          #flush,
          [buffers],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void drain() => super.noSuchMethod(
        Invocation.method(
          #drain,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  bool startBreak() => (super.noSuchMethod(
        Invocation.method(
          #startBreak,
          [],
        ),
        returnValue: false,
      ) as bool);

  @override
  bool endBreak() => (super.noSuchMethod(
        Invocation.method(
          #endBreak,
          [],
        ),
        returnValue: false,
      ) as bool);
}

/// A class which mocks [SerialPortFactory].
///
/// See the documentation for Mockito's code generation for more information.
class MockSerialPortFactory extends _i1.Mock implements _i8.SerialPortFactory {
  MockSerialPortFactory() {
    _i1.throwOnMissingStub(this);
  }

  @override
  List<String> getAvailablePorts() => (super.noSuchMethod(
        Invocation.method(
          #getAvailablePorts,
          [],
        ),
        returnValue: <String>[],
      ) as List<String>);

  @override
  _i3.SerialPort createSerialPort(String? portName) => (super.noSuchMethod(
        Invocation.method(
          #createSerialPort,
          [portName],
        ),
        returnValue: _FakeSerialPort_1(
          this,
          Invocation.method(
            #createSerialPort,
            [portName],
          ),
        ),
      ) as _i3.SerialPort);

  @override
  _i3.SerialPortReader createSerialPortReader(_i3.SerialPort? port) =>
      (super.noSuchMethod(
        Invocation.method(
          #createSerialPortReader,
          [port],
        ),
        returnValue: _FakeSerialPortReader_2(
          this,
          Invocation.method(
            #createSerialPortReader,
            [port],
          ),
        ),
      ) as _i3.SerialPortReader);
}

/// A class which mocks [SerialPortReader].
///
/// See the documentation for Mockito's code generation for more information.
class MockSerialPortReader extends _i1.Mock implements _i3.SerialPortReader {
  MockSerialPortReader() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.SerialPort get port => (super.noSuchMethod(
        Invocation.getter(#port),
        returnValue: _FakeSerialPort_1(
          this,
          Invocation.getter(#port),
        ),
      ) as _i3.SerialPort);

  @override
  _i5.Stream<_i7.Uint8List> get stream => (super.noSuchMethod(
        Invocation.getter(#stream),
        returnValue: _i5.Stream<_i7.Uint8List>.empty(),
      ) as _i5.Stream<_i7.Uint8List>);

  @override
  void close() => super.noSuchMethod(
        Invocation.method(
          #close,
          [],
        ),
        returnValueForMissingStub: null,
      );
}
