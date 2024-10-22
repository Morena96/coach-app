import 'dart:typed_data';

import 'package:binary_data_reader/main.dart';

class CommandSender {
  final CommunicationChannel channel;

  CommandSender(this.channel);

  void sendCommand(Command command) {
    Frame frame = Frame.fromCommand(command, channel.parsingStrategy);
    Uint8List binaryData = frame.toBinary(channel.parsingStrategy);
    channel.send(binaryData);
  }

}
