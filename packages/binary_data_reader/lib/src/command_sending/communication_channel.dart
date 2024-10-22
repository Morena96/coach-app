import 'dart:typed_data';

import 'package:binary_data_reader/src/data_processing/parsing_strategies/parsing_strategy.dart';

abstract class CommunicationChannel {
  FrameParsingStrategy get parsingStrategy;
  void send(Uint8List data);
}
