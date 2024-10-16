import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:coach_app/core/widgets/app_dialog.dart';
import 'package:coach_app/core/widgets/image_cropper.dart';

import '../../widget_tree.dart';
import 'image_cropper_test.mocks.dart';

@GenerateMocks([ImagePicker])
void main() {
  late MockImagePicker mockImagePicker;

  setUp(() {
    mockImagePicker = MockImagePicker();
  });

  Widget buildTestWidget(Function(Uint8List) onCropComplete) {
    return createWidgetTree(
      child: Builder(
        builder: (BuildContext context) => ElevatedButton(
          onPressed: () => showDialog(
            context: context,
            builder: (_) => ImageCropper(
              onCropComplete: onCropComplete,
              imagePicker: mockImagePicker,
            ),
          ),
          child: const Text('Open Cropper'),
        ),
      ),
    );
  }

  testWidgets('ImageCropper automatically opens image picker on launch',
      (WidgetTester tester) async {
    final mockImage = XFile('test_path');
    when(mockImagePicker.pickImage(source: ImageSource.gallery))
        .thenAnswer((_) => Future.value(mockImage));

    await tester.pumpWidget(buildTestWidget((_) {}));
    await tester.tap(find.text('Open Cropper'));

    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    verify(mockImagePicker.pickImage(source: ImageSource.gallery)).called(1);

    expect(find.byType(AppDialog), findsOneWidget);
  });

  testWidgets('ImageCropper closes if no image is selected',
      (WidgetTester tester) async {
    when(mockImagePicker.pickImage(source: ImageSource.gallery))
        .thenAnswer((_) => Future.value(null));

    await tester.pumpWidget(buildTestWidget((_) {}));
    await tester.tap(find.text('Open Cropper'));

    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(AppDialog), findsNothing);
  });

  testWidgets('Cancel button dismisses the dialog',
      (WidgetTester tester) async {
    final mockImage = XFile('test_path');
    when(mockImagePicker.pickImage(source: ImageSource.gallery))
        .thenAnswer((_) => Future.value(mockImage));

    await tester.pumpWidget(buildTestWidget((_) {}));
    await tester.tap(find.text('Open Cropper'));

    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    await tester.tap(find.text('Cancel'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(AppDialog), findsNothing);
  });

  testWidgets('Save button state when image is selected',
      (WidgetTester tester) async {
    final mockImage = XFile('test_path');
    when(mockImagePicker.pickImage(source: ImageSource.gallery))
        .thenAnswer((_) => Future.value(mockImage));

    await tester.pumpWidget(buildTestWidget((_) {}));
    await tester.tap(find.text('Open Cropper'));

    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    final saveButton = find.widgetWithText(ElevatedButton, 'Save');
    expect(saveButton, findsOneWidget);
  });
}
