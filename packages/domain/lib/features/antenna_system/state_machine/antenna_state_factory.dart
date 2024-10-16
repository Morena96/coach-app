import 'package:domain/features/antenna_system/entities/antenna_state.dart';
import 'package:domain/features/antenna_system/entities/state_type.dart';
import 'package:domain/features/antenna_system/state_machine/antenna_context.dart';

abstract class AntennaStateFactory {
  AntennaState createState(StateType stateType, AntennaContext stateMachine);
}
