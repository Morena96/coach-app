import 'package:domain/features/avatars/entities/image_data.dart';
import 'package:equatable/equatable.dart';

class MemoryImageData extends Equatable implements ImageData {
  final List<int> bytes;

  const MemoryImageData(this.bytes);

  @override
  List<int> getBytes() => bytes;

  @override
  List<Object?> get props => [bytes];
}