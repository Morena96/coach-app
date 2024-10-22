// ignore_for_file: constant_identifier_names

class CommandTypes {
  // Modes
  static const int MODE_COMMAND = 0x01;
  static const int MODE_LIVE = 0x02;

  // RF
  static const int SEND_TO_RF = 0x03;
  static const int RECEIVE_FROM_RF = 0x04;
  static const int SEND_THEN_RECEIVE = 0x05;
  static const int SET_FREQUENCY = 0x06;
  static const int SET_POWER = 0x07;
  static const int SET_MODE = 0x08;
  static const int SET_CONFIG = 0x09;
  static const int GET_CONFIG = 0x0A;

  // Other
  static const int LIVE = 0x0B;
  static const int RESET = 0x0D; // NOT SURE where 0x0C is?
  static const int SET_STATE = 0x0E;
  static const int TIC_GATEWAY = 0x0F;
  static const int SCAN_RF = 0x10;
  static const int IS_BOOTLOADER = 0x11;

  // Firmware
  static const int SET_CONFIGURATION_FIRMWARE = 0x12;
  static const int ERASE_MEMORY = 0x13;
  static const int WRITE_MEMORY = 0x14;
  static const int CHECK_VALIDITY = 0x15;

  static const int ADD_FIRMWARE_TO_BOOTLOADER = 0x16;
  static const int UPGRADE_TO_MASTER = 0x17;
}

class BLECommandTypes {
  static const int DOWNLOAD_GET_CRASH_LOG = 0x09;
  static const int DOWNLOAD_GET_CURRENT_BLOCK_LOGS = 0x0A;
  static const int DOWNLOAD_GET_LOG_IN_RECAP = 0x0B;
  static const int DOWNLOAD_SEND_LOGS_IN_RECAP = 0x0C;
  static const int DOWNLOAD_SEND_LOGS_IN_RECAP_SECOND = 0x0D;
  static const int LIVE_FRAME = 0x10;

  // Client to server (0x00 + x)
  static const int GET_STATUS = 0x00;
  static const int BLE_CMD_OTA_DFU_BEGIN = 0x01;
  static const int BLE_CMD_OTA_DFU_DATA = 0x02;
  static const int BLE_CMD_OTA_DFU_DONE = 0x03;
  static const int DOWNLOAD_START_DOWNLOAD = 0x04;
  static const int DOWNLOAD_FRAME_A = 0x82;
  static const int DOWNLOAD_FRAME_B = 0x83;
  static const int START_LIVE_MODE = 0x05;
  static const int STOP_LIVE_MODE = 0x06;
  static const int SET_NAME = 0x07;

  // Server to client (0x80 + x)
  static const int CURRENT_STATUS = 0x80;
  static const int BLE_CMD_OTA_DFU_ACK = 0x81;
  static const int MODE_CHANGE = 0x87;

  // custom normalized command ids (not received from FW)
  static const int RECEIVE_LIVE_MODE = 0x1010;
  static const int RECEIVE_LIVE_INSTANT_MODE = 0x1011;
  static const int RECEIVE_DOWNLOAD = 0x1012;
}
