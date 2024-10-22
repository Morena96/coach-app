import 'package:binary_data_reader/src/commands/command_factory.dart';
import 'package:binary_data_reader/src/commands/command_types.dart';
import 'package:binary_data_reader/src/commands/factories/add_firmware_to_bootloader_command_factory.dart';
import 'package:binary_data_reader/src/commands/factories/ble/ble_cmd_ota_dfu_ack_command_factory.dart';
import 'package:binary_data_reader/src/commands/factories/ble/ble_cmd_ota_dfu_begin_command_factory.dart';
import 'package:binary_data_reader/src/commands/factories/ble/ble_cmd_ota_dfu_data_command_factory.dart';
import 'package:binary_data_reader/src/commands/factories/ble/ble_cmd_ota_dfu_done_command_factory.dart';
import 'package:binary_data_reader/src/commands/factories/ble/download_frame_a_factory.dart';
import 'package:binary_data_reader/src/commands/factories/ble/download_frame_b_factory.dart';
import 'package:binary_data_reader/src/commands/factories/ble/download_frame_factory.dart';
import 'package:binary_data_reader/src/commands/factories/ble/download_get_crash_log_factory.dart';
import 'package:binary_data_reader/src/commands/factories/ble/download_get_current_block_logs_factory.dart';
import 'package:binary_data_reader/src/commands/factories/ble/download_get_log_in_recap_factory.dart';

import 'package:binary_data_reader/src/commands/factories/ble/download_send_logs_in_recap_factory.dart';
import 'package:binary_data_reader/src/commands/factories/ble/download_send_logs_in_recap_second_factory.dart';

import 'package:binary_data_reader/src/commands/factories/ble/download_start_download_factory.dart';
import 'package:binary_data_reader/src/commands/factories/ble/start_live_mode_factory.dart';
import 'package:binary_data_reader/src/commands/factories/ble/stop_live_mode_factory.dart';

import 'package:binary_data_reader/src/commands/factories/check_validity_command_factory.dart';
import 'package:binary_data_reader/src/commands/factories/current_status_command_factory.dart';
import 'package:binary_data_reader/src/commands/factories/erase_memory_command_factory.dart';
import 'package:binary_data_reader/src/commands/factories/get_config_command_factory.dart';
import 'package:binary_data_reader/src/commands/factories/get_status_command_factory.dart';
import 'package:binary_data_reader/src/commands/factories/is_bootloader_command_factory.dart';
import 'package:binary_data_reader/src/commands/factories/live_frame_command_factory.dart';
import 'package:binary_data_reader/src/commands/factories/live_frame_instant_command_factory.dart';
import 'package:binary_data_reader/src/commands/factories/mode_change_command_factory.dart';
import 'package:binary_data_reader/src/commands/factories/mode_command_command_factory.dart';
import 'package:binary_data_reader/src/commands/factories/mode_live_command_factory.dart';
import 'package:binary_data_reader/src/commands/factories/receive_from_rf_factory.dart';
import 'package:binary_data_reader/src/commands/factories/reset_command_factory.dart';
import 'package:binary_data_reader/src/commands/factories/scan_rf_command_factory.dart';
import 'package:binary_data_reader/src/commands/factories/send_then_receive_command_factory.dart';
import 'package:binary_data_reader/src/commands/factories/send_to_rf_command_factory.dart';
import 'package:binary_data_reader/src/commands/factories/set_config_command_factory.dart';
import 'package:binary_data_reader/src/commands/factories/set_frequency_command_factory.dart';
import 'package:binary_data_reader/src/commands/factories/set_mode_command_factory.dart';
import 'package:binary_data_reader/src/commands/factories/set_name_command_factory.dart';
import 'package:binary_data_reader/src/commands/factories/set_power_command_factory.dart';
import 'package:binary_data_reader/src/commands/factories/set_state_command_factory.dart';
import 'package:binary_data_reader/src/commands/factories/tic_gateway_command_factory.dart';
import 'package:binary_data_reader/src/commands/factories/upgrade_to_master_factory.dart';
import 'package:binary_data_reader/src/commands/factories/write_memory_command_factory.dart';

class CommandRegistry {
  static final Map<int, CommandFactory> factories = {
    CommandTypes.MODE_COMMAND: ModeCommandCommandFactory(),
    CommandTypes.MODE_LIVE: ModeLiveCommandFactory(),
    CommandTypes.SEND_TO_RF: SendToRfCommandFactory(),
    CommandTypes.RECEIVE_FROM_RF: ReceiveFromRfFactory(),
    CommandTypes.SEND_THEN_RECEIVE: SendThenReceiveCommandFactory(),
    CommandTypes.SET_FREQUENCY: SetFrequencyCommandFactory(),
    CommandTypes.SET_POWER: SetPowerCommandFactory(),
    CommandTypes.SET_MODE: SetModeCommandFactory(),
    CommandTypes.SET_CONFIG: SetConfigCommandFactory(),
    CommandTypes.GET_CONFIG: GetConfigCommandFactory(),
    CommandTypes.LIVE: LiveFrameCommandFactory(),
    CommandTypes.RESET: ResetCommandFactory(),
    CommandTypes.SET_STATE: SetStateCommandFactory(),
    CommandTypes.TIC_GATEWAY: TicGatewayCommandFactory(),
    CommandTypes.SCAN_RF: ScanRfCommandFactory(),
    CommandTypes.IS_BOOTLOADER: IsBootloaderCommandFactory(),
    CommandTypes.ERASE_MEMORY: EraseMemoryCommandFactory(),
    CommandTypes.WRITE_MEMORY: WriteMemoryCommandFactory(),
    CommandTypes.CHECK_VALIDITY: CheckValidityCommandFactory(),
    CommandTypes.ADD_FIRMWARE_TO_BOOTLOADER: AddFirmwareToBootloaderFactory(),
    CommandTypes.UPGRADE_TO_MASTER: UpgradeToMasterFactory(),
  };

  static final Map<int, CommandFactory> bleFactories = {
    BLECommandTypes.DOWNLOAD_START_DOWNLOAD:
        DownloadStartDownloadCommandFactory(),
    BLECommandTypes.DOWNLOAD_GET_CRASH_LOG: DownloadGetCrashLogCommandFactory(),
    BLECommandTypes.DOWNLOAD_GET_CURRENT_BLOCK_LOGS:
        DownloadGetCurrentBlockLogsCommandFactory(),
    BLECommandTypes.DOWNLOAD_GET_LOG_IN_RECAP:
        DownloadGetLogInRecapCommandFactory(),
    BLECommandTypes.DOWNLOAD_SEND_LOGS_IN_RECAP:
        DownloadSendLogsInRecapCommandFactory(),
    BLECommandTypes.DOWNLOAD_SEND_LOGS_IN_RECAP_SECOND:
        DownloadSendLogsInRecapSecondCommandFactory(),
    BLECommandTypes.START_LIVE_MODE: StartLiveModeCommandFactory(),
    BLECommandTypes.STOP_LIVE_MODE: StopLiveModeCommandFactory(),
    BLECommandTypes.LIVE_FRAME: LiveFrameCommandFactory(),
    BLECommandTypes.SET_NAME: SetNameCommandFactory(),
    BLECommandTypes.GET_STATUS: GetStatusCommandFactory(),
    BLECommandTypes.CURRENT_STATUS: CurrentStatusCommandFactory(),
    BLECommandTypes.MODE_CHANGE: ModeChangeCommandFactory(),
    BLECommandTypes.BLE_CMD_OTA_DFU_BEGIN: BleCmdOtaDfuBeginCommandFactory(),
    BLECommandTypes.BLE_CMD_OTA_DFU_DATA: BleCmdOtaDfuDataCommandFactory(),
    BLECommandTypes.BLE_CMD_OTA_DFU_DONE: BleCmdOtaDfuDoneCommandFactory(),
    BLECommandTypes.BLE_CMD_OTA_DFU_ACK: BleCmdOtaDfuAckCommandFactory(),
    BLECommandTypes.RECEIVE_LIVE_MODE: LiveFrameCommandFactory(),
    BLECommandTypes.RECEIVE_LIVE_INSTANT_MODE: LiveFrameInstantCommandFactory(),
    BLECommandTypes.RECEIVE_DOWNLOAD: DownloadFrameFactory(),
    BLECommandTypes.DOWNLOAD_FRAME_A: DownloadFrameAFactory(),
    BLECommandTypes.DOWNLOAD_FRAME_B: DownloadFrameBFactory(),
  };
}
