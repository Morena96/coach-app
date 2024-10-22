// Mocks generated by Mockito 5.4.4 from annotations
// in domain/test/unit/features/antenna_system/entities/idle_state_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;
import 'dart:typed_data' as _i5;

import 'package:binary_data_reader/main.dart' as _i7;
import 'package:domain/features/antenna_system/entities/antenna_state.dart'
    as _i2;
import 'package:domain/features/antenna_system/repositories/antenna_command_repository.dart'
    as _i3;
import 'package:domain/features/antenna_system/state_machine/antenna_state_machine.dart'
    as _i6;
import 'package:domain/features/antenna_system/value_objects/antenna_config.dart'
    as _i8;
import 'package:domain/features/logging/entities/log_entry.dart' as _i10;
import 'package:domain/features/logging/repositories/logger.dart' as _i9;
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

class _FakeAntennaState_0 extends _i1.SmartFake implements _i2.AntennaState {
  _FakeAntennaState_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [AntennaCommandRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockAntennaCommandRepository extends _i1.Mock
    implements _i3.AntennaCommandRepository {
  MockAntennaCommandRepository() {
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
  _i4.Future<void> closePort(String? portName) => (super.noSuchMethod(
        Invocation.method(
          #closePort,
          [portName],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);

  @override
  _i4.Future<void> closeAllPorts() => (super.noSuchMethod(
        Invocation.method(
          #closeAllPorts,
          [],
        ),
        returnValue: _i4.Future<void>.value(),
        returnValueForMissingStub: _i4.Future<void>.value(),
      ) as _i4.Future<void>);
}

/// A class which mocks [AntennaStateMachine].
///
/// See the documentation for Mockito's code generation for more information.
class MockAntennaStateMachine extends _i1.Mock
    implements _i6.AntennaStateMachine {
  MockAntennaStateMachine() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.AntennaState get currentState => (super.noSuchMethod(
        Invocation.getter(#currentState),
        returnValue: _FakeAntennaState_0(
          this,
          Invocation.getter(#currentState),
        ),
      ) as _i2.AntennaState);

  @override
  _i4.Stream<_i2.AntennaState> get stateStream => (super.noSuchMethod(
        Invocation.getter(#stateStream),
        returnValue: _i4.Stream<_i2.AntennaState>.empty(),
      ) as _i4.Stream<_i2.AntennaState>);

  @override
  void sendCommand(_i7.Command? command) => super.noSuchMethod(
        Invocation.method(
          #sendCommand,
          [command],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i4.Future<bool> transitionToCommandMode(String? portName) =>
      (super.noSuchMethod(
        Invocation.method(
          #transitionToCommandMode,
          [portName],
        ),
        returnValue: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);

  @override
  _i4.Future<bool> transitionToLiveMode(String? portName) =>
      (super.noSuchMethod(
        Invocation.method(
          #transitionToLiveMode,
          [portName],
        ),
        returnValue: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);

  @override
  _i4.Future<bool> setConfig(
    _i8.AntennaConfig? config,
    String? portName,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #setConfig,
          [
            config,
            portName,
          ],
        ),
        returnValue: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);

  @override
  void setAllPodsToLive(String? portName) => super.noSuchMethod(
        Invocation.method(
          #setAllPodsToLive,
          [portName],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void setAllPodsToStandby(String? portName) => super.noSuchMethod(
        Invocation.method(
          #setAllPodsToStandby,
          [portName],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void setAllPodsToDownload(String? portName) => super.noSuchMethod(
        Invocation.method(
          #setAllPodsToDownload,
          [portName],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void setState(_i2.AntennaState? newState) => super.noSuchMethod(
        Invocation.method(
          #setState,
          [newState],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void startCalibration() => super.noSuchMethod(
        Invocation.method(
          #startCalibration,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void enterLiveMode() => super.noSuchMethod(
        Invocation.method(
          #enterLiveMode,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [LoggerRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockLoggerRepository extends _i1.Mock implements _i9.LoggerRepository {
  MockLoggerRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Stream<_i10.LogEntry> get logStream => (super.noSuchMethod(
        Invocation.getter(#logStream),
        returnValue: _i4.Stream<_i10.LogEntry>.empty(),
      ) as _i4.Stream<_i10.LogEntry>);

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
  _i4.Future<List<_i10.LogEntry>> getLogsByPage(
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
        returnValue: _i4.Future<List<_i10.LogEntry>>.value(<_i10.LogEntry>[]),
      ) as _i4.Future<List<_i10.LogEntry>>);
}

/// A class which mocks [Command].
///
/// See the documentation for Mockito's code generation for more information.
class MockCommand extends _i1.Mock implements _i7.Command {
  MockCommand() {
    _i1.throwOnMissingStub(this);
  }

  @override
  int get commandId => (super.noSuchMethod(
        Invocation.getter(#commandId),
        returnValue: 0,
      ) as int);

  @override
  _i5.Uint8List serialize() => (super.noSuchMethod(
        Invocation.method(
          #serialize,
          [],
        ),
        returnValue: _i5.Uint8List(0),
      ) as _i5.Uint8List);
}
