import 'package:binary_data_reader/main.dart';
import 'package:domain/features/antenna_system/entities/state_type.dart';
import 'package:domain/features/antenna_system/state_machine/antenna_context.dart';
import 'package:domain/features/antenna_system/state_machine/antenna_state_machine.dart';
import 'package:domain/features/shared/utilities/binary_utils/binary_utils.dart';

abstract class AntennaState {
  final AntennaContext context;

  AntennaState(this.context);

  void onEnter(AntennaStateMachine stateMachine) {}

  void onExit() {}

  Future<void> sendCommand(Command command) async {
    var frame = Frame.fromCommand(command, context.parsingStrategy);
    var binary = frame.toBinary(context.parsingStrategy);
    await context.repository.sendCommandToAll(BinaryUtils.padBinary(binary));
  }

  Future<void> sendCommandToPort(Command command, String portName) async {
    var frame = Frame.fromCommand(command, context.parsingStrategy);
    var binary = frame.toBinary(context.parsingStrategy);
    await context.repository
        .sendCommand(portName, BinaryUtils.padBinary(binary));
  }

  void handleCommandReceived(Command command, AntennaStateMachine stateMachine);

  String get name;

  StateType get stateType;
}
