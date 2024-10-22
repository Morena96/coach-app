#!/bin/bash

# Function to convert file names to CamelCase class names
to_camel_case() {
    echo "$1" | awk -F'_' '{for(i=1; i<=NF; i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2));}1' OFS=""
}

# File names as provided
declare -a file_names=(
    "check_validity_command"
    "erase_memory_command"
    "get_config_command"
    "is_bootloader_command"
    "live_frame_command"
    "mode_command_command"
    "mode_live_command"
    "receive_from_rf"
    "reset_command"
    "scan_rf_command"
    "send_then_receive_command"
    "send_to_rf_command"
    "set_config_command"
    "set_configuration_firmware_command"
    "set_frequency_command"
    "set_mode_command"
    "set_power_command"
    "set_state_command"
    "tic_gateway_command"
    "upgrade_to_master"
    "write_memory_command"
)

# Iterate over each file name
for file_name in "${file_names[@]}"; do
    # Convert file name to CamelCase
    class_name=$(to_camel_case "${file_name}")

    # Create the file with the content
    cat >"${file_name}_factory.dart" <<EOF
import 'dart:typed_data';
import 'package:binary_data_reader/src/commands/command_factory.dart';
import 'package:binary_data_reader/src/commands/models/${file_name}.dart';
import 'package:binary_data_reader/src/commands/models/command.dart';
class ${class_name}Factory extends CommandFactory {
  @override
  Command fromBinary(Uint8List data) {
    return ${class_name}();
  }

  @override
  Command fromProperties(Map<String, dynamic> properties) {
    return ${class_name}();
  }
}
EOF
done
