import 'package:domain/features/antenna_system/entities/antenna_state.dart';
import 'package:domain/features/antenna_system/entities/command_mode_state.dart';
import 'package:domain/features/antenna_system/entities/error_state.dart';
import 'package:domain/features/antenna_system/entities/idle_state.dart';
import 'package:domain/features/antenna_system/entities/live_mode_state.dart';
import 'package:domain/features/antenna_system/entities/pending_command_mode_state.dart';
import 'package:domain/features/antenna_system/entities/pending_live_mode_state.dart';
import 'package:domain/features/antenna_system/entities/state_type.dart';
import 'package:domain/features/antenna_system/state_machine/antenna_context.dart';
import 'package:domain/features/antenna_system/state_machine/antenna_state_factory.dart';

class AntennaStateFactoryImpl implements AntennaStateFactory {
  final Map<StateType, AntennaState Function(AntennaContext)> _stateCreators;

  AntennaStateFactoryImpl(context)
      : _stateCreators = {
          StateType.idle: (context) => IdleState(context),
          StateType.pendingCommandMode: (context) =>
              PendingCommandModeState(context),
          StateType.commandMode: (context) => CommandModeState(context),
          StateType.pendingLiveMode: (context) => PendingLiveModeState(context),
          StateType.liveMode: (context) => LiveModeState(context),
          StateType.error: (context) => ErrorState(context, 'Unknown error'),
        };

  @override
  AntennaState createState(StateType stateType, AntennaContext context) {
    final creator = _stateCreators[stateType];
    if (creator == null) {
      throw ArgumentError('Unknown state type: $stateType');
    }
    return creator(context);
  }
}
