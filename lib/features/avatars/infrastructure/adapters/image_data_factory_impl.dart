import 'dart:io';

import 'package:coach_app/features/avatars/infrastructure/models/file_image_data.dart';
import 'package:coach_app/features/avatars/infrastructure/models/memory_image_data.dart';
import 'package:domain/features/avatars/entities/image_data.dart';
import 'package:application/avatars/image_data_factory.dart';

class ImageDataFactoryImpl implements ImageDataFactory {
  @override
  ImageData createFromBytes(List<int> bytes) => MemoryImageData(bytes);

  @override
  ImageData createFromFile(File file) => FileImageData(file);
}