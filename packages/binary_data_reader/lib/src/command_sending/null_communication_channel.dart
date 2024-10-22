import 'dart:typed_data';

import 'package:binary_data_reader/main.dart';

class NullCommunicationChannel extends CommunicationChannel {

  @override
  void send(Uint8List data) {
    // Do nothing.
  }

  @override
  FrameParsingStrategy get parsingStrategy => GatewayParsingStrategy();
}
