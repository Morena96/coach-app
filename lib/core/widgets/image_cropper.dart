import 'package:crop_your_image/crop_your_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

import 'package:coach_app/core/widgets/app_dialog.dart';
import 'package:coach_app/l10n.dart';
import 'package:coach_app/shared/extensions/context.dart';

/// A widget that allows users to crop an image.
/// Opens as a dialog on web and desktop, and full-screen on mobile.
/// Automatically opens the image picker when launched.
class ImageCropper extends StatelessWidget {
  /// Callback function to return the cropped image as Uint8List
  final Function(Uint8List) onCropComplete;
  final ImagePicker? imagePicker;

  const ImageCropper({
    super.key,
    required this.onCropComplete,
    this.imagePicker,
  });

  @override
  Widget build(BuildContext context) {
    return kIsWeb || !context.isMobile
        ? _ImageCropperDialog(
            onCropComplete: onCropComplete,
            imagePicker: imagePicker,
          )
        : _ImageCropperFullScreen(
            onCropComplete: onCropComplete,
            imagePicker: imagePicker,
          );
  }
}

/// Base class for image cropper content
abstract class _ImageCropperBase extends StatefulWidget {
  final Function(Uint8List) onCropComplete;
  final ImagePicker? imagePicker;

  const _ImageCropperBase({
    required this.onCropComplete,
    this.imagePicker,
  });
}

/// Mixin that provides common functionality for image cropper
mixin _ImageCropperMixin<T extends _ImageCropperBase> on State<T> {
  Uint8List? _imageData;
  final _cropController = CropController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _pickImage();
  }

  Widget buildCropWidget(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _imageData == null
            ? Center(
                child: ElevatedButton(
                onPressed: _pickImage,
                child: Text(context.l10n.selectImage),
              ))
            : AspectRatio(
                aspectRatio: 1,
                child: Crop(
                  image: _imageData!,
                  maskColor: Colors.black26,
                  controller: _cropController,
                  aspectRatio: 1,
                  initialSize: .8,
                  baseColor: context.color.tertiary,
                  onCropped: (image) => widget.onCropComplete(image),
                ),
              );
  }

  Future<void> _pickImage() async {
    setState(() => _isLoading = true);
    Uint8List? imageData;

    if (kIsWeb) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
      if (result != null) {
        imageData = result.files.single.bytes;
      }
    } else {
      final ImagePicker picker = widget.imagePicker ?? ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        // Read the file as bytes
        final bytes = await image.readAsBytes();
        // Decode the image
        final decodedImage = img.decodeImage(bytes);
        if (decodedImage != null) {
          // Re-encode as PNG
          imageData = Uint8List.fromList(img.encodePng(decodedImage));
        }
      }
    }

    if (imageData != null) {
      setState(() => _imageData = imageData);
    } else {
      // If no image was picked, close the cropper
      Navigator.of(context).pop();
    }

    setState(() => _isLoading = false);
  }

  Future<void> cropImage() async {
    if (_imageData != null) {
      try {
        _cropController.crop();
        // The result will be handled in _handleCropped
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to initiate crop: $e')),
          );
        }
      }
    }
  }
}

/// Dialog version of the image cropper
class _ImageCropperDialog extends _ImageCropperBase {
  const _ImageCropperDialog({
    required super.onCropComplete,
    super.imagePicker,
  });

  @override
  State<_ImageCropperDialog> createState() => _ImageCropperDialogState();
}

class _ImageCropperDialogState extends State<_ImageCropperDialog>
    with _ImageCropperMixin {
  @override
  Widget build(BuildContext context) {
    return AppDialog(
      title: context.l10n.cropPicture,
      centerTitle: false,
      content: Container(
        constraints: const BoxConstraints(maxHeight: 400),
        height: MediaQuery.of(context).size.height * .4,
        margin: const EdgeInsets.only(top: 20),
        child: buildCropWidget(context),
      ),
      actionsDirection: ActionsDirection.horizontal,
      actions: [
        Expanded(
          child: OutlinedButton(
            child: Text(context.l10n.cancel),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: ElevatedButton(
            onPressed: _imageData != null ? cropImage : null,
            child: Text(context.l10n.save),
          ),
        ),
      ],
    );
  }
}

/// Full-screen version of the image cropper
class _ImageCropperFullScreen extends _ImageCropperBase {
  const _ImageCropperFullScreen({
    required super.onCropComplete,
    super.imagePicker,
  });

  @override
  State<_ImageCropperFullScreen> createState() =>
      _ImageCropperFullScreenState();
}

class _ImageCropperFullScreenState extends State<_ImageCropperFullScreen>
    with _ImageCropperMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.cropPicture),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _imageData != null ? cropImage : null,
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: buildCropWidget(context),
    );
  }
}
