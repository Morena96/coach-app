import 'package:binary_data_reader/main.dart';
import 'package:domain/features/antenna_system/entities/state_type.dart';
import 'package:domain/features/antenna_system/state_machine/antenna_context.dart';
import 'package:domain/features/antenna_system/state_machine/antenna_state_machine.dart';

abstract class AntennaState {
  final AntennaContext context;

  AntennaState(this.context);

  void onEnter(AntennaStateMachine stateMachine) {}

  void onExit() {}

  Future<void> sendCommand(Command command) async {
    var frame = Frame.fromCommand(command, context.parsingStrategy);
    await context.repository
        .sendCommandToAll(frame.toBinary(context.parsingStrategy));
  }

  void handleCommandReceived(Command command, AntennaStateMachine stateMachine);

  String get name;

  StateType get stateType;
}
