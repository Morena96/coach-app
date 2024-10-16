// Mocks generated by Mockito 5.4.4 from annotations
// in domain/test/unit/features/antenna_system/state_machine/antenna_system_state_machine_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i8;
import 'dart:typed_data' as _i9;

import 'package:binary_data_reader/main.dart' as _i7;
import 'package:domain/features/antenna_system/calibration/calibration_manager.dart'
    as _i14;
import 'package:domain/features/antenna_system/calibration/calibration_notifier.dart'
    as _i6;
import 'package:domain/features/antenna_system/entities/antenna_state.dart'
    as _i2;
import 'package:domain/features/antenna_system/entities/calibration_result.dart'
    as _i15;
import 'package:domain/features/antenna_system/entities/calibration_state.dart'
    as _i16;
import 'package:domain/features/antenna_system/entities/state_type.dart'
    as _i13;
import 'package:domain/features/antenna_system/repositories/antenna_command_repository.dart'
    as _i5;
import 'package:domain/features/antenna_system/repositories/antenna_data_repository.dart'
    as _i4;
import 'package:domain/features/antenna_system/state_machine/antenna_context.dart'
    as _i3;
import 'package:domain/features/antenna_system/state_machine/antenna_state_machine.dart'
    as _i10;
import 'package:domain/features/antenna_system/value_objects/antenna_config.dart'
    as _i11;
import 'package:domain/features/logging/entities/log_entry.dart' as _i18;
import 'package:domain/features/logging/repositories/logger.dart' as _i17;
import 'package:domain/features/shared/utilities/reactive_stream.dart' as _i19;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i12;

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

class _FakeAntennaContext_1 extends _i1.SmartFake
    implements _i3.AntennaContext {
  _FakeAntennaContext_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeAntennaDataRepository_2 extends _i1.SmartFake
    implements _i4.AntennaDataRepository {
  _FakeAntennaDataRepository_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeAntennaCommandRepository_3 extends _i1.SmartFake
    implements _i5.AntennaCommandRepository {
  _FakeAntennaCommandRepository_3(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeCalibrationNotifier_4 extends _i1.SmartFake
    implements _i6.CalibrationNotifier {
  _FakeCalibrationNotifier_4(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeFrameParsingStrategy_5 extends _i1.SmartFake
    implements _i7.FrameParsingStrategy {
  _FakeFrameParsingStrategy_5(
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
    implements _i5.AntennaCommandRepository {
  MockAntennaCommandRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i8.Future<void> sendCommand(
    String? portName,
    _i9.Uint8List? command,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #sendCommand,
          [
            portName,
            command,
          ],
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);

  @override
  _i8.Future<void> sendCommandToAll(_i9.Uint8List? command) =>
      (super.noSuchMethod(
        Invocation.method(
          #sendCommandToAll,
          [command],
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);

  @override
  _i8.Future<void> closePort(String? portName) => (super.noSuchMethod(
        Invocation.method(
          #closePort,
          [portName],
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);

  @override
  _i8.Future<void> closeAllPorts() => (super.noSuchMethod(
        Invocation.method(
          #closeAllPorts,
          [],
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);
}

/// A class which mocks [AntennaStateMachine].
///
/// See the documentation for Mockito's code generation for more information.
class MockAntennaStateMachine extends _i1.Mock
    implements _i10.AntennaStateMachine {
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
  _i8.Stream<_i2.AntennaState> get stateStream => (super.noSuchMethod(
        Invocation.getter(#stateStream),
        returnValue: _i8.Stream<_i2.AntennaState>.empty(),
      ) as _i8.Stream<_i2.AntennaState>);

  @override
  void sendCommand(_i7.Command? command) => super.noSuchMethod(
        Invocation.method(
          #sendCommand,
          [command],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i8.Future<bool> transitionToCommandMode() => (super.noSuchMethod(
        Invocation.method(
          #transitionToCommandMode,
          [],
        ),
        returnValue: _i8.Future<bool>.value(false),
      ) as _i8.Future<bool>);

  @override
  _i8.Future<bool> transitionToLiveMode() => (super.noSuchMethod(
        Invocation.method(
          #transitionToLiveMode,
          [],
        ),
        returnValue: _i8.Future<bool>.value(false),
      ) as _i8.Future<bool>);

  @override
  _i8.Future<bool> setConfig(_i11.AntennaConfig? config) => (super.noSuchMethod(
        Invocation.method(
          #setConfig,
          [config],
        ),
        returnValue: _i8.Future<bool>.value(false),
      ) as _i8.Future<bool>);

  @override
  void setAllPodsToLive() => super.noSuchMethod(
        Invocation.method(
          #setAllPodsToLive,
          [],
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

/// A class which mocks [AntennaState].
///
/// See the documentation for Mockito's code generation for more information.
class MockAntennaState extends _i1.Mock implements _i2.AntennaState {
  MockAntennaState() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.AntennaContext get context => (super.noSuchMethod(
        Invocation.getter(#context),
        returnValue: _FakeAntennaContext_1(
          this,
          Invocation.getter(#context),
        ),
      ) as _i3.AntennaContext);

  @override
  String get name => (super.noSuchMethod(
        Invocation.getter(#name),
        returnValue: _i12.dummyValue<String>(
          this,
          Invocation.getter(#name),
        ),
      ) as String);

  @override
  _i13.StateType get stateType => (super.noSuchMethod(
        Invocation.getter(#stateType),
        returnValue: _i13.StateType.idle,
      ) as _i13.StateType);

  @override
  void onEnter(_i10.AntennaStateMachine? stateMachine) => super.noSuchMethod(
        Invocation.method(
          #onEnter,
          [stateMachine],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void onExit() => super.noSuchMethod(
        Invocation.method(
          #onExit,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i8.Future<void> sendCommand(_i7.Command? command) => (super.noSuchMethod(
        Invocation.method(
          #sendCommand,
          [command],
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);

  @override
  void handleCommandReceived(
    _i7.Command? command,
    _i10.AntennaStateMachine? stateMachine,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #handleCommandReceived,
          [
            command,
            stateMachine,
          ],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [ModeCommandCommand].
///
/// See the documentation for Mockito's code generation for more information.
class MockModeCommandCommand extends _i1.Mock
    implements _i7.ModeCommandCommand {
  MockModeCommandCommand() {
    _i1.throwOnMissingStub(this);
  }

  @override
  int get commandId => (super.noSuchMethod(
        Invocation.getter(#commandId),
        returnValue: 0,
      ) as int);

  @override
  _i9.Uint8List generatePayload() => (super.noSuchMethod(
        Invocation.method(
          #generatePayload,
          [],
        ),
        returnValue: _i9.Uint8List(0),
      ) as _i9.Uint8List);

  @override
  void setArbitraryPayload(_i9.Uint8List? payload) => super.noSuchMethod(
        Invocation.method(
          #setArbitraryPayload,
          [payload],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i9.Uint8List getPayload() => (super.noSuchMethod(
        Invocation.method(
          #getPayload,
          [],
        ),
        returnValue: _i9.Uint8List(0),
      ) as _i9.Uint8List);

  @override
  _i9.Uint8List serialize() => (super.noSuchMethod(
        Invocation.method(
          #serialize,
          [],
        ),
        returnValue: _i9.Uint8List(0),
      ) as _i9.Uint8List);
}

/// A class which mocks [ModeLiveCommand].
///
/// See the documentation for Mockito's code generation for more information.
class MockModeLiveCommand extends _i1.Mock implements _i7.ModeLiveCommand {
  MockModeLiveCommand() {
    _i1.throwOnMissingStub(this);
  }

  @override
  int get commandId => (super.noSuchMethod(
        Invocation.getter(#commandId),
        returnValue: 0,
      ) as int);

  @override
  _i9.Uint8List generatePayload() => (super.noSuchMethod(
        Invocation.method(
          #generatePayload,
          [],
        ),
        returnValue: _i9.Uint8List(0),
      ) as _i9.Uint8List);

  @override
  void setArbitraryPayload(_i9.Uint8List? payload) => super.noSuchMethod(
        Invocation.method(
          #setArbitraryPayload,
          [payload],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i9.Uint8List getPayload() => (super.noSuchMethod(
        Invocation.method(
          #getPayload,
          [],
        ),
        returnValue: _i9.Uint8List(0),
      ) as _i9.Uint8List);

  @override
  _i9.Uint8List serialize() => (super.noSuchMethod(
        Invocation.method(
          #serialize,
          [],
        ),
        returnValue: _i9.Uint8List(0),
      ) as _i9.Uint8List);
}

/// A class which mocks [CalibrationManager].
///
/// See the documentation for Mockito's code generation for more information.
class MockCalibrationManager extends _i1.Mock
    implements _i14.CalibrationManager {
  MockCalibrationManager() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.AntennaDataRepository get dataRepository => (super.noSuchMethod(
        Invocation.getter(#dataRepository),
        returnValue: _FakeAntennaDataRepository_2(
          this,
          Invocation.getter(#dataRepository),
        ),
      ) as _i4.AntennaDataRepository);

  @override
  _i5.AntennaCommandRepository get commandRepository => (super.noSuchMethod(
        Invocation.getter(#commandRepository),
        returnValue: _FakeAntennaCommandRepository_3(
          this,
          Invocation.getter(#commandRepository),
        ),
      ) as _i5.AntennaCommandRepository);

  @override
  _i6.CalibrationNotifier get notifier => (super.noSuchMethod(
        Invocation.getter(#notifier),
        returnValue: _FakeCalibrationNotifier_4(
          this,
          Invocation.getter(#notifier),
        ),
      ) as _i6.CalibrationNotifier);

  @override
  _i7.FrameParsingStrategy get parsingStrategy => (super.noSuchMethod(
        Invocation.getter(#parsingStrategy),
        returnValue: _FakeFrameParsingStrategy_5(
          this,
          Invocation.getter(#parsingStrategy),
        ),
      ) as _i7.FrameParsingStrategy);

  @override
  int get currentStep => (super.noSuchMethod(
        Invocation.getter(#currentStep),
        returnValue: 0,
      ) as int);

  @override
  set currentStep(int? _currentStep) => super.noSuchMethod(
        Invocation.setter(
          #currentStep,
          _currentStep,
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i8.Future<_i15.CalibrationResult?> startCalibration() => (super.noSuchMethod(
        Invocation.method(
          #startCalibration,
          [],
        ),
        returnValue: _i8.Future<_i15.CalibrationResult?>.value(),
      ) as _i8.Future<_i15.CalibrationResult?>);

  @override
  void handleCalibrationResponse(_i7.ScanRfCommand? command) =>
      super.noSuchMethod(
        Invocation.method(
          #handleCalibrationResponse,
          [command],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [CalibrationState].
///
/// See the documentation for Mockito's code generation for more information.
class MockCalibrationState extends _i1.Mock implements _i16.CalibrationState {
  MockCalibrationState() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get name => (super.noSuchMethod(
        Invocation.getter(#name),
        returnValue: _i12.dummyValue<String>(
          this,
          Invocation.getter(#name),
        ),
      ) as String);

  @override
  _i13.StateType get stateType => (super.noSuchMethod(
        Invocation.getter(#stateType),
        returnValue: _i13.StateType.idle,
      ) as _i13.StateType);

  @override
  _i3.AntennaContext get context => (super.noSuchMethod(
        Invocation.getter(#context),
        returnValue: _FakeAntennaContext_1(
          this,
          Invocation.getter(#context),
        ),
      ) as _i3.AntennaContext);

  @override
  void onEnter(_i10.AntennaStateMachine? stateMachine) => super.noSuchMethod(
        Invocation.method(
          #onEnter,
          [stateMachine],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void handleCommandReceived(
    _i7.Command? command,
    _i10.AntennaStateMachine? stateMachine,
  ) =>
      super.noSuchMethod(
        Invocation.method(
          #handleCommandReceived,
          [
            command,
            stateMachine,
          ],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void onExit() => super.noSuchMethod(
        Invocation.method(
          #onExit,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i8.Future<void> sendCommand(_i7.Command? command) => (super.noSuchMethod(
        Invocation.method(
          #sendCommand,
          [command],
        ),
        returnValue: _i8.Future<void>.value(),
        returnValueForMissingStub: _i8.Future<void>.value(),
      ) as _i8.Future<void>);
}

/// A class which mocks [LoggerRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockLoggerRepository extends _i1.Mock implements _i17.LoggerRepository {
  MockLoggerRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i8.Stream<_i18.LogEntry> get logStream => (super.noSuchMethod(
        Invocation.getter(#logStream),
        returnValue: _i8.Stream<_i18.LogEntry>.empty(),
      ) as _i8.Stream<_i18.LogEntry>);

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
}

/// A class which mocks [ReactiveStream].
///
/// See the documentation for Mockito's code generation for more information.
class MockReactiveStream<T> extends _i1.Mock implements _i19.ReactiveStream<T> {
  MockReactiveStream() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i8.Stream<T> get stream => (super.noSuchMethod(
        Invocation.getter(#stream),
        returnValue: _i8.Stream<T>.empty(),
      ) as _i8.Stream<T>);

  @override
  void add(T? event) => super.noSuchMethod(
        Invocation.method(
          #add,
          [event],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void close() => super.noSuchMethod(
        Invocation.method(
          #close,
          [],
        ),
        returnValueForMissingStub: null,
      );
}
