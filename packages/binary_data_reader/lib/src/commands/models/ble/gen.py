commands = {
    "WHO_AM_I": "0x00",
    "DOWNLOAD_SEND_RECAP_TRAME": "0x01",
    "DOWNLOAD_SEND_END_RECAP_TRAME": "0x02",
    "DOWNLOAD_ACK_SOFT": "0x03",
    "DOWNLOAD_START_DOWNLOAD": "0x04",
    "DOWNLOAD_SEND_PROGRESS_SEARCH": "0x05",
    "DOWNLOAD_GET_TRAME_IN_RECAP": "0x06",
    "DOWNLOAD_SEND_TRAME_IN_RECAP": "0x07",
    "DOWNLOAD_SEND_TRAME_IN_RECAP_SECOND": "0x08",
    "DOWNLOAD_GET_CRASH_LOG": "0x09",
    "DOWNLOAD_GET_CURRENT_BLOCK_LOGS": "0x0A",
    "DOWNLOAD_GET_LOG_IN_RECAP": "0x0B",
    "DOWNLOAD_SEND_LOGS_IN_RECAP": "0x0C",
    "DOWNLOAD_SEND_LOGS_IN_RECAP_SECOND": "0x0D",
    "START_LIVE_MODE": "0x0E",
    "STOP_LIVE_MODE": "0x0F",
}

template = """
import 'dart:typed_data';
import 'package:binary_data_reader/main.dart';
import 'package:binary_data_reader/src/commands/command_types.dart';

class {class_name}Command extends Stv4BaseCommand {{
  @override
  int get commandId => BLECommandTypes.{command_name};

  @override
  Uint8List generatePayload() {{
   return Uint8List(0);
  }}
}}
"""

def camel_case(name):
    return ''.join(word.title() for word in name.split('_'))

def snake_case(name):
    return ''.join(f"_{c.lower()}" if c.isupper() else c for c in name)

for command_name, command_id in commands.items():
    class_name = camel_case(command_name.lower())
    class_definition = template.format(class_name=class_name, command_name=command_name)
    # Create the file
    with open(f"{snake_case(command_name.lower())}.dart", "w") as file:
        file.write(class_definition)