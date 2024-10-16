// Mocks generated by Mockito 5.4.4 from annotations
// in application/test/antenna_system/use_cases/send_command_to_antenna_state_machine_use_case_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;
import 'dart:typed_data' as _i11;

import 'package:application/antenna_system/hex_converter.dart' as _i12;
import 'package:binary_data_reader/main.dart' as _i5;
import 'package:domain/features/antenna_system/entities/antenna_info.dart'
    as _i9;
import 'package:domain/features/antenna_system/entities/antenna_state.dart'
    as _i2;
import 'package:domain/features/antenna_system/repositories/antenna_data_repository.dart'
    as _i10;
import 'package:domain/features/antenna_system/repositories/antenna_system_repository.dart'
    as _i8;
import 'package:domain/features/antenna_system/repositories/command_source.dart'
    as _i7;
import 'package:domain/features/antenna_system/state_machine/antenna_state_machine.dart'
    as _i3;
import 'package:domain/features/antenna_system/value_objects/antenna_config.dart'
    as _i6;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i13;

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

/// A class which mocks [AntennaStateMachine].
///
/// See the documentation for Mockito's code generation for more information.
class MockAntennaStateMachine extends _i1.Mock
    implements _i3.AntennaStateMachine {
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
  void sendCommand(_i5.Command? command) => super.noSuchMethod(
        Invocation.method(
          #sendCommand,
          [command],
        ),
        returnValueForMissingStub: null,
      );

  @override
  _i4.Future<bool> transitionToCommandMode() => (super.noSuchMethod(
        Invocation.method(
          #transitionToCommandMode,
          [],
        ),
        returnValue: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);

  @override
  _i4.Future<bool> transitionToLiveMode() => (super.noSuchMethod(
        Invocation.method(
          #transitionToLiveMode,
          [],
        ),
        returnValue: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);

  @override
  _i4.Future<bool> setConfig(_i6.AntennaConfig? config) => (super.noSuchMethod(
        Invocation.method(
          #setConfig,
          [config],
        ),
        returnValue: _i4.Future<bool>.value(false),
      ) as _i4.Future<bool>);

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

/// A class which mocks [CommandSource].
///
/// See the documentation for Mockito's code generation for more information.
class MockCommandSource extends _i1.Mock implements _i7.CommandSource {
  MockCommandSource() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Stream<_i5.Command> getCommands() => (super.noSuchMethod(
        Invocation.method(
          #getCommands,
          [],
        ),
        returnValue: _i4.Stream<_i5.Command>.empty(),
      ) as _i4.Stream<_i5.Command>);
}

/// A class which mocks [AntennaSystemRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockAntennaSystemRepository extends _i1.Mock
    implements _i8.AntennaSystemRepository {
  MockAntennaSystemRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Stream<(_i8.AntennaSystemState, List<_i9.AntennaInfo>)>
      getAntennaSystemStream() => (super.noSuchMethod(
            Invocation.method(
              #getAntennaSystemStream,
              [],
            ),
            returnValue: _i4.Stream<
                (_i8.AntennaSystemState, List<_i9.AntennaInfo>)>.empty(),
          ) as _i4.Stream<(_i8.AntennaSystemState, List<_i9.AntennaInfo>)>);
}

/// A class which mocks [AntennaDataRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockAntennaDataRepository extends _i1.Mock
    implements _i10.AntennaDataRepository {
  MockAntennaDataRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Stream<_i11.Uint8List> getDataStream(String? portName) =>
      (super.noSuchMethod(
        Invocation.method(
          #getDataStream,
          [portName],
        ),
        returnValue: _i4.Stream<_i11.Uint8List>.empty(),
      ) as _i4.Stream<_i11.Uint8List>);

  @override
  _i4.Stream<(String, _i11.Uint8List)> getAllDataStreams() =>
      (super.noSuchMethod(
        Invocation.method(
          #getAllDataStreams,
          [],
        ),
        returnValue: _i4.Stream<(String, _i11.Uint8List)>.empty(),
      ) as _i4.Stream<(String, _i11.Uint8List)>);
}

/// A class which mocks [HexConverter].
///
/// See the documentation for Mockito's code generation for more information.
class MockHexConverter extends _i1.Mock implements _i12.HexConverter {
  MockHexConverter() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Stream<String> streamToHex(_i4.Stream<_i11.Uint8List>? stream) =>
      (super.noSuchMethod(
        Invocation.method(
          #streamToHex,
          [stream],
        ),
        returnValue: _i4.Stream<String>.empty(),
      ) as _i4.Stream<String>);

  @override
  _i11.Uint8List hexToBytes(String? hex) => (super.noSuchMethod(
        Invocation.method(
          #hexToBytes,
          [hex],
        ),
        returnValue: _i11.Uint8List(0),
      ) as _i11.Uint8List);

  @override
  String bytesToHex(_i11.Uint8List? bytes) => (super.noSuchMethod(
        Invocation.method(
          #bytesToHex,
          [bytes],
        ),
        returnValue: _i13.dummyValue<String>(
          this,
          Invocation.method(
            #bytesToHex,
            [bytes],
          ),
        ),
      ) as String);
}