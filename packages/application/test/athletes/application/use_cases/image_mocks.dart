import 'dart:io';

import 'package:application/avatars/image_data_factory.dart';
import 'package:domain/features/avatars/entities/image_data.dart';

class MockImageDataFactory implements ImageDataFactory {
  @override
  ImageData createFromBytes(List<int> bytes) => MockImageData();

  @override
  ImageData createFromFile(File file) => MockImageData();
}

class MockImageData implements ImageData {
  @override
  List<int> getBytes() {
    // TODO: implement getBytes
    throw UnimplementedError();
  }
}
