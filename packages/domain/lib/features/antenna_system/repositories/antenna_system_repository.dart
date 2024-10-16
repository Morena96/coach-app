import 'package:domain/features/antenna_system/entities/antenna_info.dart';

enum AntennaSystemState { connected, disconnected, error }

/// Abstract class defining the methods to get the antenna system state
/// and a list of available antennas
abstract class AntennaSystemRepository {
  Stream<(AntennaSystemState, List<AntennaInfo>)> getAntennaSystemStream();
}
