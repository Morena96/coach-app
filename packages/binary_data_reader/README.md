# Binary Data Processor for Dart

The Binary Data Processor is a Dart package designed for efficient processing of binary data streams, converting them into Dart objects. Leveraging a modular design, it provides developers with the tools to parse and process binary data streams according to custom-defined structures and protocols.

## Features

- Streamlined processing of binary data streams.
- Customizable parsing strategies for diverse data formats.
- Efficient conversion of binary data to Dart objects.
- Conversion of Dart objects into binary.
- Sending of binary commands.
- Supports custom command processing and frame parsing.

## Installation

Add this package to your project by including the following in your pubspec.yaml file:

```
dependencies:
  binary_data_processor: ^1.0.0
```

## Usage

### To use the Binary Data Processor, follow these steps:

#### Instantiate a DataSource, FramesProcessor, ParsingStrategy & StorageAdapter

##### Usage

```
  // Create the DataManager
  DataManager dataManager = DataManager(
    dataSource: MockDataSource(),
    framesProcessor: FramesProcessor(),
    parsingStrategy: GatewayParsingStrategy(),
    storageAdapter: NullStorageAdapter()
  );

  // Initialize the DataManager.  Once you initialize the data manager
  // the data will start streaming
  await dataManager.initialize();

  // Subscribe to the data stream to process Commands as they 
  // are received.
  dataManager.processedDataStream.listen((Command command) {
    /// process command. There are many different types of commands
    /// for the protocol.
  });

  // When done, dispose of the DataManager resources
  await dataManager.dispose();

  // To send commands, first set the channel
  dataManager.setCommunicationChannel(new NullCommunicationChannel);
  
  dataManager.issueCommand(new SetModeCommand());
```


#### DataSource

A DataSource can be implementmented by extending the abstract class DataSource.

##### Implementing DataSource with BLE
Implementing a DataSource class that fetches data from a Bluetooth Low Energy (BLE) device involves interfacing with the BLE hardware through your Dart application. This example assumes you are using the Flutter framework, which is a popular choice for building cross-platform applications in Dart, including those that require BLE communication.

The DataSource class will be responsible for establishing a connection with a BLE device, subscribing to notifications for a specific characteristic (which is how data is typically received from BLE devices), and forwarding the received data to whoever is interested (in this case, potentially the DataManager).

For BLE communication in Flutter, the flutter_blue package is a widely used option. It provides a straightforward API for scanning, connecting to BLE devices, and interacting with their services and characteristics.

Here's an example using flutter_blue
```
class BleDataSource implements DataSource {
  FlutterBlue flutterBlue = FlutterBlue.instance;
  StreamController<List<int>> _dataController = StreamController.broadcast();
  Stream<List<int>> get dataStream => _dataController.stream;

  // Specify the BLE device's ID and the characteristic you're interested in
  final String targetDeviceId;
  final Guid serviceUuid;
  final Guid characteristicUuid;

  BleDataSource({required this.targetDeviceId, required this.serviceUuid, required this.characteristicUuid});

  @override
  Future<void> initialize() async {
    // Start scanning
    flutterBlue.startScan(timeout: Duration(seconds: 4));

    // Listen for scan results
    flutterBlue.scanResults.listen((List<ScanResult> results) async {
      for (ScanResult result in results) {
        if (result.device.id.id == targetDeviceId) {
          // Stop scanning
          flutterBlue.stopScan();

          await _connectAndListenToDevice(result.device);
          break;
        }
      }
    });
  }

  Future<void> _connectAndListenToDevice(BluetoothDevice device) async {
    await device.connect();
    List<BluetoothService> services = await device.discoverServices();
    for (BluetoothService service in services) {
      if (service.uuid == serviceUuid) {
        for (BluetoothCharacteristic characteristic in service.characteristics) {
          if (characteristic.uuid == characteristicUuid) {
            // Subscribe to notifications
            characteristic.setNotifyValue(true);
            characteristic.value.listen((value) {
              // Forward the data
              _dataController.add(value);
            });
          }
        }
      }
    }
  }

  @override
  Future<void> dispose() async {
    await _dataController.close();
    // Add additional cleanup if necessary, like disconnecting from the device
  }
}
```

And then using the BleDataSource
```
void main() async {
  BleDataSource bleDataSource = BleDataSource(
    targetDeviceId: "YourBLEDeviceID",
    serviceUuid: Guid("YourServiceUUID"),
    characteristicUuid: Guid("YourCharacteristicUUID"),
  );

  bleDataSource.initialize();

  bleDataSource.dataStream.listen((List<int> data) {
    // Handle the incoming data
    print("Received data: $data");
  });

  // When done, don't forget to dispose of the data source
  // await bleDataSource.dispose();
}
```

#### FramesProcessor, ParsingStrategy & StorageAdapter

This README section provides a brief overview of key components within our Dart project, focusing on the FramesProcessor, ParsingStrategy, and StorageAdapter. Understanding these components will help you grasp how the project processes, parses, and stores data.

```
     +--------------+
     |  DataSource  |    ---->  StorageAdapter
     +------+-------+
            |
            v
+-----------+------------+
|  FramesParser          |   * Finds Frames using parsing strategy (i.e
|  w/ ParsingStrategy    |     locates header, command, size, payload, crc etc)
+-----------+------------+
            |
            v
     +------+-------+
     |FramesProcessor|  * Turns the Frame into a Payload
     +------+-------+
```


##### FramesProcessor
The FramesProcessor is responsible for converting a stream of raw binary data into a stream of higher-level Frame objects according to specified parsing rules. It listens to an input stream of Uint8List binary data chunks, applies a parsing strategy to identify and extract frames from the data, and emits these frames as a stream for further processing or analysis.

Available FrameProcessors: **FramesProcessor**


##### ParsingStrategy

A ParsingStrategy defines the logic for parsing raw binary data into frames. It encapsulates the rules and algorithms needed to identify the start and end of each frame, validate the frame's integrity, and extract relevant information or payload from the frame.

Available ParsingStrategies: **GatewayParsingStrategy**

##### StorageAdapter

The StorageAdapter provides a unified interface for storing data in various storage systems (e.g., local filesystem, cloud storage like AWS S3). It abstracts away the specifics of each storage mechanism, allowing the application to save data without being coupled to a particular storage implementation.

Available StorageAdapters: ***LocalStorageAdapter**, **NullStorageAdapter**


## Example

For a detailed example, refer to the example directory in the package.

## Contributing

Contributions to improve the Binary Data Processor are welcome. Please refer to the CONTRIBUTING.md for guidelines.

## Running Tests

Our project uses Dart's robust testing framework to ensure code quality and reliability. Follow these steps to run the test suite for this project:

### Prerequisites

Before running the tests, make sure you have Dart installed on your system. You can download and install Dart SDK from the official Dart site.

Additionally, ensure you have all the necessary dependencies for the project, including test-related packages, by running:

```
dart pub get
```

### Running Tests
```
dart test
```

## License

This project is not open source and is available under a private license. Use of this package is subject to the terms and conditions outlined in the license agreement provided with the package. Unauthorized copying, sharing, distribution, or use of this software and its documentation, without express written permission from the author(s) or owner(s), is strictly prohibited.

For more information on licensing, including how to obtain a license for commercial use, please contact the author(s) directly.
