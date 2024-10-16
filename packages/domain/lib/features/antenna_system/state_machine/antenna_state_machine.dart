import 'dart:async';

import 'package:binary_data_reader/main.dart';
import 'package:domain/features/antenna_system/calibration/calibration_service.dart';
import 'package:domain/features/antenna_system/entities/antenna_state.dart';
import 'package:domain/features/antenna_system/entities/calibration_state.dart';
import 'package:domain/features/antenna_system/entities/command_mode_state.dart';
import 'package:domain/features/antenna_system/entities/idle_state.dart';
import 'package:domain/features/antenna_system/entities/live_mode_state.dart';
import 'package:domain/features/antenna_system/entities/pending_live_mode_state.dart';
import 'package:domain/features/antenna_system/entities/state_type.dart';
import 'package:domain/features/antenna_system/state_machine/antenna_context.dart';
import 'package:domain/features/antenna_system/state_machine/antenna_state_factory.dart';
import 'package:domain/features/antenna_system/state_machine/antenna_state_factory_impl.dart';
import 'package:domain/features/antenna_system/value_objects/antenna_config.dart';
import 'package:domain/features/shared/utilities/reactive_stream.dart';

/// AntennaStateMachine is a state machine that manages the state of the antenna system.
/// It listens to commands and updates the state accordingly.
/// It also provides a stream of the current state.
class AntennaStateMachine {
  /// The current state of the state machine.
  AntennaState _currentState;

  /// The calibration service used to calibrate the antenna system.
  final CalibrationService? _calibrationService;

  final AntennaStateFactory _antennaStateFactory;

  final AntennaContext _context;

  /// The subscription to the command stream.
  late StreamSubscription<Command> _commandSubscription;

  /// The stream controller for the state stream.
  final ReactiveStream<AntennaState> _stateSubject;

  /// The current state of the state machine.
  AntennaState get currentState => _currentState;

  /// The stream of the current state.
  Stream<AntennaState> get stateStream => _stateSubject.stream;

  final Map<Type, Completer<bool>> _pendingAcks = {};

  final Duration _timeout;

  AntennaStateMachine(
    AntennaContext context,
    Stream<Command> commandStream,
    ReactiveStream<AntennaState> stateSubject, {
    CalibrationService? calibrationService,
    Duration? commandTimeout,
  })  : _currentState = IdleState(context),
        _context = context,
        _calibrationService = calibrationService,
        _timeout = commandTimeout ?? const Duration(seconds: 5),
        _antennaStateFactory = AntennaStateFactoryImpl(context),
        _stateSubject = stateSubject {
    _commandSubscription = commandStream.listen(_handleCommandReceived);
    _stateSubject.add(_currentState);
  }

  /// Sends a command to the current state.
  void sendCommand(Command command) {
    _currentState.sendCommand(command);
  }

  void _sendCommandToAll(Command command) {
    var frame = Frame.fromCommand(command, _context.parsingStrategy);
    _context.repository
        .sendCommandToAll(frame.toBinary(_context.parsingStrategy));
  }

  Future<bool> _sendCommandAndWaitForAck(
      Command command, Type expectedAckType) async {
    if (_pendingAcks.containsKey(expectedAckType)) {
      throw StateError(
          'Already waiting for an acknowledgment of type $expectedAckType');
    }

    final completer = Completer<bool>();
    _pendingAcks[expectedAckType] = completer;

    var frame = Frame.fromCommand(command, _context.parsingStrategy);

    await _context.repository
        .sendCommandToAll(frame.toBinary(_context.parsingStrategy));

    try {
      return await completer.future.timeout(_timeout);
    } on TimeoutException {
      _context.logger.warning('Timeout waiting for $expectedAckType');
      _pendingAcks.remove(expectedAckType);
      return false;
    }
  }

  Future<bool> transitionToCommandMode() async {
    if (_currentState is CommandModeState) return true;

    setState(_antennaStateFactory.createState(
        StateType.pendingCommandMode, _context));
    bool success = await _sendCommandAndWaitForAck(
        ModeCommandCommand(), ModeCommandCommand);

    if (success) {
      setState(
          _antennaStateFactory.createState(StateType.commandMode, _context));
      return true;
    } else {
      setState(_antennaStateFactory.createState(StateType.idle, _context));
      return false;
    }
  }

  Future<bool> transitionToLiveMode() async {
    if (_currentState is LiveModeState) return true;

    setState(
        _antennaStateFactory.createState(StateType.pendingLiveMode, _context));
    bool success =
        await _sendCommandAndWaitForAck(ModeLiveCommand(), ModeLiveCommand);

    if (success) {
      setState(_antennaStateFactory.createState(StateType.liveMode, _context));
      return true;
    } else {
      setState(
          _antennaStateFactory.createState(StateType.commandMode, _context));
      return false;
    }
  }

  Future<bool> setConfig(AntennaConfig config) async {
    if (_currentState is! CommandModeState) {
      _context.logger.warning('Cannot set config when not in CommandModeState');
      return false;
    }

    var setConfigCommand = SetConfigCommand(
      masterId: config.masterId,
      frequency: config.frequency,
      // Default value, should be updated with actual frequency
      mainFrequency: config.mainFrequency,
      // Default value, should be updated with actual main frequency
      isMain: config.isMain,
      // Default value, should be updated based on actual configuration
      clubId:
          config.clubId, // Default value, should be updated with actual club ID
    );
    bool success =
        await _sendCommandAndWaitForAck(setConfigCommand, SetConfigCommand);

    if (success) {
      _context.logger.info('Config set successfully');
      return true;
    } else {
      _context.logger.warning('Failed to set config');
      return false;
    }
  }

  void setAllPodsToLive() async {
    if (_currentState is! LiveModeState) {
      _context.logger
          .warning('Cannot set pod config when not in LiveModeState');
        return;
    }

    var setConfigCommand = SetStateCommand(
        rfSlotStates: List.generate(15, (_) => SensorMode.live));

    _sendCommandToAll(setConfigCommand);
  }

  /// Sets the state of the state machine.
  void setState(AntennaState newState) {
    _currentState.onExit();
    _currentState = newState;
    _currentState.onEnter(this);
    _emitState();
    _context.logger.debug('State changed to ${_currentState.name}');
  }

  void startCalibration() {
    if (_calibrationService == null) {
      _context.logger.error('Calibration service not provided');
      throw StateError('Calibration service not provided');
    }

    setState(CalibrationState(_context, _calibrationService));
  }

  void enterLiveMode() {
    setState(PendingLiveModeState(_context));
  }

  void _handleCommandReceived(Command command) {
    final ackType = command.runtimeType;
    if (_pendingAcks.containsKey(ackType)) {
      _pendingAcks[ackType]!.complete(true);
      _pendingAcks.remove(ackType);
    }
    _currentState.handleCommandReceived(command, this);
  }

  void _emitState() {
    _stateSubject.add(_currentState);
  }

  void dispose() {
    _commandSubscription.cancel();
    _stateSubject.close();
  }
}
