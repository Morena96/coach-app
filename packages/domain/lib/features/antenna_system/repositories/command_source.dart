import 'package:binary_data_reader/main.dart';

abstract class CommandSource {
  Stream<Command> getCommands();
}
