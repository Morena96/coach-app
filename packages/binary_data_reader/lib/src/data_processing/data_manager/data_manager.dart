import 'dart:async';
import 'dart:typed_data';
import 'package:binary_data_reader/src/command_sending/command_sender.dart';
import 'package:binary_data_reader/src/command_sending/communication_channel.dart';
import 'package:binary_data_reader/src/commands/models/command.dart';
import 'package:binary_data_reader/src/data_processing/frames_parser/frames_processor.dart';
import 'package:binary_data_reader/src/data_processing/storage_adapter/storage_adapter.dart';
import 'package:binary_data_reader/src/utils/logging/logger.dart';
import 'data_source/data_source.dart';
import 'package:binary_data_reader/src/data_processing/frames_parser/frames_parser.dart';
import 'package:binary_data_reader/src/data_processing/parsing_strategies/parsing_strategy.dart';

class DataManager {
  final DataSource dataSource;
  final FramesProcessor frameProcessor;
  final FrameParsingStrategy parsingStrategy;
  final StorageAdapter storageAdapter;
  final Logger? logger;
  CommandSender? _sender;

  late final StreamSubscription<Command> _dataSourceSubscription;
  late final StreamSubscription<Uint8List> _dataStreamSubscription;
  late final FramesParser framesParser;

  final StreamController<Command> _processedDataStreamController =
      StreamController.broadcast();

  DataManager({
    required this.dataSource,
    required this.frameProcessor,
    required this.parsingStrategy,
    required this.storageAdapter,
    this.logger,
  }) {
    framesParser = FramesParser(parsingStrategy);
    logger?.log('DataManager instance created.');
  }

  Future<void> initialize() async {
    logger?.log('DataManager initialization started.');
    await storageAdapter.initialize();
    await dataSource.initialize();

    Stream<Uint8List> dataStream = dataSource.dataStream.asBroadcastStream();

    _dataStreamSubscription = dataStream.listen((Uint8List data) {
      logger
          ?.log(data.toList().map((byte) => byte.toRadixString(16).padLeft(2, '0')).join(' '));
      storageAdapter.write(data);
    });

    _dataSourceSubscription =
        frameProcessor.process(framesParser.parse(dataStream)).listen(
      (Command payload) {
        logger?.log('Data processed: $payload');
        _processedDataStreamController.add(payload);
      },
      onError: (error) {
        // Handle errors or forward them to another stream/controller if necessary.
        logger?.log('Error processing data stream: $error');
      },
    );
  }

  Future<void> dispose() async {
    logger?.log('DataManager disposal started.');
    await _dataSourceSubscription.cancel();
    await _dataStreamSubscription.cancel();
    await _processedDataStreamController.close();

    await dataSource.dispose();
    await storageAdapter.finalize();
    logger?.log('DataManager disposal completed.');
  }

  Stream<Command> get processedDataStream =>
      _processedDataStreamController.stream;

  void issueCommand(Command command) {
    logger?.log('Command issued: $command');
    if (_sender == null) {
      throw Exception("Communication channel not set.");
    }
    _sender!.sendCommand(command);
    logger?.log('Data Sent: ${command.serialize()}');
  }

  void setCommunicationChannel(CommunicationChannel channel) {
    _sender = CommandSender(channel);
    logger?.log('Communication channel set.');
  }
}
