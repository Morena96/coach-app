import 'dart:typed_data';

import 'package:binary_data_reader/src/commands/models/command.dart';
import 'package:binary_data_reader/src/utils/crc32.dart';

abstract class Stv4BaseCommand implements Command {
  static const int header = 0x43F5; // Specific STV4 header

  Uint8List? _arbitraryPayload; // sometimes payloads just forward directly

  Stv4BaseCommand();

  Uint8List generatePayload();

  void setArbitraryPayload(Uint8List payload) {
    _arbitraryPayload = payload;
  }

  Uint8List getPayload() {
    // If there's an arbitrary payload set, use it; otherwise, defer to the subclass implementation
    return _arbitraryPayload ?? generatePayload();
  }

  @override
  Uint8List serialize() {
      return getPayload();
  }
}
