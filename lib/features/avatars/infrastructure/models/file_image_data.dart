import 'dart:io';

import 'package:domain/features/avatars/entities/image_data.dart';

class FileImageData implements ImageData {
  final File file;

  FileImageData(this.file);

  @override
  List<int> getBytes() => file.readAsBytesSync();
}
