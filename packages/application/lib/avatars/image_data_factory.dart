import 'dart:io';

import 'package:domain/features/avatars/entities/image_data.dart';

abstract class ImageDataFactory {
  ImageData createFromBytes(List<int> bytes);
  ImageData createFromFile(File file);
}