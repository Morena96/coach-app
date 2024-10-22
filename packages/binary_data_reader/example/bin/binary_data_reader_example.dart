import 'dart:async';

import 'package:binary_data_reader/main.dart';
import 'package:binary_data_reader/src/data_processing/data_manager/data_manager.dart';
import 'package:binary_data_reader/src/data_processing/data_manager/data_source/mock_data_source.dart';
import 'package:binary_data_reader/src/data_processing/storage_adapter/null_storage_adapter.dart';
import 'package:binary_data_reader/src/data_processing/parsing_strategies/gateway_parsing_strategy.dart';
import 'package:binary_data_reader/src/data_processing/frames_parser/frames_processor.dart';
import 'package:binary_data_reader/src/commands/models/command.dart';
import 'package:binary_data_reader/src/commands/command_producer.dart';
import 'package:binary_data_reader/src/commands/models/set_power_command.dart';
import 'package:binary_data_reader/src/commands/command_types.dart';
import 'package:binary_data_reader/src/command_sending/null_communication_channel.dart';

void main() {
  runExample();
}

Future<void> runExample() async {
  MockDataSource dataSource = MockDataSource();
  GatewayParsingStrategy parsingStrategy = GatewayParsingStrategy();
  FramesProcessor frameProcessor = FramesProcessor(parsingStrategy);

  DataManager dataManager = DataManager(
    dataSource: dataSource,
    frameProcessor: frameProcessor,
    parsingStrategy: parsingStrategy,
    storageAdapter: NullStorageAdapter(),
  );

  await dataManager.initialize();

  // Assuming DataManager exposes a processedDataStream of some form.
  StreamSubscription subscription = dataManager.processedDataStream.listen(
    (Command command) {
      print("Received processed data with command id: ");
      print(command.commandId.toString()); // Handle processed data
    },
    onError: (error) {
      print("Error in processed data stream: $error");
    },
  );

  // Keep the subscription and dataManager active for a duration,
  // then clean up resources. Adjust the duration as needed for your test.
  await Future.delayed(Duration(seconds: 20));
  await subscription.cancel();
  await dataManager.dispose();

  // issue command's by instantiating a command with the required properties
  // and sending it to the dataManager's command sender.
  CommandProducer producer = CommandProducer();

  // you can use the command producer to create a command from properties
  SetPowerCommand commandFromProducer = producer
      .createCommandFromProperties<SetPowerCommand>(CommandTypes.SET_POWER, {
    'power': 1,
  });

  // or you can create a command directly
  SetPowerCommand commandFromInstantiation = SetPowerCommand(power: 1);

  // Make sure the data manager has a communication channel set up
  dataManager.setCommunicationChannel(NullCommunicationChannel());

  // Send the command to the data manager
  dataManager.issueCommand(commandFromProducer);
}
