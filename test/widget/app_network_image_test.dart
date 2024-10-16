import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:coach_app/core/theme/app_colors.dart';
import 'package:coach_app/core/widgets/app_network_image.dart';

void main() {
  group('AppNetworkImage', () {
    testWidgets('renders CachedNetworkImage with correct properties',
        (WidgetTester tester) async {
      const imagePath = 'https://example.com/image.jpg';
      const size = 100.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: AppNetworkImage(imagePath: imagePath, size: size),
        ),
      );

      final sizedBox = find.byType(SizedBox).first;
      expect(sizedBox, findsWidgets);

      final sizedBoxWidget = tester.widget<SizedBox>(sizedBox);
      expect(sizedBoxWidget.width, size);
      expect(sizedBoxWidget.height, size);

      final cachedNetworkImage = find.byType(CachedNetworkImage);
      expect(cachedNetworkImage, findsOneWidget);

      final cachedNetworkImageWidget =
          tester.widget<CachedNetworkImage>(cachedNetworkImage);
      expect(cachedNetworkImageWidget.imageUrl, imagePath);
      expect(cachedNetworkImageWidget.fit, BoxFit.cover);
    });

    testWidgets('uses _Placeholder for placeholder and error widget',
        (WidgetTester tester) async {
      const imagePath = 'https://example.com/image.jpg';
      const size = 100.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppNetworkImage(imagePath: imagePath, size: size),
          ),
        ),
      );

      final BuildContext context = tester.element(find.byType(AppNetworkImage));

      final cachedNetworkImageFinder = find.byType(CachedNetworkImage);
      final cachedNetworkImageWidget =
          tester.widget<CachedNetworkImage>(cachedNetworkImageFinder);

      // Test placeholder
      final placeholderWidget =
          cachedNetworkImageWidget.placeholder!(context, '');
      expect(placeholderWidget, isA<AppNetworkImagePlaceholder>());
    });
  });

  group('AppNetworkImagePlaceholder', () {
    testWidgets('renders correctly with given size',
        (WidgetTester tester) async {
      const size = 100.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: AppNetworkImagePlaceholder(size),
        ),
      );

      final container = find.byType(Container);
      expect(container, findsOneWidget);

      final containerWidget = tester.widget<Container>(container);
      expect(containerWidget.constraints?.minWidth, size);
      expect(containerWidget.constraints?.minHeight, size);

      expect(find.byType(Icon), findsOneWidget);
      expect(find.byIcon(CupertinoIcons.person_alt), findsOneWidget);
    });

    testWidgets('applies correct styling', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AppNetworkImagePlaceholder(null),
        ),
      );

      final container = find.byType(Container);
      final containerWidget = tester.widget<Container>(container);

      expect(containerWidget.padding, const EdgeInsets.all(4));

      final decoration = containerWidget.decoration as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(8));
      expect(decoration.color, const Color(0x1a1d1b20));

      final icon = find.byType(Icon);
      final iconWidget = tester.widget<Icon>(icon);
      expect(iconWidget.color, AppColors.grey200);
    });
  });
}
