import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:binary_data_reader/src/data_processing/data_manager/data_source/data_source.dart';

class MockDataSource extends DataSource {
  final StreamController<Uint8List> _streamController =
      StreamController.broadcast();
  Timer? _timer;
  final Random _random = Random();

  @override
  Future<void> initialize() async {
    startGeneratingData();
  }

  @override
  Stream<Uint8List> get dataStream => _streamController.stream;

  @override
  Future<void> dispose() async {
    stopGeneratingData();
  }

  void startGeneratingData() {
    print('generating');
    const Duration interval = Duration(milliseconds: 50);
    _timer = Timer.periodic(interval, (Timer t) => _generateData());
  }

  void stopGeneratingData() {
    _timer?.cancel();
    _streamController.close();
  }

  void _generateData() {
    print('generate data');
    // generate random valid payload data
    Uint8List realData = Uint8List.fromList([
      0x43,
      0xF5,
      0x00,
      0x06,
      0x00,
      0x09,
      0x01,
      0x05,
      0x05,
      0x01,
      0x00,
      0x01,
      0x60,
      0x99,
      0xA2,
      0x5E
    ]);

    Uint8List fakeData =
        Uint8List.fromList(List.generate(20, (index) => _random.nextInt(256)));

    _streamController.add(fakeData);
    _streamController.add(realData);
  }
}
