import 'package:coach_app/features/avatars/infrastructure/services/image_format_detector_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:domain/features/images/services/image_format_service.dart';
import 'package:coach_app/features/avatars/infrastructure/services/image_format_service_impl.dart';

part 'image_format_service_provider.g.dart';

@Riverpod(keepAlive: true)
ImageFormatService imageFormatService(ImageFormatServiceRef ref) {
  final imageFormatDetector = ImageFormatDetectorImpl();
  return ImageFormatServiceImpl(imageFormatDetector);
}
